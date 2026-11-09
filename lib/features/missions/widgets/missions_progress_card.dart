import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

class MissionsProgressCard extends StatelessWidget {
  const MissionsProgressCard({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.earnedPoints,
  });

  final int completedCount;
  final int totalCount;
  final int earnedPoints;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDFE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.asset(
                AssetPaths.star,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '$completedCount dari $totalCount misi selesai',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
              ),
              Text(
                '+$earnedPoints',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF5B34EA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF5B34EA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
