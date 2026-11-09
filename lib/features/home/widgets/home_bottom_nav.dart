import 'package:flutter/material.dart';

import '../../../core/widgets/curator_bottom_nav.dart';

/// Navigasi bawah Home saat halaman dipakai berdiri sendiri (bukan embedded).
/// Visual dan perilakunya sama dengan navigasi utama aplikasi.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    required this.onHistoryTap,
    required this.onProfileTap,
  });

  final VoidCallback onHistoryTap;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return CuratorBottomNav(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        if (index == 1) onHistoryTap();
        if (index == 2) onProfileTap();
      },
    );
  }
}
