import 'package:flutter/material.dart';

/// Kategori konten pada halaman Jelajah Cilik.
enum JelajahCategory {
  membaca(
    label: 'Membaca',
    chipBackground: Color(0xFFFFEBF0),
    accent: Color(0xFFE0315F),
    badgeColor: Color(0xFFFC7194),
    icon: Icons.menu_book_rounded,
  ),
  berhitung(
    label: 'Berhitung',
    chipBackground: Color(0xFFDEF6FC),
    accent: Color(0xFF0288D1),
    badgeColor: Color(0xFF3EC5F0),
    icon: Icons.calculate_rounded,
    glyph: '123',
  ),
  menggambar(
    label: 'Menggambar',
    chipBackground: Color(0xFFE3F9E5),
    accent: Color(0xFF1E9638),
    badgeColor: Color(0xFF4ECB71),
    icon: Icons.brush_rounded,
  );

  const JelajahCategory({
    required this.label,
    required this.chipBackground,
    required this.accent,
    required this.badgeColor,
    required this.icon,
    this.glyph,
  });

  final String label;
  final Color chipBackground;
  final Color accent;
  final Color badgeColor;
  final IconData icon;

  /// Jika diisi, chip menampilkan teks ini sebagai ikon (contoh: "123").
  final String? glyph;
}

/// Satu kartu aktivitas di halaman Jelajah Cilik.
class JelajahItem {
  const JelajahItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.levelLabel,
    this.imageAssetPath,
    this.routeName,
  });

  final String id;
  final String title;
  final String description;
  final JelajahCategory category;
  final String levelLabel;

  /// Rute tujuan saat kartu diketuk. Jika null, kartu menampilkan
  /// snackbar "segera hadir".
  final String? routeName;

  /// Thumbnail menyusul dari desainer. Selama null, kartu memakai
  /// placeholder bergradien sesuai kategori.
  final String? imageAssetPath;
}
