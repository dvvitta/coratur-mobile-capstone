import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/errors/app_failure.dart';

/// Mengubah respons error NestJS (`{ error: { code, message, details } }`)
/// menjadi [AppFailure] yang aman ditampilkan ke UI.
AppFailure appFailureFromResponse(http.Response response) {
  var message = 'Terjadi kesalahan. Coba lagi.';
  String? code;

  try {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      final errorMap = decoded['error'];
      if (errorMap is Map<String, dynamic>) {
        if (errorMap['code'] is String) {
          code = errorMap['code'] as String;
        }
        final details = errorMap['details'];
        // Validasi DTO NestJS mengirim array pesan di field details.
        if (details is List && details.isNotEmpty) {
          message = details.map((item) => item.toString()).join('\n');
        } else if (errorMap['message'] is String &&
            (errorMap['message'] as String).isNotEmpty) {
          message = errorMap['message'] as String;
        }
      } else {
        final rawMessage = decoded['message'];
        if (rawMessage is String && rawMessage.isNotEmpty) {
          message = rawMessage;
        } else if (rawMessage is List && rawMessage.isNotEmpty) {
          message = rawMessage.map((item) => item.toString()).join('\n');
        }
      }
    }
  } catch (_) {
    // Body bukan JSON valid: pakai pesan fallback.
  }

  if (code == null && response.statusCode == 401) {
    code = 'UNAUTHENTICATED';
  }

  return AppFailure(
    message: message,
    code: code,
    isRetryable: response.statusCode >= 500,
  );
}
