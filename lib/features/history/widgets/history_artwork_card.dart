import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../models/history_artwork_model.dart';

/// Card karya di grid 2 kolom halaman History.
///
/// Layout: thumbnail (height fixed) → info section (judul, badge, tanggal,
/// bintang, tombol Lanjutkan). Parent ClipRRect handle semua rounded corners
/// sehingga thumbnail tidak perlu radius sendiri.
class HistoryArtworkCard extends StatelessWidget {
  const HistoryArtworkCard({super.key, required this.artwork});

  final HistoryArtwork artwork;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('history_card_${artwork.id}'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x127C4DFF),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      // ClipRRect di parent agar sudut card terpotong rapi tanpa perlu
      // ClipRRect tambahan di dalam thumbnail.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ───────────────────────────────────────────────
            _Thumbnail(artwork: artwork),

            // ── Info section ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artwork.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1B4B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  _LevelBadge(label: artwork.levelLabel),
                  const SizedBox(height: 5),
                  _DateRow(label: artwork.dateLabel),
                  const SizedBox(height: 6),
                  _StarRow(
                    earned: artwork.earnedStars,
                    total: artwork.totalStars,
                  ),
                  if (artwork.status == ArtworkStatus.inProgress) ...[
                    const SizedBox(height: 8),
                    _ContinueButton(artworkId: artwork.id),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

/// Thumbnail dengan height fixed 110px, rounded di bagian atas sesuai card.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.artwork});
  final HistoryArtwork artwork;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SizedBox(
            height: 110,
            width: double.infinity,
            child: Image.asset(
              artwork.imageAssetPath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFFEDE9FF),
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    color: Color(0xFFB0A8D9),
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: _StatusBadge(status: artwork.status),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final ArtworkStatus status;

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == ArtworkStatus.completed;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFF00C888) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isCompleted ? Icons.check_rounded : Icons.timelapse_rounded,
        color: isCompleted ? Colors.white : const Color(0xFF7C4DFF),
        size: 17,
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEBFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFF5B21B6),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_today_rounded,
            size: 11, color: Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.earned, required this.total});
  final int earned;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        return Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Icon(
            Icons.star_rounded,
            size: 16,
            color: i < earned
                ? const Color(0xFFFFB800)
                : const Color(0xFFE2E0F5),
          ),
        );
      }),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.artworkId});
  final String artworkId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: const LinearGradient(
            colors: [Color(0xFF7C4DFF), Color(0xFF9C70FF)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x337C4DFF),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: Key('history_continue_$artworkId'),
            onTap: () => Navigator.of(context)
                .pushNamed(AppRoutes.sketchChallengeLevels),
            borderRadius: BorderRadius.circular(17),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lanjutkan',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
