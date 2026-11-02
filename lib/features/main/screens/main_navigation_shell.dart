import 'package:flutter/material.dart';

import '../../../core/widgets/curator_bottom_nav.dart';
import '../../history/screens/history_screen.dart';
import '../../history/repositories/history_repository.dart';
import '../../home/screens/home_screen.dart';
import '../../missions/repositories/mission_repository.dart';
import '../../profile/screens/profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({
    super.key,
    this.initialIndex = 0,
    this.userName,
    this.missionRepository = const MockMissionRepository(),
    this.historyRepository,
    this.onLogout,
  });

  final int initialIndex;
  final String? userName;
  final MissionRepository missionRepository;
  final HistoryRepository? historyRepository;
  final VoidCallback? onLogout;

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.userName ?? 'Arka';
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(
            isEmbedded: true,
            userName: name,
            missionRepository: widget.missionRepository,
          ),
          HistoryScreen(
            isEmbedded: true,
            userName: name,
            repository: widget.historyRepository,
          ),
          ProfileScreen(
            isEmbedded: true,
            userName: name,
            onLogout: widget.onLogout,
          ),
        ],
      ),
      bottomNavigationBar: CuratorBottomNav(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
      ),
    );
  }
}
