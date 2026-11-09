import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../models/level_item_model.dart';

class LevelNodeWidget extends StatelessWidget {
  const LevelNodeWidget({
    super.key,
    required this.level,
    required this.isSelected,
    required this.screenWidth,
    required this.contentHeight,
    required this.onTap,
  });

  final LevelItem level;
  final bool isSelected;
  final double screenWidth;
  final double contentHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cx = level.xRatio * screenWidth;
    final cy = level.yRatio * contentHeight;

    Widget nodeCircle;
    List<Widget> starsUnderneath = [];
    String labelText = level.title;

    switch (level.status) {
      case LevelStatus.completed:
        nodeCircle = Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: const Color(0xFF4EDE94),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            border: isSelected
                ? Border.all(color: const Color(0xFF7546F8), width: 3.5)
                : null,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 38),
        );
        final starCount = level.highStars.clamp(1, 3);
        starsUnderneath = List.generate(
          starCount,
          (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Image.asset(
              AssetPaths.star,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        );
        break;

      case LevelStatus.active:
        nodeCircle = Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x337546F8),
                border: Border.all(color: const Color(0x557546F8), width: 2.5),
              ),
            ),
            Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: Color(0xFF7546F8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x447546F8),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        );
        break;

      case LevelStatus.locked:
        nodeCircle = Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xFFDDD2FB),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.lock_rounded,
            color: Color(0xFF7546F8),
            size: 26,
          ),
        );
        labelText = '';
        break;
    }

    return Positioned(
      left: cx - 43,
      top: cy - 43,
      child: GestureDetector(
        key: Key('level_node_${level.levelNumber}'),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 86, height: 86, child: Center(child: nodeCircle)),
            if (labelText.isNotEmpty) ...[
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      labelText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF3730A3),
                      ),
                    ),
                  ),
                  if (starsUnderneath.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: starsUnderneath,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
