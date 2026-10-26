import '../../../core/constants/app_routes.dart';
import '../../../core/errors/app_failure.dart';
import '../models/auth_tab.dart';
import '../models/auth_user.dart';
import '../repositories/auth_repository.dart';

class AuthController {
  AuthController({
    required this.repository,
    this.onUserAuthenticated,
  });

  final AuthRepository repository;
  final void Function(AuthUser user)? onUserAuthenticated;

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
      final AuthUser? user;
      if (tab == AuthTab.login) {
        user = await repository.login(
          email: email.trim(),
          password: password,
          rememberMe: rememberMe,
        );
      } else {
        user = await repository.register(
          name: name.trim(),
          email: email.trim(),
          password: password,
        );
      }
      if (user != null && onUserAuthenticated != null) {
        onUserAuthenticated!(user);
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
