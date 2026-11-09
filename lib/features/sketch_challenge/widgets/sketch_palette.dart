import 'package:flutter/material.dart';

class SketchPalette extends StatelessWidget {
  const SketchPalette({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: colors.map((color) {
          final isSelected = selectedColor == color;
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 44 : 36,
              height: isSelected ? 44 : 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.white, width: 3)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
