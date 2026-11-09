import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

class SketchHeader extends StatelessWidget {
  const SketchHeader({
    super.key,
    required this.score,
    required this.onBack,
  });

  final int score;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            key: const Key('sketch_back_button'),
            customBorder: const CircleBorder(),
            onTap: onBack,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF8B5CF6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Sketch\nChallenge',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3730A3),
              height: 1.15,
              letterSpacing: -0.4,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBE8),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFFDE8A5), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B4DFF).withValues(alpha: 0.08),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetPaths.star,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Skor',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3730A3),
                      height: 1.1,
                    ),
                  ),
                  Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3730A3),
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
