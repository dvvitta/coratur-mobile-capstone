import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../models/mission_item.dart';

class MissionCard extends StatelessWidget {
  const MissionCard({
    super.key,
    required this.mission,
    this.backgroundColor,
    this.borderColor,
    this.onAction,
  });

  final MissionItem mission;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ??
        (mission.isCompleted
            ? const Color(0xFFEDFBF1)
            : const Color(0xFFFEF8E3));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.2)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLeadingIcon(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mission.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  mission.category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: mission.progressRatio,
                          minHeight: 5,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            mission.isCompleted
                                ? const Color(0xFF22C55E)
                                : const Color(0xFF6342E8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${mission.currentProgress}/${mission.totalProgress}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildTrailing(),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Image.asset(
          mission.iconPath,
          width: 28,
          height: 28,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(
            Icons.task_alt_rounded,
            color: Color(0xFF6342E8),
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing() {
    if (mission.isCompleted) {
      return Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFF22C55E),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 22,
        ),
      );
    }

    final isOutlined = mission.actionLabel == 'Lanjut';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AssetPaths.star,
              width: 19,
              height: 19,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 3),
            Text(
              '+${mission.reward}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 32,
          child: isOutlined
              ? OutlinedButton(
                  onPressed: onAction,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF6342E8), width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    mission.actionLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6342E8),
                    ),
                  ),
                )
              : FilledButton(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6342E8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    mission.actionLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
