import '../../../core/constants/app_routes.dart';
import '../../../core/errors/app_failure.dart';
import '../models/auth_submit_outcome.dart';
import '../models/auth_tab.dart';
import '../models/auth_user.dart';
import '../repositories/auth_repository.dart';

class AuthController {
  AuthController({required this.repository, this.onUserAuthenticated});

  final AuthRepository repository;

  /// Dipanggil setelah login/daftar berhasil, membawa token akses bila ada.
  final void Function(AuthUser user, String? accessToken)? onUserAuthenticated;

  String? validateName(String value) {
    if (value.trim().isEmpty) {
      return 'Nama pendamping wajib diisi';
    }
    return null;
  }

  String? validateEmail(String value) {
    final email = value.trim();
    if (email.isEmpty) {
      return 'Email wajib diisi';
    }
    if (!email.contains('@') || !email.contains('.')) {
      return 'Masukkan email yang valid';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  /// Backend mewajibkan minimal 8 karakter saat pendaftaran akun baru.
  String? validateRegisterPassword(String value) {
    if (value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  String? validateConfirmPassword(String value, String originalPassword) {
    if (value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != originalPassword) {
      return 'Password tidak cocok';
    }
    return null;
  }

  Future<AuthSubmitOutcome> submit({
    required AuthTab tab,
    required String name,
    required String email,
    required String password,
    String? confirmPassword,
    required bool rememberMe,
  }) async {
    try {
      if (tab == AuthTab.login) {
        final session = await repository.login(
          email: email.trim(),
          password: password,
          rememberMe: rememberMe,
        );
        onUserAuthenticated?.call(session.user, session.accessToken);
        return const AuthSubmitOutcome();
      }

      if (confirmPassword != null && confirmPassword != password) {
        throw const AppFailure(message: 'Password tidak cocok');
      }

      final result = await repository.register(
        name: name.trim(),
        email: email.trim(),
        password: password,
      );

      // Akun baru belum punya sesi selama email belum diverifikasi.
      if (result.requiresEmailConfirmation) {
        return AuthSubmitOutcome(
          requiresEmailConfirmation: true,
          email: email.trim(),
        );
      }

      final user = result.user;
      if (user != null) {
        onUserAuthenticated?.call(user, result.accessToken);
      }
      return const AuthSubmitOutcome();
    } on AppFailure {
      rethrow;
    } on Object {
      throw const AppFailure(
        message: 'Tidak bisa masuk sekarang. Coba lagi ya.',
        isRetryable: true,
      );
    }
  }

  String get homeRoute => AppRoutes.home;
  String get forgotPasswordRoute => AppRoutes.forgotPassword;
  String get onboardingRoute => AppRoutes.onboarding;
}
