/// Hasil submit form autentikasi.
class AuthSubmitOutcome {
  const AuthSubmitOutcome({
    this.requiresEmailConfirmation = false,
    this.email = '',
  });

  /// `true` bila akun berhasil dibuat tetapi belum aktif
  /// sampai user mengklik tautan verifikasi di email.
  final bool requiresEmailConfirmation;

  /// Email yang dipakai saat mendaftar, untuk layar verifikasi & kirim ulang.
  final String email;

  /// User dianggap sudah punya sesi dan boleh masuk ke beranda.
  bool get isAuthenticated => !requiresEmailConfirmation;
}
