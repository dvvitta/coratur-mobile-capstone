import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Widget bintang 4-sudut yang berkedip (opacity + scale + rotasi ringan).
///
/// Parameter [diamond] mengubah orientasi bintang menjadi diamond (rotasi 45°).
/// Digunakan sebagai dekorasi di halaman Memproses Gambar & Hasil Sketch to Story.
class SparklingStar extends StatelessWidget {
  const SparklingStar({
    super.key,
    required this.controller,
    required this.size,
    required this.color,
    this.diamond = false,
  });

  final AnimationController controller;
  final double size;
  final Color color;

  /// Jika true, bintang dirotasi 45° sehingga terlihat seperti ✦ diamond.
  final bool diamond;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        final baseAngle = diamond ? math.pi / 4 : 0.0;
        return Opacity(
          opacity: 0.4 + 0.6 * t,
          child: Transform.rotate(
            angle: baseAngle + math.pi * 0.15 * math.sin(t * math.pi),
            child: Transform.scale(
              scale: 0.75 + 0.35 * t,
              child: _StarShape(size: size, color: color),
            ),
          ),
        );
      },
    );
  }
}

// ── Internal ──────────────────────────────────────────────────────────────────

class _StarShape extends StatelessWidget {
  const _StarShape({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FourPointStarPainter(color: color),
    );
  }
}

class _FourPointStarPainter extends CustomPainter {
  const _FourPointStarPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final outer = size.width / 2;
    final inner = outer * 0.42;
    const points = 4;

    final path = Path();
    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? outer : inner;
      final angle = (math.pi / points) * i - math.pi / 2;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FourPointStarPainter old) => old.color != color;
}
