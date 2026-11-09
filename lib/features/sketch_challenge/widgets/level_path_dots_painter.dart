import 'package:flutter/material.dart';

class LevelPathDotsPainter extends CustomPainter {
  const LevelPathDotsPainter({required this.nodeCenters});

  final List<Offset> nodeCenters;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCenters.length < 2) return;
    final dotPaint = Paint()
      ..color = const Color(0xFFBCA7FB)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < nodeCenters.length - 1; i++) {
      final p1 = nodeCenters[i];
      final p2 = nodeCenters[i + 1];
      final path = Path();
      path.moveTo(p1.dx, p1.dy);
      final midY = (p1.dy + p2.dy) / 2;
      final controlPoint = Offset(
        (p1.dx + p2.dx) / 2 + ((i.isEven ? 1 : -1) * 20),
        midY,
      );
      path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p2.dx, p2.dy);

      for (final metric in path.computeMetrics()) {
        final totalLength = metric.length;
        const step = 18.0;
        const dotRadius = 4.5;
        for (double d = 44; d < totalLength - 44; d += step) {
          final tangent = metric.getTangentForOffset(d);
          if (tangent != null) {
            canvas.drawCircle(tangent.position, dotRadius, dotPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant LevelPathDotsPainter oldDelegate) =>
      oldDelegate.nodeCenters != nodeCenters;
}
