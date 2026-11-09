import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';
import '../controllers/hasil_sketch_to_story_controller.dart';
import '../models/cerita_model.dart';
import '../widgets/sparkling_star.dart';

/// Halaman "Hasil Sketch to Story" — ditampilkan setelah loader selesai.
///
/// Menampilkan:
/// - GIF gajah pegang bintang emas
/// - Teks "Yeay! Cerita berhasil dibuat!"
/// - 3 tombol aksi: Lihat Cerita, Bagikan Cerita, Kembali ke Beranda
///
/// Flow: MemprosesGambar → **HasilSketchToStory** → Cerita / Beranda
class HasilSketchToStoryScreen extends StatefulWidget {
  const HasilSketchToStoryScreen({
    super.key,
    required this.imageFile,
    this.onLihatCerita,
    this.onKembaliKeBeranda,
  });

  final File imageFile;

  /// Override navigasi "Lihat Cerita".
  /// Jika null, default navigate ke [AppRoutes.ceritaSketchToStory].
  final VoidCallback? onLihatCerita;

  /// Override navigasi "Kembali ke Beranda".
  /// Jika null, default navigate ke [AppRoutes.home].
  final VoidCallback? onKembaliKeBeranda;

  @override
  State<HasilSketchToStoryScreen> createState() =>
      _HasilSketchToStoryScreenState();
}

class _HasilSketchToStoryScreenState extends State<HasilSketchToStoryScreen>
    with TickerProviderStateMixin {
  // ── Controllers ───────────────────────────────────────────────────────────

  late final HasilSketchToStoryController _controller;
  late final AnimationController _entryCtrl;
  late final List<AnimationController> _starCtrls;

  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _setupController();
    _setupAnimations();
  }

  void _setupController() {
    _controller = HasilSketchToStoryController(imageFile: widget.imageFile)
      ..onLihatCerita = _handleLihatCerita
      ..onBagikanCerita = _handleBagikanCerita
      ..onKembaliKeBeranda = _handleKembaliKeBeranda;
  }

  void _setupAnimations() {
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
    );

    const starDurations = [
      Duration(milliseconds: 1500),
      Duration(milliseconds: 2000),
      Duration(milliseconds: 1300),
      Duration(milliseconds: 1800),
      Duration(milliseconds: 2300),
      Duration(milliseconds: 1600),
    ];
    _starCtrls = starDurations
        .map((d) => AnimationController(vsync: this, duration: d)
          ..repeat(reverse: true))
        .toList();

    _entryCtrl.forward();
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  void _handleLihatCerita() {
    if (!mounted) return;
    if (widget.onLihatCerita != null) {
      widget.onLihatCerita!();
      return;
    }
    Navigator.of(context).pushNamed(
      AppRoutes.ceritaSketchToStory,
      arguments: CeritaModel.mock(imageFile: widget.imageFile),
    );
  }

  void _handleBagikanCerita() {
    if (!mounted) return;
    _showSnackbar('Link cerita disalin ke clipboard! 🔗');
  }

  void _handleKembaliKeBeranda() {
    if (!mounted) return;
    if (widget.onKembaliKeBeranda != null) {
      widget.onKembaliKeBeranda!();
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF7C4DFF),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Dispose ───────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _controller
      ..onLihatCerita = null
      ..onBagikanCerita = null
      ..onKembaliKeBeranda = null
      ..dispose();
    _entryCtrl.dispose();
    for (final ctrl in _starCtrls) {
      ctrl.dispose();
    }
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => _Body(
                controller: _controller,
                starCtrls: _starCtrls,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Body
// ─────────────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({
    required this.controller,
    required this.starCtrls,
  });

  final HasilSketchToStoryController controller;
  final List<AnimationController> starCtrls;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          const Spacer(flex: 3),
          _GajahSection(starCtrls: starCtrls),
          const SizedBox(height: 32),
          const _HeadlineSection(),
          const Spacer(flex: 2),
          _ActionButtons(controller: controller),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GajahSection — GIF + bintang dekoratif
// ─────────────────────────────────────────────────────────────────────────────

class _GajahSection extends StatelessWidget {
  const _GajahSection({required this.starCtrls});

  final List<AnimationController> starCtrls;

  // Konfigurasi posisi & tampilan setiap bintang dekoratif
  static const _starConfigs = [
    _StarConfig(top: 8,    left: 20,  size: 26, color: Color(0xFFFFD700)),
    _StarConfig(top: 40,   left: 5,   size: 18, color: Color(0xFFFFD700)),
    _StarConfig(top: 15,   right: 18, size: 22, color: Color(0xFFFFD700)),
    _StarConfig(top: 50,   right: 5,  size: 14, color: Color(0xFF7C4DFF), diamond: true),
    _StarConfig(bottom: 30, left: 25, size: 12, color: Color(0xFF7C4DFF), diamond: true),
    _StarConfig(bottom: 10, right: 30, size: 16, color: Color(0xFFFFD700)),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            AssetPaths.gajahHasilSketch,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          ..._buildStars(),
        ],
      ),
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
          controller: starCtrls[i],
          size: cfg.size,
          color: cfg.color,
          diamond: cfg.diamond,
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
    this.diamond = false,
  });

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Color color;
  final bool diamond;
}

// ─────────────────────────────────────────────────────────────────────────────
// _HeadlineSection — teks "Yeay!" + subjudul
// ─────────────────────────────────────────────────────────────────────────────

class _HeadlineSection extends StatelessWidget {
  const _HeadlineSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Yeay!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Cerita berhasil dibuat!',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ActionButtons — 3 tombol lingkaran
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.controller});

  final HasilSketchToStoryController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircleActionButton(
          icon: Icons.search_rounded,
          label: 'Lihat\nCerita',
          filled: false,
          onTap: controller.tappedLihatCerita,
        ),
        _CircleActionButton(
          icon: Icons.share_rounded,
          label: 'Bagikan\nCerita',
          filled: false,
          onTap: controller.tappedBagikanCerita,
          loading: controller.isSharing,
        ),
        _CircleActionButton(
          icon: Icons.home_rounded,
          label: 'Kembali\nke Beranda',
          filled: true,
          onTap: controller.tappedKembaliKeBeranda,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CircleActionButton — satu tombol lingkaran + label
// ─────────────────────────────────────────────────────────────────────────────

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
    this.loading = false,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;
  final bool loading;

  static const _purple = Color(0xFF7C4DFF);
  static const _buttonSize = 64.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: loading ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: _buttonSize,
            height: _buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? _purple : Colors.white,
              border: filled
                  ? null
                  : Border.all(
                      color: _purple.withValues(alpha: 0.6),
                      width: 1.8,
                    ),
              boxShadow: [
                BoxShadow(
                  color: _purple.withValues(alpha: filled ? 0.28 : 0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: loading
                ? Padding(
                    padding: const EdgeInsets.all(18),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: filled ? Colors.white : _purple,
                    ),
                  )
                : Icon(
                    icon,
                    size: 26,
                    color: filled ? Colors.white : _purple,
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
            height: 1.35,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
