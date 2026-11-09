import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../controllers/cerita_controller.dart';
import '../models/cerita_model.dart';

/// Halaman "Cerita dari Gambarmu".
///
/// Menampilkan:
/// - Back header
/// - Hero image (gambar yang diunggah user)
/// - Judul cerita
/// - Paragraf isi cerita
/// - Card Pesan Moral dengan gajah cerita
/// - Tombol "Mulai Sekarang" (TTS)
///
/// Flow: HasilSketchToStory → **CeritaScreen**
class CeritaScreen extends StatefulWidget {
  const CeritaScreen({
    super.key,
    required this.cerita,
  });

  final CeritaModel cerita;

  @override
  State<CeritaScreen> createState() => _CeritaScreenState();
}

class _CeritaScreenState extends State<CeritaScreen> {
  late final CeritaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CeritaController(cerita: widget.cerita)
      ..onStartTts = _startTts
      ..onStopTts = _stopTts;
  }

  // ── TTS handlers (disambung ke flutter_tts) ───────────────────────────────

  void _startTts() {
    // TODO: sambungkan ke flutter_tts ketika sudah diintegrasikan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Memulai pembacaan cerita 🔊'),
        backgroundColor: const Color(0xFF7C4DFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _stopTts() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pembacaan cerita dihentikan'),
        backgroundColor: const Color(0xFF7C4DFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _controller
      ..onStartTts = null
      ..onStopTts = null
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _CeritaHeader(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) => _CeritaBody(
                  controller: _controller,
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
// _CeritaHeader
// ─────────────────────────────────────────────────────────────────────────────

class _CeritaHeader extends StatelessWidget {
  const _CeritaHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 28,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const Expanded(
            child: Text(
              'Cerita dari gambarmu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CeritaBody — scrollable content
// ─────────────────────────────────────────────────────────────────────────────

class _CeritaBody extends StatelessWidget {
  const _CeritaBody({required this.controller});

  final CeritaController controller;

  @override
  Widget build(BuildContext context) {
    final cerita = controller.cerita;
    return Stack(
      children: [
        // Scrollable content
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroImage(imageFile: cerita.imageFile),
              const SizedBox(height: 24),
              _JudulSection(judul: cerita.judul),
              const SizedBox(height: 16),
              _ParagrafSection(paragraf: cerita.paragraf),
              const SizedBox(height: 24),
              _PesanMoralCard(pesanMoral: cerita.pesanMoral),
              const SizedBox(height: 8),
            ],
          ),
        ),
        // Tombol TTS fixed di bawah
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _TtsButton(controller: controller),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HeroImage — gambar hasil upload user dengan rounded corners
// ─────────────────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imageFile});

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _imageWidget(),
      ),
    );
  }

  Widget _imageWidget() {
    // Jika file dummy/kosong (preview mode), tampilkan placeholder
    if (imageFile.path.isEmpty || !imageFile.existsSync()) {
      return Container(
        color: const Color(0xFFF0EEFF),
        child: const Center(
          child: Icon(Icons.image_rounded, size: 64, color: Color(0xFFDDD5FF)),
        ),
      );
    }
    return Image.file(
      imageFile,
      fit: BoxFit.cover,
      errorBuilder: (context, error, _) => Container(
        color: const Color(0xFFF0EEFF),
        child: const Center(
          child: Icon(Icons.broken_image_rounded,
              size: 64, color: Color(0xFFDDD5FF)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _JudulSection — judul cerita bold
// ─────────────────────────────────────────────────────────────────────────────

class _JudulSection extends StatelessWidget {
  const _JudulSection({required this.judul});

  final String judul;

  @override
  Widget build(BuildContext context) {
    return Text(
      judul,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A2E),
        fontFamily: 'Poppins',
        height: 1.3,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ParagrafSection — paragraf isi cerita
// ─────────────────────────────────────────────────────────────────────────────

class _ParagrafSection extends StatelessWidget {
  const _ParagrafSection({required this.paragraf});

  final List<String> paragraf;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraf
          .map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                p,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF3D3D5C),
                  height: 1.65,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PesanMoralCard — card abu-abu muda dengan ikon bintang + gajah cerita
// ─────────────────────────────────────────────────────────────────────────────

class _PesanMoralCard extends StatelessWidget {
  const _PesanMoralCard({required this.pesanMoral});

  final String pesanMoral;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Teks sisi kiri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label "Pesan Moral" dengan ikon bintang
                Row(
                  children: [
                    const Text(
                      '☆',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Pesan Moral',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C4DFF),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  pesanMoral,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7C4DFF),
                    height: 1.5,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Gajah cerita di kanan
          Image.asset(
            AssetPaths.gajahCerita,
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TtsButton — tombol "Mulai Sekarang" fixed di bawah
// ─────────────────────────────────────────────────────────────────────────────

class _TtsButton extends StatelessWidget {
  const _TtsButton({required this.controller});

  final CeritaController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fade gradient di belakang tombol agar tidak terpotong abrupt
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.95),
            Colors.white,
          ],
          stops: const [0.0, 0.35, 1.0],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: controller.isPlaying
                ? const LinearGradient(
                    colors: [Color(0xFF9C6FFF), Color(0xFF7C4DFF)],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF7C4DFF), Color(0xFF9C70FF)],
                  ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C4DFF).withValues(alpha: 0.38),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller.tappedMulaiSekarang,
              borderRadius: BorderRadius.circular(28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    controller.isPlaying
                        ? Icons.stop_rounded
                        : Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    controller.isPlaying ? 'Hentikan' : 'Mulai Sekarang',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
