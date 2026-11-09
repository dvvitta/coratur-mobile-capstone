import 'dart:io';

import 'package:flutter/material.dart';

import '../models/upload_option.dart';
import '../services/image_picker_service.dart';

export '../services/image_picker_service.dart'
    show
        ImagePickResult,
        ImagePickSuccess,
        ImagePickPermissionDenied,
        ImagePickCancelled,
        ImagePickError;

/// State halaman Unggah Gambar.
enum UploadState {
  idle,       // belum ada aksi
  picking,    // sedang membuka picker / menunggu izin
  preview,    // gambar sudah dipilih, tampilkan preview
}

/// Controller OOP untuk halaman Unggah Gambar.
///
/// Mengorkestrasi [ImagePickerService] dan meng-expose state
/// ke View via [ChangeNotifier].
class UploadGambarController extends ChangeNotifier {
  UploadGambarController({ImagePickerService? pickerService})
      : _pickerService = pickerService ?? ImagePickerService(),
        _options = _buildOptions();

  final ImagePickerService _pickerService;
  final List<UploadOption> _options;

  // ── State ─────────────────────────────────────────────────────────────────

  UploadState _state = UploadState.idle;
  File? _selectedImage;

  // Callback ke screen untuk aksi yang butuh context (dialog, snackbar, nav).
  void Function(ImagePickResult result)? onPickResult;

  // ── Getters ───────────────────────────────────────────────────────────────

  List<UploadOption> get options => List.unmodifiable(_options);
  UploadState get state => _state;
  File? get selectedImage => _selectedImage;
  bool get isPicking => _state == UploadState.picking;
  bool get hasImage => _selectedImage != null;

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> onOptionTapped(String id) async {
    if (_state == UploadState.picking) return; // cegah double tap
    _setState(UploadState.picking);

    final result = id == 'camera'
        ? await _pickerService.pickFromCamera()
        : await _pickerService.pickFromGallery();

    if (result is ImagePickSuccess) {
      _selectedImage = result.file;
      _setState(UploadState.preview);
    } else {
      _setState(UploadState.idle);
    }

    onPickResult?.call(result);
  }

  /// User menekan "Pilih Ulang" dari preview.
  void resetImage() {
    _selectedImage = null;
    _setState(UploadState.idle);
  }

  /// Placeholder: nanti disambungkan ke endpoint BE.
  /// Saat ini hanya emit notif ke screen.
  void onConfirmImage() {
    assert(_selectedImage != null, 'onConfirmImage dipanggil tanpa gambar');
    // TODO: kirim _selectedImage ke repository ketika BE sudah siap
    notifyListeners();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _setState(UploadState state) {
    _state = state;
    notifyListeners();
  }

  static List<UploadOption> _buildOptions() => const [
        UploadOption(
          id: 'camera',
          icon: Icons.camera_alt_rounded,
          title: 'Ambil foto',
          description: 'Gunakan kamera untuk memotret gambarmu',
        ),
        UploadOption(
          id: 'gallery',
          icon: Icons.photo_library_rounded,
          title: 'Pilih dari galeri',
          description: 'Pilih gambar yang sudah tersimpan di perangkat',
        ),
      ];
}
