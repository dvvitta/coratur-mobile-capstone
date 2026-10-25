import 'package:flutter/material.dart';

class DrawnLine {
  const DrawnLine({
    required this.points,
    required this.color,
    this.strokeWidth = 4.0,
  });

  final List<Offset> points;
  final Color color;
  final double strokeWidth;
}

class SketchChallengePrompt {
  const SketchChallengePrompt({
    required this.id,
    required this.title,
    required this.instruction,
    required this.stepText,
    this.guideAssetPath,
  });

  final String id;
  final String title;
  final String instruction;
  final String stepText;
  final String? guideAssetPath;
}
