import 'package:flutter/foundation.dart';

import '../../../core/constants/asset_paths.dart';
import '../models/sketch_to_story_option.dart';

/// Status navigasi yang di-emit controller ke screen.
enum SketchToStoryNavEvent {
  none,
  goToCanvas,     // pilih "Gambar di Canvas"
  goToUpload,     // pilih "Upload Gambar" (belum tersedia)
  start,          // tombol "Mulai Sekarang"
}

/// Controller OOP untuk halaman Sketch to Story.
///
/// Memegang daftar opsi aksi & state pilihan aktif, lalu mem-broadcast
/// perubahan ke widget listener via [ChangeNotifier].
class SketchToStoryController extends ChangeNotifier {
  SketchToStoryController() {
    _options = _buildOptions();
  }

  // ── State ─────────────────────────────────────────────────────────────────

  late final List<SketchToStoryOption> _options;
  String? _selectedId;
  SketchToStoryNavEvent _navEvent = SketchToStoryNavEvent.none;

  // ── Getters ───────────────────────────────────────────────────────────────

  List<SketchToStoryOption> get options => List.unmodifiable(_options);
  String? get selectedId => _selectedId;
  SketchToStoryNavEvent get navEvent => _navEvent;

  bool isSelected(String id) => _selectedId == id;

  // ── Actions ───────────────────────────────────────────────────────────────

  /// Pilih salah satu opsi kartu. Jika sudah terpilih, deselect.
  void selectOption(String id) {
    if (_selectedId == id) {
      _selectedId = null;
    } else {
      _selectedId = id;
    }
    notifyListeners();
  }

  /// Tombol "Mulai Sekarang" ditekan.
  /// Navigasi berdasarkan opsi yang dipilih; jika belum pilih, default canvas.
  void onStartPressed() {
    final resolvedId = _selectedId ?? _options.first.id;
    _emitNav(resolvedId == 'canvas'
        ? SketchToStoryNavEvent.goToCanvas
        : SketchToStoryNavEvent.goToUpload);
  }

  /// Kartu ditekan langsung (tanpa "Mulai Sekarang").
  void onOptionTapped(String id) {
    _selectedId = id;
    notifyListeners();
    _emitNav(id == 'canvas'
        ? SketchToStoryNavEvent.goToCanvas
        : SketchToStoryNavEvent.goToUpload);
  }

  /// Reset navEvent setelah screen selesai menangani navigasi.
  void consumeNavEvent() {
    _navEvent = SketchToStoryNavEvent.none;
    // Tidak perlu notifyListeners — hanya konsumsi internal.
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _emitNav(SketchToStoryNavEvent event) {
    _navEvent = event;
    notifyListeners();
  }

  List<SketchToStoryOption> _buildOptions() => const [
        SketchToStoryOption(
          id: 'canvas',
          imagePath: AssetPaths.drawingTablet,
          title: 'Gambar di\nCanvas',
          description: 'Gambar langsung disini',
        ),
        SketchToStoryOption(
          id: 'upload',
          imagePath: AssetPaths.imageUpload,
          title: 'Upload\nGambar',
          description: 'Pilih dari galerimu',
        ),
      ];
}
