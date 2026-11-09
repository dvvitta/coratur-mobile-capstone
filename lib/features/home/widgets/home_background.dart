import 'package:flutter/material.dart';

/// Latar Home: dasar lavender-white bersih dengan beberapa bentuk organik
/// besar yang sebagian terpotong keluar layar.
///
/// Catatan performa:
/// - Semua dekorasi statis (tanpa animasi, tanpa shader, tanpa blur).
/// - Hanya memakai [Container] + [BoxDecoration], jadi murah untuk di-paint.
/// - Dibungkus [IgnorePointer] agar tidak pernah menangkap sentuhan.
class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key, required this.child});

  final Widget child;

  static const Color baseColor = Color(0xFFF8F7FF);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: baseColor),
        const Positioned.fill(
          child: IgnorePointer(child: _BackgroundShapes()),
        ),
        child,
      ],
    );
  }
}

class _BackgroundShapes extends StatelessWidget {
  const _BackgroundShapes();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // 1. Lingkaran lavender di kanan atas, terpotong tepi atas dan
            //    kanan (atmosfer utama area header).
            Positioned(
              top: -0.14 * w,
              right: -0.18 * w,
              child: _Blob(
                size: 0.58 * w,
                gradient: RadialGradient(
                  center: const Alignment(-0.25, -0.25),
                  radius: 0.92,
                  colors: [
                    const Color(0xFFEAE4FF).withValues(alpha: 0.92),
                    const Color(0xFFD9CEFF).withValues(alpha: 0.55),
                    const Color(0xFFD9CEFF).withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.78, 1.0],
                ),
              ),
            ),

            // 2. Selubung lavender sangat lembut di kiri atas, menjaga area
            //    sapaan tetap terang dan mudah dibaca.
            Positioned(
              top: -0.30 * w,
              left: -0.40 * w,
              child: _Blob(
                size: 0.95 * w,
                color: const Color(0xFFEAE4FF).withValues(alpha: 0.28),
                rotation: -0.35,
                topLeft: 0.56,
                topRight: 0.36,
                bottomRight: 0.54,
                bottomLeft: 0.42,
              ),
            ),

            // 3. Bentuk lavender pucat di sisi kanan, di belakang kartu
            //    belajar. Hanya tepinya yang terlihat sebagai ambient depth.
            Positioned(
              top: 0.28 * h,
              right: -0.66 * w,
              child: _Blob(
                size: 0.95 * w,
                color: const Color(0xFFD9CEFF).withValues(alpha: 0.18),
                rotation: 0.55,
                topLeft: 0.52,
                topRight: 0.32,
                bottomRight: 0.56,
                bottomLeft: 0.38,
              ),
            ),

            // 4. Aksen periwinkle lembut di kiri, dekat banner Sketch-to-Story.
            Positioned(
              top: 0.56 * h,
              left: -0.60 * w,
              child: _Blob(
                size: 0.86 * w,
                color: const Color(0xFFC9C7FF).withValues(alpha: 0.14),
                rotation: -0.55,
                topLeft: 0.36,
                topRight: 0.52,
                bottomRight: 0.34,
                bottomLeft: 0.58,
              ),
            ),

            // 5. Bidang lavender lebar dengan tepi atas melengkung di bagian
            //    bawah layar, menjadi dasar area misi & navigasi.
            Positioned(
              left: -0.10 * w,
              right: -0.10 * w,
              bottom: -0.20 * h,
              height: 0.46 * h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFD9CEFF).withValues(alpha: 0.0),
                      const Color(0xFFD9CEFF).withValues(alpha: 0.46),
                    ],
                    stops: const [0.0, 0.32],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(0.55 * w),
                  ),
                ),
              ),
            ),

            // 6. Bentuk organik besar di kanan bawah, terpotong tepi bawah
            //    dan kanan, menambah kedalaman di belakang daftar misi.
            Positioned(
              bottom: -0.34 * w,
              right: -0.36 * w,
              child: _Blob(
                size: 1.05 * w,
                color: const Color(0xFFEAE4FF).withValues(alpha: 0.50),
                rotation: 0.3,
                topLeft: 0.54,
                topRight: 0.42,
                bottomRight: 0.48,
                bottomLeft: 0.56,
              ),
            ),

            // 7. Lengkung tipis di kiri bawah, tepat di belakang area navigasi.
            Positioned(
              bottom: -0.30 * w,
              left: -0.46 * w,
              child: _Blob(
                size: 0.80 * w,
                color: const Color(0xFFEAE4FF).withValues(alpha: 0.35),
                rotation: 0.35,
                topLeft: 0.52,
                topRight: 0.40,
                bottomRight: 0.46,
                bottomLeft: 0.54,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Bentuk dekoratif dengan sudut tidak seragam agar terasa organik.
///
/// [size] adalah lebar & tinggi bentuk (persegi sebelum dirotasi); [topLeft]
/// dst. adalah faktor radius terhadap [size] (0.5 = sisi itu membulat penuh).
class _Blob extends StatelessWidget {
  const _Blob({
    required this.size,
    this.color,
    this.gradient,
    this.rotation = 0,
    this.topLeft = 0.5,
    this.topRight = 0.5,
    this.bottomRight = 0.5,
    this.bottomLeft = 0.5,
  });

  final double size;
  final Color? color;
  final Gradient? gradient;
  final double rotation;
  final double topLeft;
  final double topRight;
  final double bottomRight;
  final double bottomLeft;

  @override
  Widget build(BuildContext context) {
    final shape = SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: gradient == null ? color : null,
          gradient: gradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size * topLeft),
            topRight: Radius.circular(size * topRight),
            bottomRight: Radius.circular(size * bottomRight),
            bottomLeft: Radius.circular(size * bottomLeft),
          ),
        ),
      ),
    );

    if (rotation == 0) return shape;
    return Transform.rotate(angle: rotation, child: shape);
  }
}
