import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../models/leaderboard_entry.dart';
import 'leaderboard_circle_avatar.dart';

/// Satu baris di daftar papan peringkat.
///
/// Untuk peringkat 4–10: angka peringkat polos tanpa badge bulat,
/// teks nama dan skor berwarna navy gelap, serta bintang di sebelah kanan skor.
///
/// Untuk baris pengguna saat ini (isCurrentUser): baris diberi latar ungu muda,
/// nomor peringkat di dalam pill gradient ungu, nama dan skor berwarna ungu tua.
class LeaderboardListItem extends StatelessWidget {
  const LeaderboardListItem({super.key, required this.entry});

  final LeaderboardEntry entry;

  /// Fallback avatar hewan jika [entry.avatarAsset] kosong.
  String get _avatarPath =>
      entry.avatarAsset ?? LeaderboardAvatarAssets.forIndex(entry.avatarIndex);

  @override
  Widget build(BuildContext context) {
    final isUser = entry.isCurrentUser;

    return Container(
      margin: EdgeInsets.symmetric(vertical: isUser ? 4 : 2),
      padding: EdgeInsets.symmetric(
        horizontal: isUser ? 10 : 4,
        vertical: isUser ? 8 : 10,
      ),
      decoration: isUser
          ? BoxDecoration(
              color: const Color(0xFFECE5FF),
              borderRadius: BorderRadius.circular(18),
            )
          : null,
      child: Row(
        children: [
          // ── Nomor Peringkat ──────────────────────────────────────────────
          if (isUser)
            _UserRankPill(rank: entry.rank)
          else
            SizedBox(
              width: 28,
              child: Text(
                '${entry.rank}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1547),
                ),
              ),
            ),
          const SizedBox(width: 10),

          // ── Avatar (reuse LeaderboardCircleAvatar dari podium) ─────────
          LeaderboardCircleAvatar(asset: _avatarPath, diameter: 38),
          const SizedBox(width: 12),

          // ── Nama ─────────────────────────────────────────────────────────
          Expanded(
            child: Text(
              entry.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isUser
                    ? const Color(0xFF673BEA)
                    : const Color(0xFF1E1547),
              ),
            ),
          ),

          // ── Skor + Ikon Bintang di Kanan ─────────────────────────────────
          Text(
            entry.formattedScore,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isUser ? const Color(0xFF673BEA) : const Color(0xFF1E1547),
            ),
          ),
          const SizedBox(width: 4),
          Image.asset(AssetPaths.star, width: 16, height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _UserRankPill — pill ungu untuk rank pengguna saat ini
// ─────────────────────────────────────────────────────────────────────────────

class _UserRankPill extends StatelessWidget {
  const _UserRankPill({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 38),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F52F7), Color(0xFF673BEA)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        '$rank',
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
