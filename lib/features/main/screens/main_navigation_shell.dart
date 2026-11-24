import 'package:flutter/material.dart';

import '../../../core/widgets/curator_bottom_nav.dart';
import '../../history/repositories/history_repository.dart';
import '../../history/screens/history_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../leaderboard/repositories/leaderboard_repository.dart';
import '../../leaderboard/screens/leaderboard_screen.dart';
import '../../missions/repositories/mission_repository.dart';
import '../../profile/models/profile_photo.dart';
import '../../profile/screens/profile_screen.dart';
import '../../profile/services/profile_photo_service.dart';

/// Shell navigasi utama: Home → Leaderboard → History → Profile.
///
/// Menggunakan [PageView] non-scrollable sehingga setiap halaman
/// tetap hidup di memory selama shell aktif (preserves scroll state).
/// [CuratorBottomNav] bergerak sesuai [_currentIndex].
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({
    super.key,
    this.initialIndex = 0,
    this.userName,
    this.profilePhoto,
    this.onProfilePhotoChanged,
    this.missionRepository = const MockMissionRepository(),
    this.historyRepository,
    this.leaderboardRepository = const MockLeaderboardRepository(),
    this.onLogout,
    this.onJoinClassroom,
  });

  final int initialIndex;
  final String? userName;
  final ProfilePhoto? profilePhoto;
  final ValueChanged<ProfilePhoto>? onProfilePhotoChanged;
  final MissionRepository missionRepository;
  final HistoryRepository? historyRepository;
  final LeaderboardRepository leaderboardRepository;
  final VoidCallback? onLogout;
  final Future<Map<String, String>?> Function(String code)? onJoinClassroom;

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;
  late final PageController _pageController;
  ProfilePhoto? _activePhoto;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _activePhoto = widget.profilePhoto;
    if (_activePhoto == null) {
      ProfilePhotoService().load().then((p) {
        if (mounted && p != null) {
          setState(() => _activePhoto = p);
          widget.onProfilePhotoChanged?.call(p);
        }
      });
    }
  }

  @override
  void didUpdateWidget(MainNavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profilePhoto != null &&
        widget.profilePhoto != oldWidget.profilePhoto) {
      _activePhoto = widget.profilePhoto;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final name = widget.userName ?? 'Arka';
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Index 0 — Home
          HomeScreen(
            isEmbedded: true,
            userName: name,
            profilePhoto: _activePhoto,
            missionRepository: widget.missionRepository,
          ),

          // Index 1 — Leaderboard
          LeaderboardScreen(
            isEmbedded: true,
            repository: widget.leaderboardRepository,
          ),

          // Index 2 — History
          HistoryScreen(
            isEmbedded: true,
            userName: name,
            repository: widget.historyRepository,
          ),

          // Index 3 — Profile
          ProfileScreen(
            isEmbedded: true,
            userName: name,
            profilePhoto: _activePhoto,
            onProfilePhotoChanged: (photo) {
              setState(() => _activePhoto = photo);
              widget.onProfilePhotoChanged?.call(photo);
            },
            onLogout: widget.onLogout,
            onJoinClassroom: widget.onJoinClassroom,
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
