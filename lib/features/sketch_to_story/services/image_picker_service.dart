import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Hasil operasi pick/capture gambar.
sealed class ImagePickResult {
  const ImagePickResult();
}

/// Gambar berhasil dipilih.
final class ImagePickSuccess extends ImagePickResult {
  const ImagePickSuccess(this.file);
  final File file;
}

/// User menolak izin.
final class ImagePickPermissionDenied extends ImagePickResult {
  const ImagePickPermissionDenied({this.isPermanent = false});
  /// true = user pilih "Jangan tanya lagi" → arahkan ke Settings
  final bool isPermanent;
}

/// User membatalkan (menutup picker tanpa memilih).
final class ImagePickCancelled extends ImagePickResult {
  const ImagePickCancelled();
}

/// Terjadi error tidak terduga.
final class ImagePickError extends ImagePickResult {
  const ImagePickError(this.message);
  final String message;
}

// ─────────────────────────────────────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────────────────────────────────────

/// Service yang mengabstraksi permission + image_picker.
///
/// Hanya untuk Android — iOS dikonfigurasi terpisah saat dibutuhkan.
/// Dibuat sebagai class konkret (bukan abstract) agar mudah di-mock di test.
class ImagePickerService {
  ImagePickerService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Ambil foto dari kamera.
  Future<ImagePickResult> pickFromCamera() async {
    final permission = await _requestPermission(Permission.camera);
    if (permission != _PermissionState.granted) {
      return ImagePickPermissionDenied(
        isPermanent: permission == _PermissionState.permanentlyDenied,
      );
    }
    return _pick(ImageSource.camera);
  }

  /// Pilih gambar dari galeri.
  Future<ImagePickResult> pickFromGallery() async {
    // Android 13+ pakai READ_MEDIA_IMAGES, di bawahnya READ_EXTERNAL_STORAGE.
    final permission = await _requestGalleryPermission();
    if (permission != _PermissionState.granted) {
      return ImagePickPermissionDenied(
        isPermanent: permission == _PermissionState.permanentlyDenied,
      );
    }
    return _pick(ImageSource.gallery);
  }

  // ── Private ───────────────────────────────────────────────────────────────

  Future<ImagePickResult> _pick(ImageSource source) async {
    try {
      final xFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1280,
        maxHeight: 1280,
      );
      if (xFile == null) return const ImagePickCancelled();
      return ImagePickSuccess(File(xFile.path));
    } catch (e) {
      return ImagePickError(e.toString());
    }
  }

  Future<_PermissionState> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return _toState(status);
  }

  Future<_PermissionState> _requestGalleryPermission() async {
    // Android 13+ (SDK 33) gunakan photos permission
    final photos = await Permission.photos.request();
    if (photos.isGranted) return _PermissionState.granted;

    // Fallback untuk Android < 13
    final storage = await Permission.storage.request();
    return _toState(storage);
  }

  _PermissionState _toState(PermissionStatus status) {
    if (status.isGranted) return _PermissionState.granted;
    if (status.isPermanentlyDenied) return _PermissionState.permanentlyDenied;
    return _PermissionState.denied;
  }
}

enum _PermissionState { granted, denied, permanentlyDenied }
