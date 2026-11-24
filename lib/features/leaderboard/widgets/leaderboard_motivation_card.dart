import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

/// Card motivasi di bagian bawah halaman Leaderboard.
///
/// Berisi maskot bintang ceria di kiri, teks motivasi ungu di tengah,
/// dan kilauan bintang di kanan, persis sesuai desain referensi.
class LeaderboardMotivationCard extends StatelessWidget {
  const LeaderboardMotivationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7FF).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8DCFA), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A522CA6),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Maskot Bintang 3D
          Image.asset(AssetPaths.star, width: 36, height: 36),
          const SizedBox(width: 12),
          // Teks Motivasi
          const Expanded(
            child: Text(
              'Terus belajar dan kumpulkan bintang\nuntuk naik peringkat ya!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4C279E),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Kilau dekoratif kuning di kanan
          const _SparkleRays(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SparkleRays — dekorasi kilau kecil di sisi kanan
// ─────────────────────────────────────────────────────────────────────────────

class _SparkleRays extends StatelessWidget {
  const _SparkleRays();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 24,
      child: CustomPaint(painter: _RaysPainter()),
    );
  }
}

class _RaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Garis atas miring
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.9, size.height * 0.05),
      paint,
    );
    // Garis tengah
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.5),
      Offset(size.width * 0.95, size.height * 0.5),
      paint,
    );
    // Garis bawah miring
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.95),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
