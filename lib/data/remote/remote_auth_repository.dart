import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/errors/app_failure.dart';
import '../../features/authentication/models/auth_session.dart';
import '../../features/authentication/models/auth_user.dart';
import '../../features/authentication/models/register_result.dart';
import '../../features/authentication/repositories/auth_repository.dart';
import 'api_error.dart';

/// Remote HTTP Auth Repository menghubungkan Flutter ke NestJS Backend.
class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

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
  Future<AuthSession> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final response = await _post('/auth/login', {
      'email': email,
      'password': password,
    });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> &&
            decoded['user'] is Map<String, dynamic>) {
          final token = decoded['access_token'];
          return AuthSession(
            user: AuthUser.fromJson(decoded['user'] as Map<String, dynamic>),
            accessToken: token is String && token.isNotEmpty ? token : null,
          );
        }
      } catch (_) {
        // Jatuh ke error di bawah: respons backend tidak dikenali.
      }
      throw const AppFailure(
        message: 'Respons login tidak dikenali. Coba lagi.',
        isRetryable: true,
      );
    }

    _handleError(response);
  }

  @override
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final userJson = decoded['user'];
          final user = userJson is Map<String, dynamic>
              ? AuthUser(
                  id: userJson['id'] as String? ?? '',
                  name: userJson['name'] as String? ?? name,
                  email: userJson['email'] as String? ?? email,
                )
              : AuthUser(id: '', name: name, email: email);

          return RegisterResult(
            user: user,
            accessToken:
                decoded['access_token'] is String &&
                    (decoded['access_token'] as String).isNotEmpty
                ? decoded['access_token'] as String
                : null,
            requiresEmailConfirmation:
                decoded['requires_email_confirmation'] as bool? ?? false,
            message: decoded['message'] as String?,
          );
        }
      } catch (_) {
        // Respons tidak terbaca: anggap pendaftaran berhasil tanpa verifikasi.
      }
      return RegisterResult(
        user: AuthUser(id: '', name: name, email: email),
      );
    }

    _handleError(response);
  }

  @override
  Future<void> resendVerification({required String email}) async {
    final response = await _post('/auth/resend-verification', {'email': email});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    _handleError(response);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final response = await _post('/auth/forgot-password', {'email': email});

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
    final response = await _post('/auth/verify-reset-code', {
      'email': email,
      'code': code,
    });

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
    final response = await _post('/auth/reset-password', {
      'reset_token': resetToken,
      'new_password': newPassword,
    });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    _handleError(response);
  }

  Future<http.Response> _post(String path, Map<String, dynamic> body) async {
    final uri = _uri(path);
    final startedAt = DateTime.now();
    // Log URL/path saja; body berisi password, jadi jangan log.
    debugPrint('[AUTH HTTP] POST $uri start');
    try {
      final response = await _client
          .post(uri, headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      debugPrint(
        '[AUTH HTTP] POST $uri status=${response.statusCode} '
        'duration=${DateTime.now().difference(startedAt).inMilliseconds}ms',
      );
      return response;
    } on TimeoutException {
      debugPrint('[AUTH HTTP] POST $uri timeout=15s');
      throw const AppFailure(
        message: 'Server terlalu lama merespons. Coba lagi.',
        isRetryable: true,
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
    throw appFailureFromResponse(response);
  }
}
