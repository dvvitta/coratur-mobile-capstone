import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/jelajah_models.dart';

class JelajahScrollBehavior extends MaterialScrollBehavior {
  const JelajahScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.unknown,
  };
}

class JelajahCategoryChips extends StatelessWidget {
  const JelajahCategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  final JelajahCategory? selectedCategory;
  final ValueChanged<JelajahCategory?> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ScrollConfiguration(
        behavior: const JelajahScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          key: const Key('jelajah_chip_scroll'),
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildChip(
                key: const Key('jelajah_chip_semua'),
                label: 'Semua',
                isActive: selectedCategory == null,
                background: const Color(0xFF6C42F5),
                accent: Colors.white,
                icon: Icons.grid_view_rounded,
                onTap: () => onSelectCategory(null),
              ),
              for (final category in JelajahCategory.values) ...[
                const SizedBox(width: 8),
                _buildChip(
                  key: Key('jelajah_chip_${category.name}'),
                  label: category.label,
                  isActive: selectedCategory == category,
                  background: category.chipBackground,
                  accent: category.accent,
                  icon: category.icon,
                  glyph: category.glyph,
                  onTap: () => onSelectCategory(category),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required Key key,
    required String label,
    required bool isActive,
    required Color background,
    required Color accent,
    required IconData icon,
    required VoidCallback onTap,
    String? glyph,
  }) {
    return GestureDetector(
      key: key,
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(13),
          boxShadow: isActive
              ? const [
                  BoxShadow(
                    color: Color(0x336C42F5),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (glyph != null)
              Text(
                glyph,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: accent,
                ),
              )
            else
              Icon(icon, size: 15, color: accent),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
