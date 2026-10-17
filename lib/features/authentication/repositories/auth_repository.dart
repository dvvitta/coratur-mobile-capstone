abstract class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
}
