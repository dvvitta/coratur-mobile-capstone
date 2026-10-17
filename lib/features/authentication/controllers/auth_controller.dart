import '../../../core/constants/app_routes.dart';
import '../../../core/errors/app_failure.dart';
import '../models/auth_tab.dart';
import '../repositories/auth_repository.dart';

class AuthController {
  AuthController({required this.repository});

  final AuthRepository repository;

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

  Future<void> submit({
    required AuthTab tab,
    required String name,
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      if (tab == AuthTab.login) {
        await repository.login(
          email: email.trim(),
          password: password,
          rememberMe: rememberMe,
        );
      } else {
        await repository.register(
          name: name.trim(),
          email: email.trim(),
          password: password,
        );
      }
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
