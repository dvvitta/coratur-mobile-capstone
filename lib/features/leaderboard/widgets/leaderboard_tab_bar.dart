import 'package:flutter/material.dart';

import '../controllers/leaderboard_controller.dart';

/// Tab filter "Global" dan "Teman" pada Leaderboard.
///
/// Satu wadah pill putih dengan dua segmen di dalamnya — segmen aktif
/// memakai gradient ungu, segmen non-aktif menyatu dengan latar putih.
/// Mengikuti referensi desain SKETCHOO.
class LeaderboardTabBar extends StatelessWidget {
  const LeaderboardTabBar({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  final LeaderboardTab activeTab;
  final ValueChanged<LeaderboardTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE9DFFB), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14522CA6),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TabButton(
              key: const Key('leaderboard_tab_global'),
              label: 'Global',
              icon: Icons.public_rounded,
              isActive: activeTab == LeaderboardTab.global,
              onTap: () => onTabChanged(LeaderboardTab.global),
            ),
            _TabButton(
              key: const Key('leaderboard_tab_teman'),
              label: 'Teman',
              icon: Icons.group_rounded,
              isActive: activeTab == LeaderboardTab.teman,
              onTap: () => onTabChanged(LeaderboardTab.teman),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TabButton — satu segmen pill interaktif
// ─────────────────────────────────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  static const _activeGradient = LinearGradient(
    colors: [Color(0xFF7F52F7), Color(0xFF673BEA)],
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            gradient: isActive ? _activeGradient : null,
            color: isActive ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            boxShadow: isActive
                ? const [
                    BoxShadow(
                      color: Color(0x35673BEA),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? Colors.white : const Color(0xFF673BEA),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : const Color(0xFF673BEA),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
