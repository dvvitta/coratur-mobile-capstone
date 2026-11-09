import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// State fase proses gambar.
enum MemprosesState {
  processing, // sedang berjalan
  done,       // selesai
}

/// Controller OOP untuk halaman Memproses Gambar.
///
/// Mengelola animasi progres dan simulasi proses (placeholder BE).
/// Tidak menyentuh UI sama sekali — hanya meng-expose state via [ChangeNotifier].
class MemprosesGambarController extends ChangeNotifier {
  MemprosesGambarController({
    required this.imageFile,
    /// Durasi total simulasi progres (nanti diganti durasi real dari BE).
    this._simulationDuration = const Duration(milliseconds: 4200),
  });

  final File imageFile;
  final Duration _simulationDuration;

  // ── State ─────────────────────────────────────────────────────────────────

  MemprosesState _state = MemprosesState.processing;
  double _progress = 0.0; // 0.0 – 1.0
  Timer? _ticker;
  Timer? _completeTimer;

  MemprosesState get state => _state;
  double get progress => _progress;
  bool get isDone => _state == MemprosesState.done;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  /// Mulai simulasi progres. Panggil sekali dari [State.initState].
  void start() {
    _startProgressTicker();
    _scheduleCompletion();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _completeTimer?.cancel();
    super.dispose();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _startProgressTicker() {
    const tickInterval = Duration(milliseconds: 50);
    final totalTicks =
        _simulationDuration.inMilliseconds / tickInterval.inMilliseconds;
    _ticker = Timer.periodic(tickInterval, (t) {
      if (!hasListeners) {
        t.cancel();
        return;
      }
      _progress = (_progress + 1 / totalTicks).clamp(0.0, 1.0);
      notifyListeners();
    });
  }

  void _scheduleCompletion() {
    _completeTimer = Timer(
      Duration(milliseconds: _simulationDuration.inMilliseconds + 400),
      () {
        _ticker?.cancel();
        _progress = 1.0;
        _state = MemprosesState.done;
        notifyListeners();
      },
    );
  }
}
