import 'package:flutter/material.dart';

/// Tombol "Mulai Sekarang" full-width dengan gradient ungu.
class SketchToStoryStartButton extends StatelessWidget {
  const SketchToStoryStartButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [Color(0xFF7C4DFF), Color(0xFF9C6DFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x447C4DFF),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(32),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mulai Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
