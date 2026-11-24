import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

/// Widget avatar bulat untuk leaderboard (podium maupun daftar peringkat).
///
/// Menerima path asset lokal. Jika asset gagal dimuat, widget menampilkan
/// placeholder ikon wajah agar baris tetap rapi.
class LeaderboardCircleAvatar extends StatelessWidget {
  const LeaderboardCircleAvatar({
    super.key,
    required this.asset,
    required this.diameter,
  });

  final String asset;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Image.asset(
          asset,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: diameter,
            height: diameter,
            decoration: const BoxDecoration(
              color: Color(0xFFEDE9FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.face_rounded,
              size: diameter * 0.5,
              color: const Color(0xFF7C4DFF),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kumpulan avatar hewan bawaan aplikasi.
///
/// Bertanggung jawab memetakan indeks avatar dari backend ke path asset,
/// sekaligus menyediakan fallback yang aman saat indeks di luar rentang.
abstract final class LeaderboardAvatarAssets {
  static const List<String> _assets = [
    AssetPaths.avatarKucing,
    AssetPaths.avatarPanda,
    AssetPaths.avatarDinosaurus,
    AssetPaths.avatarBebek,
    AssetPaths.avatarPinguin,
    AssetPaths.avatarHamster,
    AssetPaths.avatarBeruang,
    AssetPaths.avatarRubah,
  ];

  static String forIndex(int index) =>
      _assets[index.clamp(0, _assets.length - 1)];
}
