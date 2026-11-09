import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../controllers/memproses_gambar_controller.dart';
import '../widgets/sparkling_star.dart';
import '../widgets/sketch_to_story_header.dart';

/// Loader screen "Memproses Gambar".
///
/// Ditampilkan setelah user konfirmasi gambar di [UploadGambarScreen].
/// Semua logika progres ada di [MemprosesGambarController].
///
/// Flow: UploadGambar → **MemprosesGambar** → Hasil Cerita (TODO)
class MemprosesGambarScreen extends StatefulWidget {
  const MemprosesGambarScreen({
    super.key,
    required this.imageFile,
    this.onComplete,
  });

  final File imageFile;

  /// Callback dipanggil ketika proses selesai.
  /// Nanti disambungkan ke navigasi halaman hasil cerita.
  final VoidCallback? onComplete;

  @override
  State<MemprosesGambarScreen> createState() => _MemprosesGambarScreenState();
}

class _MemprosesGambarScreenState extends State<MemprosesGambarScreen>
    with TickerProviderStateMixin {
  // ── Controllers ───────────────────────────────────────────────────────────

  late final MemprosesGambarController _controller;
  late final List<AnimationController> _starControllers;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _controller = MemprosesGambarController(imageFile: widget.imageFile)
      ..addListener(_onControllerChange)
      ..start();

    _starControllers = _buildStarControllers();
  }

  List<AnimationController> _buildStarControllers() {
    const durations = [
      Duration(milliseconds: 1600),
      Duration(milliseconds: 2100),
      Duration(milliseconds: 1300),
      Duration(milliseconds: 1900),
      Duration(milliseconds: 2400),
    ];
    return durations
        .map((d) => AnimationController(vsync: this, duration: d)
          ..repeat(reverse: true))
        .toList();
  }

  void _onControllerChange() {
    if (!mounted) return;
    if (_controller.isDone) {
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChange)
      ..dispose();
    for (final ctrl in _starControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: Column(
          children: [
            SketchToStoryHeader(
              title: 'Memproses Gambar',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) => _Body(
                  progress: _controller.progress,
                  starControllers: _starControllers,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Body — layout utama (stateless, dirender ulang saat progress berubah)
// ─────────────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({
    required this.progress,
    required this.starControllers,
  });

  final double progress;
  final List<AnimationController> starControllers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          _GajahSection(starControllers: starControllers),
          const Spacer(flex: 3),
          const _InfoSection(),
          const Spacer(flex: 2),
          _ProgressSection(progress: progress),
          const Spacer(flex: 3),
          const _TipsCard(),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GajahSection — GIF + bintang dekoratif
// ─────────────────────────────────────────────────────────────────────────────

class _GajahSection extends StatelessWidget {
  const _GajahSection({required this.starControllers});

  final List<AnimationController> starControllers;

  static const _starConfigs = [
    _StarConfig(top: 10,  left: 30,  size: 24, color: Color(0xFFFFD700)),
    _StarConfig(top: 55,  right: 20, size: 18, color: Color(0xFFFFC107)),
    _StarConfig(top: 30,  right: 55, size: 14, color: Color(0xFFFFD700)),
    _StarConfig(bottom: 40, left: 18, size: 20, color: Color(0xFFFFC107)),
    _StarConfig(bottom: 20, right: 40, size: 16, color: Color(0xFFFFD700)),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          _buildBackgroundCircle(),
          _buildElephantGif(),
          ..._buildStars(),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircle() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFDDD5FF).withValues(alpha: 0.7),
            const Color(0xFFF5F3FF).withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  Widget _buildElephantGif() {
    return Image.asset(
      AssetPaths.gajahKacaPembesar,
      width: 210,
      height: 210,
      fit: BoxFit.contain,
    );
  }

  List<Widget> _buildStars() {
    return List.generate(_starConfigs.length, (i) {
      final cfg = _starConfigs[i];
      return Positioned(
        top: cfg.top,
        bottom: cfg.bottom,
        left: cfg.left,
        right: cfg.right,
        child: SparklingStar(
          controller: starControllers[i],
          size: cfg.size,
          color: cfg.color,
        ),
      );
    });
  }
}

/// Data konfigurasi posisi & tampilan satu bintang dekoratif.
class _StarConfig {
  const _StarConfig({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.color,
  });

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Color color;
}

// ─────────────────────────────────────────────────────────────────────────────
// _InfoSection — teks judul + deskripsi
// ─────────────────────────────────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  const _InfoSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Tunggu sebentar...',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 10),
        Text(
          'SKETCHOO sedang menganalisis gambar\ndan menyiapkan cerita terbaik untukmu.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF7A7A9A),
            height: 1.55,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProgressSection — progress bar + persentase
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    return Column(
      children: [
        _ProgressBar(progress: progress),
        const SizedBox(height: 10),
        Text(
          '$percent%',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A7A9A),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Track
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFFDDD5FF),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        // Fill
        FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFFB39DFF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C4DFF).withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TipsCard — kartu info di bagian bawah
// ─────────────────────────────────────────────────────────────────────────────

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C4DFF).withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        children: [
          Text('⭐', style: TextStyle(fontSize: 22)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Proses ini biasanya hanya\nmemerlukan beberapa detik.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7A7A9A),
                height: 1.45,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
