import '../models/auth_session.dart';
import '../models/register_result.dart';

abstract class AuthRepository {
  Future<AuthSession> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> resendVerification({required String email});

  Future<void> forgotPassword({required String email});

  Future<String> verifyResetCode({required String email, required String code});

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  });
}
