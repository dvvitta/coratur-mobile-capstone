import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

class LevelHeader extends StatelessWidget {
  const LevelHeader({
    super.key,
    required this.totalStars,
    required this.onBack,
  });

  final int totalStars;
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
            key: const Key('level_back_button'),
            customBorder: const CircleBorder(),
            onTap: onBack,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF8F6AF7),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3343309A),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Sketch Challenge',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3730A3),
              letterSpacing: -0.4,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFAE4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFDE8A5), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetPaths.star,
                width: 30,
                height: 30,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6B4DFF),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$totalStars',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3730A3),
                      height: 1.0,
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
