import 'package:flutter/material.dart';

class KenaliHurufWhiteWave extends StatelessWidget {
  const KenaliHurufWhiteWave({super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _WavePainter());
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Path()
      ..moveTo(0, 22)
      ..quadraticBezierTo(s.width * .2, -5, s.width * .4, 20)
      ..quadraticBezierTo(s.width * .7, 50, s.width, 12)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    c.drawPath(p, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}
