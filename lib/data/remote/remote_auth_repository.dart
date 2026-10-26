import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/errors/app_failure.dart';
import '../../features/authentication/models/auth_user.dart';
import '../../features/authentication/repositories/auth_repository.dart';

/// Remote HTTP Auth Repository menghubungkan Flutter ke NestJS Backend.
class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Uri _uri(String path) {
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$cleanBase$cleanPath');
  }

  Map<String, String> get _headers => {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      };

  @override
  Future<AuthUser?> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final response = await _post(
      '/auth/login',
      {'email': email, 'password': password},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['user'] is Map<String, dynamic>) {
          return AuthUser.fromJson(decoded['user'] as Map<String, dynamic>);
        }
      } catch (_) {}
      return null;
    }

    _handleError(response);
  }

  @override
  Future<AuthUser?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _post(
      '/auth/register',
      {'name': name, 'email': email, 'password': password},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['user'] is Map<String, dynamic>) {
          final userJson = decoded['user'] as Map<String, dynamic>;
          return AuthUser(
            id: userJson['id'] as String? ?? '',
            name: userJson['name'] as String? ?? name,
            email: userJson['email'] as String? ?? email,
          );
        }
      } catch (_) {}
      return AuthUser(id: '', name: name, email: email);
    }

    _handleError(response);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final response = await _post(
      '/auth/forgot-password',
      {'email': email},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    _handleError(response);
  }

  @override
  Future<String> verifyResetCode({
    required String email,
    required String code,
  }) async {
    final response = await _post(
      '/auth/verify-reset-code',
      {'email': email, 'code': code},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded['reset_token'] as String? ?? '';
        }
      } catch (_) {}
      return '';
    }

    _handleError(response);
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    final response = await _post(
      '/auth/reset-password',
      {
        'reset_token': resetToken,
        'new_password': newPassword,
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    _handleError(response);
  }

  Future<http.Response> _post(String path, Map<String, dynamic> body) async {
    try {
      return await _client.post(
        _uri(path),
        headers: _headers,
        body: jsonEncode(body),
      );
    } on SocketException {
      throw const AppFailure(
        message: 'Koneksi ke server gagal. Periksa jaringan.',
        isRetryable: true,
      );
    } on http.ClientException {
      throw const AppFailure(
        message: 'Koneksi bermasalah. Coba lagi.',
        isRetryable: true,
      );
    } catch (_) {
      throw const AppFailure(
        message: 'Terjadi kesalahan jaringan.',
        isRetryable: true,
      );
    }
  }

  Never _handleError(http.Response response) {
    String message = 'Terjadi kesalahan. Coba lagi.';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['error'] is Map<String, dynamic>) {
          final errMap = decoded['error'] as Map<String, dynamic>;
          if (errMap['message'] is String && (errMap['message'] as String).isNotEmpty) {
            message = errMap['message'] as String;
          }
        } else {
          final rawMessage = decoded['message'];
          if (rawMessage is String && rawMessage.isNotEmpty) {
            message = rawMessage;
          } else if (rawMessage is List && rawMessage.isNotEmpty) {
            message = rawMessage.first.toString();
          }
        }
      }
    } catch (_) {
      // Body bukan JSON valid, gunakan fallback message
    }

    throw AppFailure(
      message: message,
      isRetryable: response.statusCode >= 500,
    );
  }
}
