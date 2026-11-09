import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import 'learning_card.dart';

class HomeLearningSection extends StatelessWidget {
  const HomeLearningSection({
    super.key,
    required this.onSketchChallengeTap,
    required this.onJelajahCilikTap,
  });

  final VoidCallback onSketchChallengeTap;
  final VoidCallback onJelajahCilikTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Mau Belajar apa hari ini?',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF19162F),
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LearningCard(
                key: const Key('home_learning_sketch_challenge'),
                title: 'Sketch Challenge',
                gradient: const [Color(0xFFFFF7DB), Color(0xFFFFEDBC)],
                accentColor: const Color(0xFFE9A23B),
                imagePath: AssetPaths.sketchChallenge,
                onTap: onSketchChallengeTap,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: LearningCard(
                key: const Key('home_learning_jelajah_cilik'),
                title: 'Jelajah Cilik',
                gradient: const [Color(0xFFE7FBEA), Color(0xFFD2F5DA)],
                accentColor: const Color(0xFF35B36B),
                imagePath: AssetPaths.jelajahCilik,
                onTap: onJelajahCilikTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
