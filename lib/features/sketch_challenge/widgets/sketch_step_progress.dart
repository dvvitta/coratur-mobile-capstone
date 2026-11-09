import 'package:flutter/material.dart';

class SketchStepProgress extends StatelessWidget {
  const SketchStepProgress({
    super.key,
    required this.instruction,
    required this.stepText,
    this.progress = 2 / 5,
  });

  final String instruction;
  final String stepText;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          instruction,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E1B4B),
            height: 1.25,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFE5DEFF),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF6B4DFF),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              stepText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1B4B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
