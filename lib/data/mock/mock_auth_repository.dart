import '../../features/authentication/models/auth_user.dart';
import '../../features/authentication/repositories/auth_repository.dart';

/// Auth palsu untuk demo frontend. Tidak menyimpan kredensial.
class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  @override
  Future<AuthUser?> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return AuthUser(
      id: 'mock-user-1',
      name: 'Arka',
      email: email,
    );
  }

  @override
  Future<AuthUser?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return AuthUser(
      id: 'mock-user-1',
      name: name,
      email: email,
    );
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
