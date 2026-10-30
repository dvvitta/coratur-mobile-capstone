import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/asset_paths.dart';
import '../models/sketch_challenge_models.dart';

class SketchChallengeResultScreen extends StatelessWidget {
  const SketchChallengeResultScreen({
    super.key,
    required this.prompt,
    required this.lines,
    required this.score,
    this.onNext,
    this.onRetry,
  });

  final SketchChallengePrompt prompt;
  final List<DrawnLine> lines;
  final int score;
  final VoidCallback? onNext;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF43309A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF43309A),
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHebat(),
                      const SizedBox(height: 4),
                      _buildSubtitle(),
                      const SizedBox(height: 8),
                      _buildStars(),
                      _buildDrawingCard(),
                      const SizedBox(height: 18),
                      _buildScoreBadge(),
                      const SizedBox(height: 24),
                      _buildNextButton(context),
                      const SizedBox(height: 12),
                      _buildRetryButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHebat() {
    return const Text(
      'Hebat!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: Color(0xFF5B2EE0),
        letterSpacing: -1.5,
        height: 1.0,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      '${prompt.title}mu sudah jadi!',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E1B4B),
      ),
    );
  }

  // 3 bintang simetris: kiri & kanan sama besar, tengah lebih besar & lebih tinggi
  // posisi dari mockup pixel analysis (card width ~345px)
  Widget _buildStars() {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // kiri (medium)
          Positioned(
            left: 20,
            bottom: 0,
            child: Image.asset(AssetPaths.star, width: 90, height: 90),
          ),
          // tengah (paling besar, lebih tinggi)
          Positioned(
            top: -20,
            child: Image.asset(AssetPaths.star, width: 120, height: 120),
          ),
          // kanan (medium, sama level kiri)
          Positioned(
            right: 20,
            bottom: 0,
            child: Image.asset(AssetPaths.star, width: 90, height: 90),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawingCard() {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        color: const Color(0xFFF4EEFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: lines.isNotEmpty
            ? CustomPaint(painter: _ResultPainter(lines: lines))
            : const SizedBox(),
      ),
    );
  }

  Widget _buildScoreBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE8A5), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AssetPaths.star, width: 34, height: 34),
          const SizedBox(width: 8),
          Text(
            '+$score Skor',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B4B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        key: const Key('result_next_button'),
        onPressed: onNext ?? () => Navigator.of(context).pop(),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF7546F8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Gambar Berikutnya →',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        key: const Key('result_retry_button'),
        onPressed: onRetry ?? () => Navigator.of(context).pop(),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF6B33EB), width: 1.5),
          backgroundColor: const Color(0xFFF9F9FC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Ulangi Gambar Ini',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6B33EB),
          ),
        ),
      ),
    );
  }
}

class _ResultPainter extends CustomPainter {
  const _ResultPainter({required this.lines});

  final List<DrawnLine> lines;

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      if (line.points.isEmpty) continue;
      final paint = Paint()
        ..color = line.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = line.strokeWidth
        ..style = PaintingStyle.stroke;

      if (line.points.length == 1) {
        canvas.drawCircle(
          line.points.first,
          line.strokeWidth / 2,
          paint..style = PaintingStyle.fill,
        );
        continue;
      }

      final path = Path()..moveTo(line.points.first.dx, line.points.first.dy);
      for (int i = 1; i < line.points.length; i++) {
        path.lineTo(line.points[i].dx, line.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ResultPainter old) => old.lines != lines;
}
