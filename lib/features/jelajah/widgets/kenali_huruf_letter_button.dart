import 'package:flutter/material.dart';

class KenaliHurufLetterButton extends StatelessWidget {
  const KenaliHurufLetterButton({
    super.key,
    required this.letter,
    required this.scale,
    required this.onTap,
  });

  final String letter;
  final double scale;
  final VoidCallback onTap;

  static const _colors = {
    'A': Color(0xFFFF8EAA),
    'B': Color(0xFF8CC4FF),
    'C': Color(0xFFBBA4FF),
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[letter] ?? const Color(0xFFBBA4FF);
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24 * scale),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24 * scale),
        child: SizedBox(
          width: 107 * scale,
          height: 120 * scale,
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 52 * scale,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
