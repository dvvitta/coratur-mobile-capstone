import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

/// Header visual halaman Leaderboard.
///
/// Top bar ringkas: hanya judul "Leaderboard" di tengah (tanpa tombol back
/// dan tanpa ikon piala — keduanya tidak dipakai di shell navigasi).
/// Mascot gajah ungu memegang piala tampil besar di tengah, dan bagian
/// bawahnya ditutup awan putih lembut seperti referensi desain SKETCHOO.
class LeaderboardHeader extends StatelessWidget {
  const LeaderboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [_HeaderTitle(), _MascotHero()]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HeaderTitle — judul halaman
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Text(
        'Leaderboard',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1E1547),
          height: 1.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _MascotHero — gajah memegang piala + awan penutup bawah
// ─────────────────────────────────────────────────────────────────────────────

class _MascotHero extends StatelessWidget {
  const _MascotHero();

  /// Tinggi area hero. Aset gajah 1536 × 1024 tampil dengan lebar 246.
  static const double _height = 176;
  static const double _mascotWidth = 246;
  static const double _cloudHeight = 42;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            AssetPaths.gajahLead,
            width: _mascotWidth,
            fit: BoxFit.contain,
          ),
          // Awan putih di depan kaki maskot: menutup tepi bawah aset
          // sekaligus menyatu dengan latar konten di bawahnya.
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _cloudHeight,
            child: IgnorePointer(
              child: CustomPaint(painter: _CloudBankPainter()),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CloudPuff — satu gumpalan awan (rasio terhadap area awan)
// ─────────────────────────────────────────────────────────────────────────────

class _CloudPuff {
  const _CloudPuff({
    required this.centerX,
    required this.centerY,
    required this.radiusX,
    required this.radiusY,
  });

  final double centerX;
  final double centerY;
  final double radiusX;
  final double radiusY;

  Rect ovalFor(Size size) => Rect.fromCenter(
    center: Offset(centerX * size.width, centerY * size.height),
    width: radiusX * size.width * 2,
    height: radiusY * size.height * 2,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// _CloudBankPainter — tumpukan awan putih dengan tepi atas menggembung
// ─────────────────────────────────────────────────────────────────────────────

class _CloudBankPainter extends CustomPainter {
  const _CloudBankPainter();

  static const List<_CloudPuff> _puffs = [
    _CloudPuff(centerX: 0.02, centerY: 0.86, radiusX: 0.12, radiusY: 0.52),
    _CloudPuff(centerX: 0.16, centerY: 0.70, radiusX: 0.14, radiusY: 0.62),
    _CloudPuff(centerX: 0.33, centerY: 0.92, radiusX: 0.11, radiusY: 0.45),
    _CloudPuff(centerX: 0.50, centerY: 0.62, radiusX: 0.16, radiusY: 0.72),
    _CloudPuff(centerX: 0.68, centerY: 0.90, radiusX: 0.12, radiusY: 0.48),
    _CloudPuff(centerX: 0.84, centerY: 0.68, radiusX: 0.14, radiusY: 0.62),
    _CloudPuff(centerX: 0.99, centerY: 0.88, radiusX: 0.12, radiusY: 0.52),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRect(
        Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.45),
      );
    for (final puff in _puffs) {
      path.addOval(puff.ovalFor(size));
    }

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF), Color(0x00FFFFFF)],
        stops: [0.0, 0.72, 1.0],
      ).createShader(Offset.zero & size);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
