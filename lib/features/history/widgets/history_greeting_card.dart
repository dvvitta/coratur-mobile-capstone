import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

/// Achievement summary card di bagian atas halaman History.
///
/// Menampilkan sapaan, subtitle, total bintang & total karya dari data real.
/// Maskot krayon diletakkan di kanan card agar tidak menutupi teks.
class HistoryGreetingCard extends StatelessWidget {
  const HistoryGreetingCard({
    super.key,
    required this.userName,
    required this.hasArtworks,
    this.totalStars = 0,
    this.totalArtworks = 0,
  });

  final String userName;
  final bool hasArtworks;
  final int totalStars;
  final int totalArtworks;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A7C4DFF),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Teks & badge kiri ───────────────────────────────────────────
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 140, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hebat, $userName!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Yuk terus kembangkan kreativitasmu!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7C719C),
                    ),
                  ),
                  const Spacer(),
                  if (hasArtworks)
                    Row(
                      children: [
                        _StatBadge(
                          icon: AssetPaths.star,
                          label: '$totalStars Bintang',
                        ),
                        const SizedBox(width: 8),
                        _StatBadge(
                          iconWidget: const Icon(
                            Icons.palette_rounded,
                            size: 15,
                            color: Color(0xFF7C4DFF),
                          ),
                          label: '$totalArtworks Karya',
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // ── Maskot krayon (kanan, sedikit keluar batas atas) ────────────
          Positioned(
            right: -4,
            bottom: 0,
            child: Image.asset(
              AssetPaths.historyCrayonMascot,
              width: 130,
              height: 140,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge kecil putih untuk menampilkan stat (bintang / karya).
class _StatBadge extends StatelessWidget {
  const _StatBadge({
    this.icon,
    this.iconWidget,
    required this.label,
  }) : assert(icon != null || iconWidget != null);

  final String? icon;
  final Widget? iconWidget;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0D9FF), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconWidget != null)
            iconWidget!
          else
            Image.asset(icon!, width: 15, height: 15, fit: BoxFit.contain),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1B4B),
            ),
          ),
        ],
      ),
    );
  }
}
