import '../../features/authentication/models/auth_session.dart';
import '../../features/authentication/models/auth_user.dart';
import '../../features/authentication/models/register_result.dart';
import '../../features/authentication/repositories/auth_repository.dart';

/// Auth palsu untuk demo frontend. Tidak menyimpan kredensial.
class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return AuthSession(
      user: AuthUser(id: 'mock-user-1', name: 'Arka', email: email),
      accessToken: 'mock-access-token',
    );
  }

  @override
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return RegisterResult(
      user: AuthUser(id: 'mock-user-1', name: name, email: email),
      requiresEmailConfirmation: false,
      message: 'Akun berhasil dibuat.',
    );
  }

  @override
  Future<void> resendVerification({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<String> verifyResetCode({
    required String email,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return 'mock_reset_token_xyz';
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }
}
