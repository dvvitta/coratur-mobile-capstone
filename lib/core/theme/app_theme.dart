import 'package:flutter/material.dart';

/// Tema global aplikasi Sketchoo.
///
/// Poppins didaftarkan sebagai [fontFamily] default sehingga berlaku
/// di seluruh app tanpa perlu menentukan font per-widget.
/// Weight mapping Poppins:
///   w100 = Thin, w200 = ExtraLight, w300 = Light,
///   w400 = Regular, w500 = Medium, w600 = SemiBold,
///   w700 = Bold, w800 = ExtraBold, w900 = Black
class AppTheme {
  const AppTheme._();

  static const _fontFamily = 'Poppins';
  static const _seed = Color(0xFF7E57C2);

  static ThemeData light() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _seed),
      useMaterial3: true,
      fontFamily: _fontFamily,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: _fontFamily),
      primaryTextTheme: base.primaryTextTheme.apply(fontFamily: _fontFamily),
    );
  }
}
