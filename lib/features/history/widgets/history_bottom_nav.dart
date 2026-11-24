import 'package:flutter/material.dart';

import '../../../core/widgets/curator_bottom_nav.dart';

class HistoryBottomNav extends StatelessWidget {
  const HistoryBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return CuratorBottomNav(
      selectedIndex: NavIndex.history,
      onDestinationSelected: (index) =>
          CuratorBottomNav.navigateTo(context, index),
    );
  }
}
