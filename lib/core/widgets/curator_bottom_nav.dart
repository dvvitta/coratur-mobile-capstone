import 'package:flutter/material.dart';

class CuratorBottomNav extends StatelessWidget {
  const CuratorBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4DFF).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              const tabCount = 3;
              final slotWidth = totalWidth / tabCount;
              const pillWidth = 74.0;
              const pillHeight = 44.0;

              // Hitung posisi horizontal pill animasi
              final targetLeft = (slotWidth * selectedIndex) +
                  ((slotWidth - pillWidth) / 2);

              return SizedBox(
                height: pillHeight,
                child: Stack(
                  children: [
                    // Pill animasi ungu yang meluncur smooth antar tab
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      left: targetLeft,
                      top: 0,
                      width: pillWidth,
                      height: pillHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6D3FE0),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x336D3FE0),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Tiga item tab interaktif
                    Row(
                      children: [
                        Expanded(
                          child: _buildTabItem(
                            key: const Key('nav_home_button'),
                            index: 0,
                            icon: Icons.home_rounded,
                          ),
                        ),
                        Expanded(
                          child: _buildTabItem(
                            key: const Key('nav_history_button'),
                            index: 1,
                            icon: Icons.history_rounded,
                          ),
                        ),
                        Expanded(
                          child: _buildTabItem(
                            key: const Key('nav_profile_button'),
                            index: 2,
                            icon: Icons.person_rounded,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required Key key,
    required int index,
    required IconData icon,
  }) {
    final isSelected = selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: key,
        borderRadius: BorderRadius.circular(22),
        onTap: () => onDestinationSelected(index),
        child: SizedBox(
          height: 44,
          child: Center(
            child: TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              tween: ColorTween(
                begin: isSelected ? const Color(0xFF6D3FE0) : Colors.white,
                end: isSelected ? Colors.white : const Color(0xFF6D3FE0),
              ),
              builder: (context, color, child) {
                return Icon(
                  icon,
                  size: 27,
                  color: color,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
