import 'package:flutter/material.dart';

import '../models/sketch_challenge_models.dart';

class ResultDrawingCard extends StatelessWidget {
  const ResultDrawingCard({
    super.key,
    required this.lines,
    required this.canvasSize,
  });

  final List<DrawnLine> lines;
  final Size canvasSize;

  @override
  Widget build(BuildContext context) {
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
            ? CustomPaint(
                painter: ResultPainter(lines: lines, sourceSize: canvasSize),
              )
            : const SizedBox(),
      ),
    );
  }
}

class ResultPainter extends CustomPainter {
  const ResultPainter({required this.lines, required this.sourceSize});

  final List<DrawnLine> lines;
  final Size sourceSize;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = sourceSize.width > 0 ? size.width / sourceSize.width : 1.0;
    final sy = sourceSize.height > 0 ? size.height / sourceSize.height : 1.0;
    final scale = sx < sy ? sx : sy;
    final dx = (size.width - sourceSize.width * scale) / 2;
    final dy = (size.height - sourceSize.height * scale) / 2;
    canvas.translate(dx, dy);
    canvas.scale(scale);

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
  bool shouldRepaint(covariant ResultPainter old) => old.lines != lines;
}
