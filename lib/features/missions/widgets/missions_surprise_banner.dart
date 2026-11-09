import 'package:flutter/material.dart';

class MissionsSurpriseBanner extends StatelessWidget {
  const MissionsSurpriseBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1248),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2266),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: Color(0xFFFFB020),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selesaikan semua misi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'untuk buka kejutan hari ini!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF948BB8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
