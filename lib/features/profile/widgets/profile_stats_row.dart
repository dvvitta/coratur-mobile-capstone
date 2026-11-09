import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.drawings,
    required this.stars,
    required this.badges,
    this.onBadgesTap,
  });

  final int drawings;
  final int stars;
  final int badges;
  final VoidCallback? onBadgesTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProfileStatCard(
            key: const Key('profile_stat_drawings'),
            icon: Icons.image_outlined,
            iconBgColor: const Color(0xFFE0F8EA),
            iconColor: const Color(0xFF20B879),
            value: drawings,
            label: 'Gambar',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ProfileStatCard(
            key: const Key('profile_stat_stars'),
            icon: Icons.star_rounded,
            iconBgColor: const Color(0xFFFFF4D5),
            iconColor: const Color(0xFFF2B51B),
            value: stars,
            label: 'Bintang',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ProfileStatCard(
            key: const Key('profile_stat_badges'),
            iconAsset: AssetPaths.badge,
            iconBgColor: const Color(0xFFEAE4FF),
            iconColor: const Color(0xFF7042F5),
            value: badges,
            label: 'Badge',
            onTap: onBadgesTap,
          ),
        ),
      ],
    );
  }
}

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({
    super.key,
    required this.iconBgColor,
    required this.iconColor,
    required this.value,
    required this.label,
    this.icon,
    this.iconAsset,
    this.onTap,
  }) : assert(
         icon != null || iconAsset != null,
         'Sediakan icon atau iconAsset.',
       );

  final IconData? icon;
  final String? iconAsset;
  final Color iconBgColor;
  final Color iconColor;
  final int value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xE6FFFFFF), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F7042F5),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: iconAsset != null
                  ? Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(iconAsset!, fit: BoxFit.contain),
                    )
                  : Icon(icon, size: 22, color: iconColor),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF19162F),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF77758A),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        key: const Key('profile_badges_button'),
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: card,
      ),
    );
  }
}
