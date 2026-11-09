import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// Permukaan "liquid glass" yang dipakai ulang di Home.
///
/// Efek blur hanya diberikan pada elemen yang memang butuh kedalaman
/// (kartu utama, kartu misi, dan navigasi), bukan ke semua elemen.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.radius = 24,
    this.blur = 20,
    this.tint = const Color(0xA6FFFFFF),
    this.gradient,
    this.borderColor = const Color(0xD9FFFFFF),
    this.borderWidth = 1,
    this.padding,
    this.margin,
    this.shadows,
  });

  final Widget child;
  final double radius;
  final double blur;
  final Color tint;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow:
            shadows ??
            const [
              BoxShadow(
                color: Color(0x147042F5),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: gradient == null ? tint : null,
              gradient: gradient,
              borderRadius: borderRadius,
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
