import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../constants/app_routes.dart';

/// Tab index yang digunakan di seluruh app.
abstract final class NavIndex {
  static const home        = 0;
  static const leaderboard = 1;
  static const history     = 2;
  static const profile     = 3;
}

/// Bottom navigation bar pill-style dengan blur background.
///
/// Menampilkan 4 tab: Home, Leaderboard, History, Profile.
/// Pill aktif bergerak dengan AnimatedPositioned.
class CuratorBottomNav extends StatelessWidget {
  const CuratorBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  /// Navigasi standar antar tab ketika screen dibuka mandiri (tidak di dalam shell).
  static void navigateTo(BuildContext context, int index) {
    switch (index) {
      case NavIndex.home:
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        break;
      case NavIndex.leaderboard:
        Navigator.of(context).pushReplacementNamed(AppRoutes.leaderboard);
        break;
      case NavIndex.history:
        Navigator.of(context).pushReplacementNamed(AppRoutes.history);
        break;
      case NavIndex.profile:
        Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
        break;
    }
  }

  static const _tabs = [
    _TabSpec(key: Key('nav_home_button'),        icon: Icons.home_rounded),
    _TabSpec(key: Key('nav_leaderboard_button'), icon: Icons.leaderboard_rounded),
    _TabSpec(key: Key('nav_history_button'),     icon: Icons.history_rounded),
    _TabSpec(key: Key('nav_profile_button'),     icon: Icons.person_rounded),
  ];

  static const _tabCount   = 4;
  static const _pillWidth  = 72.0;
  static const _pillHeight = 46.0;
  static const _barHeight  = 66.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        height: _barHeight,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(33)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1F7042F5),
              blurRadius: 28,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(33)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xA6FFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(33)),
                border: Border.all(color: const Color(0xCCFFFFFF)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final slotWidth  = constraints.maxWidth / _tabCount;
                  final pillLeft   = slotWidth * selectedIndex +
                                     (slotWidth - _pillWidth) / 2;

                  return Stack(
                    children: [
                      // Pill aktif bergerak
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        left: pillLeft,
                        top: (_barHeight - _pillHeight) / 2,
                        width: _pillWidth,
                        height: _pillHeight,
                        child: const _ActivePill(),
                      ),

                      // Tab items
                      Row(
                        children: List.generate(
                          _tabCount,
                          (i) => Expanded(
                            child: _NavTabItem(
                              spec: _tabs[i],
                              isSelected: selectedIndex == i,
                              onTap: () => onDestinationSelected(i),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ActivePill  — dekorasi gradient pill yang bergerak
// ─────────────────────────────────────────────────────────────────────────────

class _ActivePill extends StatelessWidget {
  const _ActivePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(23)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B5CF6), Color(0xFF6D3FE0)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x527042F5),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _NavTabItem  — satu icon tab dengan animasi warna
// ─────────────────────────────────────────────────────────────────────────────

class _NavTabItem extends StatelessWidget {
  const _NavTabItem({
    required this.spec,
    required this.isSelected,
    required this.onTap,
  });

  final _TabSpec spec;
  final bool isSelected;
  final VoidCallback onTap;

  static const _colorActive   = Colors.white;
  static const _colorInactive = Color(0xFFB5A1F7);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: spec.key,
        borderRadius: const BorderRadius.all(Radius.circular(26)),
        onTap: onTap,
        child: SizedBox(
          height: 66,
          child: Center(
            child: TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              tween: ColorTween(
                begin: isSelected ? _colorInactive : _colorActive,
                end:   isSelected ? _colorActive   : _colorInactive,
              ),
              builder: (context, color, _) =>
                  Icon(spec.icon, size: 27, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TabSpec  — data konfigurasi satu tab (immutable)
// ─────────────────────────────────────────────────────────────────────────────

class _TabSpec {
  const _TabSpec({required this.key, required this.icon});

  final Key key;
  final IconData icon;
}
