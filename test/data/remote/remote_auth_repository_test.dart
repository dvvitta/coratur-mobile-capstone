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
          jsonEncode({
            'statusCode': 409,
            'message': 'Email sudah terdaftar.',
          }),
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
  });
}
