import '../models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<AuthUser?> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> forgotPassword({required String email});

  Future<String> verifyResetCode({
    required String email,
    required String code,
  });

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  });
}
