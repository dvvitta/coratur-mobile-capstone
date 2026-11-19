import 'dart:typed_data';

/// Kontrak unggah foto profil ke backend/Supabase Storage.
///
/// Sambungkan implementasi nyata lewat [ProfilePhotoService] ketika bucket
/// `avatars` dan endpoint unggah sudah tersedia.
abstract class ProfilePhotoUploader {
  /// Kembalikan URL publik foto yang sudah diunggah.
  Future<String> upload(Uint8List bytes, {String? fileName});
}

/// Placeholder aman: penyimpanan lokal tetap dipakai, unggah belum aktif.
class DisabledProfilePhotoUploader implements ProfilePhotoUploader {
  const DisabledProfilePhotoUploader();

  @override
  Future<String> upload(Uint8List bytes, {String? fileName}) {
    // TODO(supabase-storage): unggah ke bucket `avatars`, lalu kembalikan URL.
    throw UnimplementedError('Unggah foto profil belum dikonfigurasi.');
  }
}
