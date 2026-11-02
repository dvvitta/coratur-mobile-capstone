import 'auth_user.dart';

/// Hasil pendaftaran akun.
///
/// [requiresEmailConfirmation] bernilai `true` saat backend/Supabase
/// mewajibkan verifikasi email sebelum user boleh login.
class RegisterResult {
  const RegisterResult({
    this.user,
    this.accessToken,
    this.requiresEmailConfirmation = false,
    this.message,
  });

  final AuthUser? user;
  final String? accessToken;
  final bool requiresEmailConfirmation;
  final String? message;
}
