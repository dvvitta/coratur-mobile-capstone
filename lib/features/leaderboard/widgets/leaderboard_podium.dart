import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../models/leaderboard_entry.dart';
import 'leaderboard_circle_avatar.dart';
import 'podium_layout.dart';

/// Podium tiga besar dengan grafis 3D (AssetPaths.podiumLead).
///
/// Avatar diletakkan *di belakang* aset podium sehingga ring logam pada
/// aset otomatis menjadi bingkai foto profil — persis seperti referensi
/// desain. Posisi tiap avatar memakai [PodiumLayout] yang koordinatnya
/// diukur dari lubang ring pada aset. Label peringkat, nama, dan skor
/// ditempatkan di muka blok podium.
class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({
    super.key,
    required this.entries,
    this.layout = PodiumLayout.standard,
  });

  final List<LeaderboardEntry> entries;
  final PodiumLayout layout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final podiumWidth = constraints.maxWidth;
          final podiumSize = Size(
            podiumWidth,
            layout.heightForWidth(podiumWidth),
          );
          final slots = _resolveSlots(podiumSize, podiumWidth);

          return SizedBox.fromSize(
            size: podiumSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ── Foto profil di belakang ring ────────────────────────────
                // Digambar lebih dulu supaya bibir ring pada aset podium
                // menutupi tepi avatar dan membentuk bingkai yang rapi.
                for (final slot in slots) _PodiumAvatar(slot: slot),

                // ── Dasar Podium 3D (menutupi tepi avatar) ──────────────────
                Positioned.fill(
                  child: Image.asset(AssetPaths.podiumLead, fit: BoxFit.fill),
                ),

                // ── Garis putih tipis sebagai bingkai dalam ring ────────────
                for (final slot in slots) _PodiumRingFrame(slot: slot),

                // ── Label di Blok Podium (Peringkat, Nama, Skor ⭐) ─────────
                for (final slot in slots)
                  _PodiumLabel(
                    slot: slot,
                    podiumWidth: podiumWidth,
                    labelWidthFactor: layout.labelWidthFactor,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<_PodiumSlot> _resolveSlots(Size podiumSize, double podiumWidth) {
    return layout.slots.map((spec) {
      final entry = entries.firstWhere((item) => item.rank == spec.rank);
      return _PodiumSlot(
        geometry: spec.resolve(podiumSize),
        entry: entry,
        labelWidth: layout.labelWidthFactor * podiumWidth,
      );
    }).toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PodiumSlot — pasangan geometri slot + data peserta
// ─────────────────────────────────────────────────────────────────────────────

class _PodiumSlot {
  const _PodiumSlot({
    required this.geometry,
    required this.entry,
    required this.labelWidth,
  });

  final PodiumSlotGeometry geometry;
  final LeaderboardEntry entry;
  final double labelWidth;

  String get avatarPath =>
      entry.avatarAsset ?? LeaderboardAvatarAssets.forIndex(entry.avatarIndex);
}

// ─────────────────────────────────────────────────────────────────────────────
// _PodiumAvatar — foto profil di dalam lubang ring
// ─────────────────────────────────────────────────────────────────────────────

class _PodiumAvatar extends StatelessWidget {
  const _PodiumAvatar({required this.slot});

  final _PodiumSlot slot;

  @override
  Widget build(BuildContext context) {
    final rect = slot.geometry.avatarRect;
    return Positioned.fromRect(
      rect: rect,
      child: LeaderboardCircleAvatar(
        asset: slot.avatarPath,
        diameter: rect.width,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PodiumRingFrame — garis putih tipis di tepi dalam ring
// ─────────────────────────────────────────────────────────────────────────────

class _PodiumRingFrame extends StatelessWidget {
  const _PodiumRingFrame({required this.slot});

  final _PodiumSlot slot;

  @override
  Widget build(BuildContext context) {
    final rect = slot.geometry.frameRect;
    return Positioned.fromRect(
      rect: rect,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: rect.width * 0.027,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PodiumLabel — teks di blok podium: rank, nama, skor ⭐
// ─────────────────────────────────────────────────────────────────────────────

class _PodiumLabel extends StatelessWidget {
  const _PodiumLabel({
    required this.slot,
    required this.podiumWidth,
    required this.labelWidthFactor,
  });

  final _PodiumSlot slot;
  final double podiumWidth;
  final double labelWidthFactor;

  @override
  Widget build(BuildContext context) {
    final geometry = slot.geometry;
    return Positioned(
      left: geometry.labelCenterX - slot.labelWidth / 2,
      top: geometry.labelTop,
      width: slot.labelWidth,
      child: _EntryLabel(
        entry: slot.entry,
        isChampion: geometry.isChampion,
        scale: podiumWidth,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _EntryLabel — isi blok podium
// ─────────────────────────────────────────────────────────────────────────────

class _EntryLabel extends StatelessWidget {
  const _EntryLabel({
    required this.entry,
    required this.isChampion,
    required this.scale,
  });

  final LeaderboardEntry entry;
  final bool isChampion;

  /// Lebar podium, dipakai agar ukuran teks ikut menyesuaikan layar.
  final double scale;

  @override
  Widget build(BuildContext context) {
    final rankSize = scale * (isChampion ? 0.075 : 0.052);
    final nameSize = scale * (isChampion ? 0.037 : 0.0335);
    final scoreSize = scale * (isChampion ? 0.033 : 0.030);
    final starSize = scale * (isChampion ? 0.034 : 0.031);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nomor Peringkat
        Text(
          '${entry.rank}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: rankSize,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E1547),
            height: 1.0,
          ),
        ),
        SizedBox(height: isChampion ? 1 : 0),
        // Nama Peserta
        Text(
          entry.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: nameSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E1547),
            height: 1.0,
          ),
        ),
        const SizedBox(height: 2),
        // Skor + Bintang di kanan
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry.formattedScore,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: scoreSize,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E1547),
                height: 1.0,
              ),
            ),
            SizedBox(width: scale * 0.008),
            Image.asset(AssetPaths.star, width: starSize, height: starSize),
          ],
        ),
      ],
    );
  }
}
