import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../../../core/widgets/glass_surface.dart';

class HomeAdventureCard extends StatelessWidget {
  const HomeAdventureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      radius: 30,
      blur: 24,
      borderColor: const Color(0xE6FFFFFF),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEDE3FF), Color(0xFFE2ECFF), Color(0xFFE8F5F6)],
      ),
      shadows: const [
        BoxShadow(
          color: Color(0x127042F5),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Row(
        children: [
          Image.asset(
            AssetPaths.palette,
            width: 92,
            height: 92,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.palette_outlined,
              color: Color(0xFF7042F5),
              size: 48,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Petualangan Hari ini',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF19162F),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Kamu sudah menyelesaikan\n3 permainan hari ini',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF77758A),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0x8CFFFFFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Color(0xFF7042F5),
            ),
          ),
        ],
      ),
    );
  }
}
