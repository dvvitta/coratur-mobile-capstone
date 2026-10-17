import 'package:flutter/material.dart';

/// Tema awal. Palet final harus mengikuti aset/screenshot, bukan ditebak.
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    const seed = Color(0xFF7E57C2);
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seed),
      useMaterial3: true,
    );
  }
}
