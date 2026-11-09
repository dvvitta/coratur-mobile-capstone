import 'package:flutter/material.dart';

import '../models/level_item_model.dart';

class LevelActionCard extends StatelessWidget {
  const LevelActionCard({
    super.key,
    required this.level,
    required this.onStart,
  });

  final LevelItem level;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('level_bottom_action_card'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2243309A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Level ${level.levelNumber} ${level.title}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  level.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7546F8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 42,
            child: FilledButton(
              key: const Key('level_start_button'),
              onPressed: level.status == LevelStatus.locked ? null : onStart,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6B4DFF),
                disabledBackgroundColor: const Color(0xFFDDD2FB),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Mulai',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
