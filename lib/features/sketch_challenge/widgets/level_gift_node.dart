import 'package:flutter/material.dart';

class LevelGiftNode extends StatelessWidget {
  const LevelGiftNode({
    super.key,
    required this.xRatio,
    required this.yRatio,
    required this.screenWidth,
    required this.contentHeight,
    required this.onTap,
  });

  final double xRatio;
  final double yRatio;
  final double screenWidth;
  final double contentHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cx = xRatio * screenWidth;
    final cy = yRatio * contentHeight;
    return Positioned(
      left: cx - 40,
      top: cy - 40,
      child: GestureDetector(
        key: const Key('level_gift_node'),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCE31),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x38B45309),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
            border: Border.all(color: const Color(0xFFF59E0B), width: 3.5),
          ),
          child: const Center(
            child: Icon(
              Icons.card_giftcard_rounded,
              color: Color(0xFF854D0E),
              size: 38,
            ),
          ),
        ),
      ),
    );
  }
}
