import 'package:flutter/material.dart';

import '../models/sketch_challenge_models.dart';

class SketchCanvasPainter extends CustomPainter {
  const SketchCanvasPainter({
    required this.lines,
  });

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
        canvas.drawCircle(line.points.first, line.strokeWidth / 2, paint..style = PaintingStyle.fill);
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
  bool shouldRepaint(covariant SketchCanvasPainter oldDelegate) {
    return true;
  }
}
