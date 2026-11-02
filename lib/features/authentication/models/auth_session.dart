import 'auth_user.dart';

/// Sesi login aktif dari backend: profil user + token akses.
///
/// Token hanya disimpan di memori untuk saat ini (belum ada penyimpanan
/// permanen/refresh otomatis).
class AuthSession {
  const AuthSession({required this.user, this.accessToken});

  final AuthUser user;
  final String? accessToken;
}
