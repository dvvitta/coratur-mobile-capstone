import 'package:flutter/foundation.dart';

import '../models/cerita_model.dart';

/// State pemutaran TTS.
enum TtsState { stopped, playing, paused }

/// Controller OOP untuk halaman Cerita Sketch to Story.
///
/// Mengelola state TTS (Text-to-Speech) dan data cerita.
/// Tidak menyentuh UI — emit perubahan via [ChangeNotifier].
class CeritaController extends ChangeNotifier {
  CeritaController({required this.cerita});

  final CeritaModel cerita;

  // ── State ─────────────────────────────────────────────────────────────────

  TtsState _ttsState = TtsState.stopped;

  TtsState get ttsState => _ttsState;
  bool get isPlaying => _ttsState == TtsState.playing;

  // Callback ke screen — butuh plugin TTS aktual (flutter_tts)
  VoidCallback? onStartTts;
  VoidCallback? onStopTts;

  // ── Actions ───────────────────────────────────────────────────────────────

  /// Tombol "Mulai Sekarang" ditekan.
  void tappedMulaiSekarang() {
    if (_ttsState == TtsState.playing) {
      _ttsState = TtsState.stopped;
      notifyListeners();
      onStopTts?.call();
    } else {
      _ttsState = TtsState.playing;
      notifyListeners();
      onStartTts?.call();
    }
  }

  /// Dipanggil dari screen ketika TTS selesai diputar.
  void onTtsCompleted() {
    _ttsState = TtsState.stopped;
    notifyListeners();
  }

  // ── Teks yang dibacakan TTS ───────────────────────────────────────────────

  /// Gabungan seluruh teks cerita untuk diumpan ke TTS engine.
  String get fullTtsText {
    final buffer = StringBuffer()
      ..writeln(cerita.judul)
      ..writeln();
    for (final p in cerita.paragraf) {
      buffer
        ..writeln(p)
        ..writeln();
    }
    buffer.write('Pesan moral: ${cerita.pesanMoral}');
    return buffer.toString();
  }
}
