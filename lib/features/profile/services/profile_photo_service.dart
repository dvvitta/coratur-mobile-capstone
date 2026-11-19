import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/errors/app_failure.dart';
import '../models/profile_photo.dart';
import 'profile_photo_store.dart';
import 'profile_photo_uploader.dart';

/// Logic pemilihan, validasi izin, dan penyimpanan foto profil.
/// UI tidak boleh memanggil plugin kamera/galeri secara langsung.
class ProfilePhotoService {
  ProfilePhotoService({
    ImagePicker? imagePicker,
    ProfilePhotoStore? store,
    this.uploader,
  }) : _picker = imagePicker ?? ImagePicker(),
       _store = store ?? SharedPreferencesProfilePhotoStore();

  final ImagePicker _picker;
  final ProfilePhotoStore _store;

  /// Diisi ketika backend/Supabase Storage sudah siap.
  final ProfilePhotoUploader? uploader;

  Future<ProfilePhoto?> load() => _store.read();

  Future<Uint8List?> pickFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      throw AppFailure(
        message: status.isPermanentlyDenied
            ? 'Izin kamera diblokir. Aktifkan lewat pengaturan perangkat.'
            : 'Izin kamera dibutuhkan untuk mengambil foto.',
        code: 'CAMERA_PERMISSION_DENIED',
      );
    }
    return _pick(ImageSource.camera);
  }

  Future<Uint8List?> pickFromGallery() async {
    // Android 13+ memakai Photo Picker bawaan, jadi tidak butuh izin galeri.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      final status = await Permission.photos.request();
      if (status.isPermanentlyDenied) {
        throw const AppFailure(
          message: 'Izin galeri diblokir. Aktifkan lewat pengaturan perangkat.',
          code: 'GALLERY_PERMISSION_DENIED',
        );
      }
    }
    return _pick(ImageSource.gallery);
  }

  Future<ProfilePhoto> saveCustomPhoto(Uint8List bytes) async {
    final photo = ProfilePhoto.custom(bytes);
    await _store.write(photo);
    await _tryUpload(bytes);
    return photo;
  }

  Future<ProfilePhoto> saveBuiltInAvatar(String assetPath) async {
    final photo = ProfilePhoto.builtIn(assetPath);
    await _store.write(photo);
    return photo;
  }

  Future<Uint8List?> _pick(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 90,
      );
      if (file == null) return null;
      return await file.readAsBytes();
    } on PlatformException catch (error) {
      throw AppFailure(
        message: _pickerMessage(error, source),
        code: error.code,
      );
    } on Object {
      throw AppFailure(
        message: source == ImageSource.camera
            ? 'Kamera tidak bisa dibuka. Coba lagi.'
            : 'Galeri tidak bisa dibuka. Coba lagi.',
        isRetryable: true,
      );
    }
  }

  Future<void> _tryUpload(Uint8List bytes) async {
    final uploader = this.uploader;
    if (uploader == null) return;
    try {
      await uploader.upload(
        bytes,
        fileName: 'avatar_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      // TODO(backend): simpan URL hasil upload ke profil pengguna.
    } on Object {
      // Unggah gagal tidak membatalkan penyimpanan lokal.
    }
  }

  String _pickerMessage(PlatformException error, ImageSource source) {
    switch (error.code) {
      case 'camera_access_denied':
      case 'photo_access_denied':
        return 'Izin kamera/galeri ditolak. Aktifkan lewat pengaturan.';
      case 'camera_access_restricted':
        return 'Kamera dibatasi pada perangkat ini.';
      default:
        return source == ImageSource.camera
            ? 'Kamera tidak bisa dibuka. Coba lagi.'
            : 'Galeri tidak bisa dibuka. Coba lagi.';
    }
  }
}
