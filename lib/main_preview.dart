/// Entry point khusus preview UI — JANGAN dipakai di production.
/// Jalankan dengan: flutter run -t lib/main_preview.dart
library;

import 'dart:io';

import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/sketch_to_story/models/cerita_model.dart';
import 'features/sketch_to_story/screens/cerita_screen.dart';
import 'features/sketch_to_story/screens/hasil_sketch_to_story_screen.dart';
import 'features/sketch_to_story/screens/memproses_gambar_screen.dart';

void main() {
  runApp(const _PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preview — Sketch to Story',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const _PreviewFlow(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PreviewFlow — orchestrates full 3-screen loop: Loader → Hasil → Cerita
// ─────────────────────────────────────────────────────────────────────────────

enum _PreviewStep { loader, hasil, cerita }

class _PreviewFlow extends StatefulWidget {
  const _PreviewFlow();

  @override
  State<_PreviewFlow> createState() => _PreviewFlowState();
}

class _PreviewFlowState extends State<_PreviewFlow> {
  _PreviewStep _step = _PreviewStep.loader;
  int _key = 0;

  // Dummy file — Image.file tidak dipakai di halaman loader & hasil
  final File _dummyFile = File('');

  void _goToHasil() => setState(() => _step = _PreviewStep.hasil);

  void _goToCerita() => setState(() => _step = _PreviewStep.cerita);

  void _restart() => setState(() {
        _step = _PreviewStep.loader;
        _key++;
      });

  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      _PreviewStep.loader => MemprosesGambarScreen(
          key: ValueKey('loader_$_key'),
          imageFile: _dummyFile,
          onComplete: _goToHasil,
        ),
      _PreviewStep.hasil => HasilSketchToStoryScreen(
          key: ValueKey('hasil_$_key'),
          imageFile: _dummyFile,
          onLihatCerita: _goToCerita,
          onKembaliKeBeranda: _restart,
        ),
      _PreviewStep.cerita => CeritaScreen(
          key: ValueKey('cerita_$_key'),
          cerita: CeritaModel.mock(imageFile: _dummyFile),
        ),
    };
  }
}
