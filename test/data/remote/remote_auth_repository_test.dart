import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:curator/core/errors/app_failure.dart';
import 'package:curator/data/remote/remote_auth_repository.dart';

void main() {
  const baseUrl = 'http://localhost:3000/api/v1';

  group('RemoteAuthRepository - login', () {
    test('berhasil saat status 200', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), '$baseUrl/auth/login');
        expect(request.method, 'POST');
        final body = jsonDecode(request.body);
        expect(body['email'], 'test@example.com');
        expect(body['password'], 'secret123');

        return http.Response(
          jsonEncode({
            'user': {'id': '123', 'email': 'test@example.com'},
            'access_token': 'fake_jwt_token',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final repo = RemoteAuthRepository(baseUrl: baseUrl, client: client);

      await expectLater(
        repo.login(
          email: 'test@example.com',
          password: 'secret123',
          rememberMe: false,
        ),
        completes,
      );
    });

    test('gagal lempar AppFailure dengan pesan server saat 401', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Email atau password salah.'}),
          401,
          headers: {'content-type': 'application/json'},
        );
      });

      final repo = RemoteAuthRepository(baseUrl: baseUrl, client: client);

      expect(
        () => repo.login(
          email: 'wrong@example.com',
          password: 'wrong',
          rememberMe: false,
        ),
        throwsA(
          isA<AppFailure>().having(
            (e) => e.message,
            'message',
            'Email atau password salah.',
          ),
        ),
      );
    });
  });

  group('RemoteAuthRepository - register', () {
    test('berhasil saat status 201', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), '$baseUrl/auth/register');
        final body = jsonDecode(request.body);
        expect(body['name'], 'Budi');
        expect(body['email'], 'budi@example.com');
        expect(body['password'], 'password123');

        return http.Response(
          jsonEncode({
            'user': {'id': '456', 'email': 'budi@example.com'},
            'message': 'Akun berhasil dibuat. Silakan masuk.',
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });

      final repo = RemoteAuthRepository(baseUrl: baseUrl, client: client);

      await expectLater(
        repo.register(
          name: 'Budi',
          email: 'budi@example.com',
          password: 'password123',
        ),
        completes,
      );
    });

    test('gagal lempar AppFailure saat email duplikat 409', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({'statusCode': 409, 'message': 'Email sudah terdaftar.'}),
          409,
          headers: {'content-type': 'application/json'},
        );
      });

      final repo = RemoteAuthRepository(baseUrl: baseUrl, client: client);

      expect(
        () => repo.register(
          name: 'Budi',
          email: 'budi@example.com',
          password: 'password123',
        ),
        throwsA(
          isA<AppFailure>().having(
            (e) => e.message,
            'message',
            'Email sudah terdaftar.',
          ),
        ),
      );
    });

    test('menampilkan pesan validasi dari details saat 422', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': {
              'code': 'VALIDATION_ERROR',
              'message': 'Request validation failed',
              'details': [
                'password must be longer than or equal to 8 characters',
              ],
            },
          }),
          422,
          headers: {'content-type': 'application/json'},
        );
      });

      final repo = RemoteAuthRepository(baseUrl: baseUrl, client: client);

      expect(
        () => repo.register(
          name: 'Budi',
          email: 'budi@example.com',
          password: 'short',
        ),
        throwsA(
          isA<AppFailure>().having(
            (e) => e.message,
            'message',
            'password must be longer than or equal to 8 characters',
          ),
        ),
      );
    });

    test('mengirim payload register lengkap ke backend', () async {
      late Map<String, dynamic> sentBody;
      final client = MockClient((request) async {
        sentBody = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            'user': {'id': '1', 'name': 'Budi', 'email': 'budi@example.com'},
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });

      final repo = RemoteAuthRepository(baseUrl: baseUrl, client: client);
      final result = await repo.register(
        name: 'Budi',
        email: 'budi@example.com',
        password: 'password123',
      );

      expect(sentBody, {
        'name': 'Budi',
        'email': 'budi@example.com',
        'password': 'password123',
      });
      expect(result.user?.name, 'Budi');
      expect(result.user?.email, 'budi@example.com');
      expect(result.requiresEmailConfirmation, isFalse);
    });

    test('membaca requires_email_confirmation dari backend', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'user': {'id': '2', 'name': 'Ani', 'email': 'ani@example.com'},
            'requires_email_confirmation': true,
            'message':
                'Akun berhasil dibuat. Cek email untuk verifikasi, lalu masuk.',
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });

      final repo = RemoteAuthRepository(baseUrl: baseUrl, client: client);
      final result = await repo.register(
        name: 'Ani',
        email: 'ani@example.com',
        password: 'password123',
      );

      expect(result.requiresEmailConfirmation, isTrue);
      expect(result.user?.name, 'Ani');
    });
  });

  group('RemoteAuthRepository - resendVerification', () {
    test('mengirim email ke endpoint resend-verification', () async {
      late String path;
      late Map<String, dynamic> sentBody;
      final client = MockClient((request) async {
        path = request.url.toString();
        sentBody = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({'message': 'ok'}), 202);
      });

      final repo = RemoteAuthRepository(baseUrl: baseUrl, client: client);
      await repo.resendVerification(email: 'ani@example.com');

      expect(path, '$baseUrl/auth/resend-verification');
      expect(sentBody['email'], 'ani@example.com');
    });

    test('melempar AppFailure saat backend menolak', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': {
              'code': 'TOO_MANY_REQUESTS',
              'message': 'Terlalu banyak percobaan. Coba lagi nanti.',
            },
          }),
          429,
        );
      });

      final repo = RemoteAuthRepository(baseUrl: baseUrl, client: client);

      expect(
        () => repo.resendVerification(email: 'ani@example.com'),
        throwsA(
          isA<AppFailure>().having(
            (e) => e.message,
            'message',
            'Terlalu banyak percobaan. Coba lagi nanti.',
          ),
        ),
      );
    });
  });
}
