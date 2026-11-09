import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_routes.dart';
import '../controllers/upload_gambar_controller.dart';
import '../widgets/image_preview_sheet.dart';
import '../widgets/sketch_to_story_header.dart';
import '../widgets/upload_hero_illustration.dart';
import '../widgets/upload_option_card.dart';
import '../widgets/upload_tips_card.dart';

/// Halaman "Unggah Gambar" — user memilih kamera atau galeri.
///
/// Pure View: semua logic ada di [UploadGambarController].
/// Feedback (dialog, snackbar) ditangani screen karena butuh [BuildContext].
class UploadGambarScreen extends StatefulWidget {
  const UploadGambarScreen({super.key});

  @override
  State<UploadGambarScreen> createState() => _UploadGambarScreenState();
}

class _UploadGambarScreenState extends State<UploadGambarScreen> {
  late final UploadGambarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UploadGambarController();
    // Daftarkan callback hasil pick — butuh context, jadi di screen
    _controller.onPickResult = _handlePickResult;
    _controller.addListener(_handleStateChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleStateChange);
    _controller.onPickResult = null;
    _controller.dispose();
    super.dispose();
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  /// Dipanggil controller setiap kali state berubah.
  void _handleStateChange() {
    if (!mounted) return;
    // Tampilkan preview sheet ketika gambar berhasil dipilih
    if (_controller.state == UploadState.preview &&
        _controller.selectedImage != null) {
      _showPreviewSheet();
    }
  }

  /// Tangani hasil dari image picker service.
  void _handlePickResult(ImagePickResult result) {
    if (!mounted) return;
    switch (result) {
      case ImagePickPermissionDenied(:final isPermanent):
        isPermanent ? _showOpenSettingsDialog() : _showPermissionDeniedSnackbar();
      case ImagePickError(:final message):
        _showErrorSnackbar(message);
      case ImagePickSuccess() || ImagePickCancelled():
        break; // ditangani via _handleStateChange
    }
  }

  // ── UI feedback ───────────────────────────────────────────────────────────

  void _showPreviewSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ImagePreviewSheet(
        imageFile: _controller.selectedImage!,
        onConfirm: () {
          Navigator.of(context).pop();
          _controller.onConfirmImage();
          _navigateToLoader();
        },
        onRetry: () {
          Navigator.of(context).pop();
          _controller.resetImage();
        },
      ),
    ).then((_) {
      // Sheet ditutup dengan swipe → reset state
      if (_controller.state == UploadState.preview) {
        _controller.resetImage();
      }
    });
  }

  void _showPermissionDeniedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Izin ditolak. Coba lagi untuk memberikan izin.'),
        backgroundColor: const Color(0xFF7C4DFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showOpenSettingsDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Izin Diperlukan',
          style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E)),
        ),
        content: const Text(
          'Kamu sudah menolak izin sebelumnya. '
          'Buka Pengaturan untuk mengaktifkan izin kamera atau penyimpanan.',
          style: TextStyle(color: Color(0xFF7A7A9A), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF7A7A9A)),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              openAppSettings();
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF7C4DFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terjadi kesalahan: $message'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _navigateToLoader() {
    if (!mounted) return;
    Navigator.of(context).pushNamed(
      AppRoutes.memprosesGambar,
      arguments: _controller.selectedImage,
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SketchToStoryHeader(
              title: 'Unggah Gambar',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, child) => _Body(controller: _controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Body
// ─────────────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({required this.controller});
  final UploadGambarController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ilustrasi hero
          const UploadHeroIllustration(),
          const SizedBox(height: 32),

          // Opsi kamera / galeri
          ...controller.options.map(
            (opt) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: UploadOptionCard(
                option: opt,
                // Disable tap saat sedang picking (cegah double open)
                onTap: controller.isPicking
                    ? null
                    : () => controller.onOptionTapped(opt.id),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Tips
          const UploadTipsCard(),
        ],
      ),
    );
  }
}
