import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../controllers/sketch_to_story_controller.dart';
import '../widgets/sketch_to_story_header.dart';
import '../widgets/sketch_to_story_hero.dart';
import '../widgets/sketch_to_story_option_card.dart';
import '../widgets/sketch_to_story_start_button.dart';

/// Halaman Sketch to Story.
///
/// Hanya bertanggung jawab sebagai View — semua logika ada di
/// [SketchToStoryController]. Screen membuat controller-nya sendiri
/// (owned lifecycle) dan me-listen perubahan via [ListenableBuilder].
class SketchToStoryScreen extends StatefulWidget {
  const SketchToStoryScreen({super.key});

  @override
  State<SketchToStoryScreen> createState() => _SketchToStoryScreenState();
}

class _SketchToStoryScreenState extends State<SketchToStoryScreen> {
  late final SketchToStoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SketchToStoryController();
    _controller.addListener(_handleNavEvent);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleNavEvent);
    _controller.dispose();
    super.dispose();
  }

  // ── Nav handler ────────────────────────────────────────────────────────────

  void _handleNavEvent() {
    final event = _controller.navEvent;
    if (event == SketchToStoryNavEvent.none) return;

    _controller.consumeNavEvent();

    switch (event) {
      case SketchToStoryNavEvent.goToCanvas:
        Navigator.of(context).pushNamed(AppRoutes.sketchChallengeLevels);
      case SketchToStoryNavEvent.goToUpload:
        Navigator.of(context).pushNamed(AppRoutes.uploadGambar);
      case SketchToStoryNavEvent.start:
        break;
      case SketchToStoryNavEvent.none:
        break;
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header (tidak perlu rebuild saat state berubah)
            SketchToStoryHeader(
              onBack: () => Navigator.of(context).pop(),
            ),

            // Body — hanya bagian ini yang rebuild saat controller notify
            Expanded(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) => _Body(controller: _controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Body — scrollable content area
// ─────────────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({required this.controller});

  final SketchToStoryController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),

          // Ilustrasi hero
          const SketchToStoryHero(),
          const SizedBox(height: 20),

          // Heading
          const _Heading(),
          const SizedBox(height: 24),

          // Dua kartu opsi (side-by-side)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < controller.options.length; i++) ...[
                if (i > 0) const SizedBox(width: 14),
                Expanded(
                  child: SketchToStoryOptionCard(
                    option: controller.options[i],
                    isSelected: controller.isSelected(controller.options[i].id),
                    onTap: () =>
                        controller.selectOption(controller.options[i].id),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 32),

          // Tombol Mulai Sekarang
          SketchToStoryStartButton(onTap: controller.onStartPressed),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Heading
// ─────────────────────────────────────────────────────────────────────────────

class _Heading extends StatelessWidget {
  const _Heading();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Ubah Gambar jadi\nCerita Seru!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1A1A2E),
        height: 1.25,
      ),
    );
  }
}
