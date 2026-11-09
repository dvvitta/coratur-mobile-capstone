import 'package:flutter/material.dart';

import '../models/sketch_to_story_option.dart';

/// Kartu aksi vertikal: icon di atas, teks di bawah.
///
/// Menampilkan border highlight ketika [isSelected] true.
class SketchToStoryOptionCard extends StatelessWidget {
  const SketchToStoryOptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final SketchToStoryOption option;
  final bool isSelected;
  final VoidCallback onTap;

  // ── Warna ──────────────────────────────────────────────────────────────────
  static const _bgNormal   = Color(0xFFF0EEFF);
  static const _bgSelected = Color(0xFFE3D9FF);
  static const _borderNormal   = Color(0xFFDDD5FF);
  static const _borderSelected = Color(0xFF7C4DFF);
  static const _titleColor  = Color(0xFF5B3FD9);
  static const _descColor   = Color(0xFF7A7A9A);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected ? _bgSelected : _bgNormal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? _borderSelected : _borderNormal,
          width: isSelected ? 2 : 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: _borderSelected.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.asset(option.imagePath, fit: BoxFit.contain),
                ),
                const SizedBox(height: 12),

                // Judul
                Text(
                  option.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _titleColor,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),

                // Deskripsi
                Text(
                  option.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _descColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
