import 'package:flutter/material.dart';

import '../models/jelajah_models.dart';

class JelajahCard extends StatelessWidget {
  const JelajahCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final JelajahItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('jelajah_card_${item.id}'),
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFEDEDF8), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D43309A),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThumbnail(item),
              const SizedBox(height: 9),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF5A48B5),
                  height: 1.15,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA79EE3),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              _buildLevelPill(item.levelLabel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(JelajahItem item) {
    final category = item.category;

    return AspectRatio(
      aspectRatio: 1.62,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: item.imageAssetPath != null
                  ? Image.asset(item.imageAssetPath!, fit: BoxFit.cover)
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            category.chipBackground,
                            Color.lerp(
                              category.chipBackground,
                              Colors.white,
                              0.45,
                            )!,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          category.icon,
                          size: 38,
                          color: category.accent.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            left: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: category.badgeColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(category.icon, size: 11, color: Colors.white),
                  const SizedBox(width: 3),
                  Text(
                    category.label,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFE9E3FE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF6C42F5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelPill(String label) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF4C5),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, size: 15, color: Color(0xFFFFC93C)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7B7DBE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
