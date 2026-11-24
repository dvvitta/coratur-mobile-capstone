import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/curator_bottom_nav.dart';

/// Navigasi bawah Home saat halaman dipakai berdiri sendiri (bukan embedded).
/// Visual dan perilakunya sama dengan navigasi utama aplikasi.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    this.onLeaderboardTap,
    required this.onHistoryTap,
    required this.onProfileTap,
  });

  final VoidCallback? onLeaderboardTap;
  final VoidCallback onHistoryTap;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return CuratorBottomNav(
      selectedIndex: NavIndex.home,
      onDestinationSelected: (index) {
        if (index == NavIndex.leaderboard) {
          if (onLeaderboardTap != null) {
            onLeaderboardTap!();
          } else {
            Navigator.of(context).pushNamed(AppRoutes.leaderboard);
          }
        } else if (index == NavIndex.history) {
          onHistoryTap();
        } else if (index == NavIndex.profile) {
          onProfileTap();
        }
      },
    );
  }
}
