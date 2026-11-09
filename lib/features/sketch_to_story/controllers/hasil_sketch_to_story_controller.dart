import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Controller OOP untuk halaman Hasil Sketch to Story.
///
/// Meng-expose state sharing dan aksi tombol ke View via [ChangeNotifier].
/// Tidak menyentuh navigasi langsung — emit event ke screen lewat callback.
class HasilSketchToStoryController extends ChangeNotifier {
  HasilSketchToStoryController({required this.imageFile});

  final File imageFile;

  // ── State ─────────────────────────────────────────────────────────────────

  bool _isSharing = false;

  bool get isSharing => _isSharing;

  // ── Callbacks ke Screen (butuh BuildContext / navigasi) ───────────────────

  VoidCallback? onLihatCerita;
  VoidCallback? onBagikanCerita;
  VoidCallback? onKembaliKeBeranda;

  // ── Actions ───────────────────────────────────────────────────────────────

  void tappedLihatCerita() {
    onLihatCerita?.call();
  }

  Future<void> tappedBagikanCerita() async {
    if (_isSharing) return;
    _isSharing = true;
    notifyListeners();

    // TODO: implementasi share sheet (share_plus) ketika BE sudah ada URL cerita.
    await Clipboard.setData(
      const ClipboardData(text: 'Lihat cerita seru yang dibuat SKETCHOO! 🎨'),
    );

    _isSharing = false;
    notifyListeners();
    onBagikanCerita?.call();
  }

  void tappedKembaliKeBeranda() {
    onKembaliKeBeranda?.call();
  }
}
