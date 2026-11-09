import 'dart:math' as math;
import 'package:flutter/material.dart';

class HitungHewanDesignLayout {
  HitungHewanDesignLayout(this.size) {
    final coverScale = math.max(size.width / 841, size.height / 1871);
    final backgroundWidth = 841 * coverScale;
    final backgroundHeight = 1871 * coverScale;

    _dx = (size.width - backgroundWidth) / 2;
    _dy = (size.height - backgroundHeight) / 2;
    scale = coverScale * (841 / 412);
  }

  final Size size;

  late final double _dx;
  late final double _dy;
  late final double scale;

  double get centerX => size.width / 2;

  Offset point(double x, double y) => Offset(_dx + x * scale, _dy + y * scale);

  double topOf(double y) => _dy + y * scale;
}

class HitungHewanDashedBorderPainter extends CustomPainter {
  const HitungHewanDashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius - inset)),
      );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..color = color
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(HitungHewanDashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.radius != radius ||
      oldDelegate.dashLength != dashLength ||
      oldDelegate.gapLength != gapLength;
}
