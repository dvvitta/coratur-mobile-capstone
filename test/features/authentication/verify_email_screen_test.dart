import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/features/authentication/controllers/auth_controller.dart';
import 'package:curator/features/authentication/models/auth_session.dart';
import 'package:curator/features/authentication/models/auth_tab.dart';
import 'package:curator/features/authentication/models/auth_user.dart';
import 'package:curator/features/authentication/models/register_result.dart';
import 'package:curator/features/authentication/repositories/auth_repository.dart';
import 'package:curator/features/authentication/screens/auth_screen.dart';
import 'package:curator/features/authentication/screens/verify_email_screen.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.requiresEmailConfirmation = true});

  final bool requiresEmailConfirmation;
  int resendCount = 0;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    return AuthSession(
      user: AuthUser(id: '1', name: 'Psy', email: email),
      accessToken: 'fake-token',
    );
  }

  @override
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return RegisterResult(
      user: AuthUser(id: '1', name: name, email: email),
      requiresEmailConfirmation: requiresEmailConfirmation,
    );
  }

  @override
  Future<void> resendVerification({required String email}) async {
    resendCount++;
  }

  @override
  Future<void> forgotPassword({required String email}) async {}

  @override
  Future<String> verifyResetCode({
    required String email,
    required String code,
  }) async {
    return 'token';
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {}
}

void main() {
  testWidgets('daftar dengan konfirmasi email menuju layar verifikasi', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;

    final repo = _FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.verifyEmail: (context) {
            final email =
                ModalRoute.of(context)?.settings.arguments as String? ?? '';
            return VerifyEmailScreen(email: email, authRepository: repo);
          },
          AppRoutes.login: (_) => const Scaffold(body: Text('Halaman Masuk')),
        },
        home: AuthScreen(
          initialTab: AuthTab.register,
          playIntro: false,
          controller: AuthController(repository: repo),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('auth_name')), 'Psy');
    await tester.enterText(
      find.byKey(const Key('auth_email')),
      'psy@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('auth_password')),
      'password123',
    );
    await tester.enterText(
      find.byKey(const Key('auth_confirm_password')),
      'password123',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Cek email kamu'), findsOneWidget);
    expect(find.textContaining('psy@example.com'), findsOneWidget);
  });

  testWidgets('daftar tanpa konfirmasi email langsung ke beranda', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;

    final repo = _FakeAuthRepository(requiresEmailConfirmation: false);

    await tester.pumpWidget(
      MaterialApp(
        routes: {AppRoutes.home: (_) => const Scaffold(body: Text('Beranda'))},
        home: AuthScreen(
          initialTab: AuthTab.register,
          playIntro: false,
          controller: AuthController(repository: repo),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('auth_name')), 'Psy');
    await tester.enterText(
      find.byKey(const Key('auth_email')),
      'psy@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('auth_password')),
      'password123',
    );
    await tester.enterText(
      find.byKey(const Key('auth_confirm_password')),
      'password123',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Beranda'), findsOneWidget);
  });

  testWidgets('layar verifikasi menampilkan email dan bisa kirim ulang', (
    tester,
  ) async {
    final repo = _FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.login: (_) => const Scaffold(body: Text('Halaman Masuk')),
        },
        home: VerifyEmailScreen(
          email: 'psy@example.com',
          authRepository: repo,
          resendCooldown: Duration.zero,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cek email kamu'), findsOneWidget);
    expect(find.textContaining('psy@example.com'), findsOneWidget);

    await tester.tap(find.byKey(const Key('verify_email_resend')));
    await tester.pumpAndSettle();

    expect(repo.resendCount, 1);
    expect(
      find.text('Tautan verifikasi sudah dikirim ulang. Cek inbox kamu.'),
      findsOneWidget,
    );
  });

  testWidgets('tombol kirim ulang terkunci setelah pengiriman berhasil', (
    tester,
  ) async {
    final repo = _FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: VerifyEmailScreen(
          email: 'psy@example.com',
          authRepository: repo,
          resendCooldown: const Duration(seconds: 30),
        ),
      ),
    );
    await tester.pump();

    // Awalnya aktif supaya user bisa langsung minta email baru.
    var button = tester.widget<TextButton>(
      find.byKey(const Key('verify_email_resend')),
    );
    expect(button.onPressed, isNotNull);

    await tester.tap(find.byKey(const Key('verify_email_resend')));
    await tester.pump();
    await tester.pump();

    expect(repo.resendCount, 1);
    expect(find.textContaining('Kirim ulang email dalam'), findsOneWidget);

    button = tester.widget<TextButton>(
      find.byKey(const Key('verify_email_resend')),
    );
    expect(button.onPressed, isNull);

    // Habiskan cooldown.
    await tester.pump(const Duration(seconds: 31));
    await tester.pumpAndSettle();

    expect(find.text('Kirim ulang email verifikasi'), findsOneWidget);
  });

  testWidgets('tombol masuk membuka halaman login', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.login: (_) => const Scaffold(body: Text('Halaman Masuk')),
        },
        home: const VerifyEmailScreen(
          email: 'psy@example.com',
          resendCooldown: Duration.zero,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('verify_email_login')));
    await tester.pumpAndSettle();

    expect(find.text('Halaman Masuk'), findsOneWidget);
  });
}
