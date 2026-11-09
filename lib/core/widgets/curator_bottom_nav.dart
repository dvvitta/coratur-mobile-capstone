import 'dart:ui' show ImageFilter;

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
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(33),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F7042F5),
              blurRadius: 28,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(33),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xA6FFFFFF),
                borderRadius: BorderRadius.circular(33),
                border: Border.all(color: const Color(0xCCFFFFFF)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const tabCount = 3;
                  const pillWidth = 80.0;
                  const pillHeight = 46.0;
                  final slotWidth = constraints.maxWidth / tabCount;
                  final targetLeft =
                      (slotWidth * selectedIndex) +
                      ((slotWidth - pillWidth) / 2);

                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        left: targetLeft,
                        top: (66 - pillHeight) / 2,
                        width: pillWidth,
                        height: pillHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF8B5CF6), Color(0xFF6D3FE0)],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x527042F5),
                                blurRadius: 16,
                                offset: Offset(0, 7),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                  );
                },
              ),
            ),
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
        borderRadius: BorderRadius.circular(26),
        onTap: () => onDestinationSelected(index),
        child: SizedBox(
          height: 66,
          child: Center(
            child: TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              tween: ColorTween(
                begin: isSelected
                    ? const Color(0xFFB5A1F7)
                    : const Color(0xFF6D3FE0),
                end: isSelected
                    ? Colors.white
                    : const Color(0xFFB5A1F7),
              ),
              builder: (context, color, child) {
                return Icon(icon, size: 27, color: color);
              },
            ),
          ),
        ),
      ),
    );
  }
}
