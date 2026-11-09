import '../models/auth_session.dart';

abstract class GoogleAuthRepository {
  Future<AuthSession> loginWithGoogle({required String idToken});
}
