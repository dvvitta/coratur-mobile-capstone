import '../../features/authentication/repositories/auth_repository.dart';

/// Auth palsu untuk demo frontend. Tidak menyimpan kredensial.
class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  @override
  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }
}
