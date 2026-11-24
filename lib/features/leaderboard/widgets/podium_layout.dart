import 'dart:ui';

/// Spesifikasi geometris satu slot podium.
///
/// Semua nilai disimpan sebagai rasio terhadap ukuran aset podium
/// (1536 × 1024) sehingga tampilan tetap proporsional di semua lebar layar.
class PodiumSlotSpec {
  const PodiumSlotSpec({
    required this.rank,
    required this.center,
    required this.avatarDiameter,
    required this.frameDiameter,
    required this.labelCenterX,
    required this.labelTop,
    required this.isChampion,
  });

  /// Peringkat yang menempati slot ini (1, 2, atau 3).
  final int rank;

  /// Titik pusat lubang ring, relatif terhadap lebar & tinggi podium.
  final Offset center;

  /// Diameter avatar relatif terhadap lebar podium.
  final double avatarDiameter;

  /// Diameter garis bingkai putih relatif terhadap lebar podium.
  final double frameDiameter;

  /// Titik tengah label relatif terhadap lebar podium.
  final double labelCenterX;

  /// Jarak atas label relatif terhadap tinggi podium.
  final double labelTop;

  /// Peringkat 1 memakai tipografi yang lebih besar.
  final bool isChampion;

  /// Mengubah spesifikasi relatif menjadi geometri piksel untuk [podiumSize].
  PodiumSlotGeometry resolve(Size podiumSize) {
    return PodiumSlotGeometry(
      center: Offset(
        center.dx * podiumSize.width,
        center.dy * podiumSize.height,
      ),
      avatarDiameter: avatarDiameter * podiumSize.width,
      frameDiameter: frameDiameter * podiumSize.width,
      labelCenterX: labelCenterX * podiumSize.width,
      labelTop: labelTop * podiumSize.height,
      isChampion: isChampion,
    );
  }
}

/// Geometri satu slot yang sudah dikonversi ke piksel.
class PodiumSlotGeometry {
  const PodiumSlotGeometry({
    required this.center,
    required this.avatarDiameter,
    required this.frameDiameter,
    required this.labelCenterX,
    required this.labelTop,
    required this.isChampion,
  });

  final Offset center;
  final double avatarDiameter;
  final double frameDiameter;
  final double labelCenterX;
  final double labelTop;
  final bool isChampion;

  Rect get avatarRect => Rect.fromCenter(
    center: center,
    width: avatarDiameter,
    height: avatarDiameter,
  );

  Rect get frameRect => Rect.fromCenter(
    center: center,
    width: frameDiameter,
    height: frameDiameter,
  );
}

/// Tata letak podium tiga besar, diturunkan dari aset `podium lead.png`.
///
/// Aset berukuran 1536 × 1024 dengan tiga lubang ring transparan. Koordinat
/// di bawah diukur langsung dari pusat tiap lubang agar avatar pas di dalam
/// ring dan tepinya tertutup bibir ring logam.
class PodiumLayout {
  const PodiumLayout({
    required this.designSize,
    required this.slots,
    required this.labelWidthFactor,
  });

  /// Ukuran asli aset podium.
  final Size designSize;

  /// Daftar slot, berurutan peringkat 1 → 3.
  final List<PodiumSlotSpec> slots;

  /// Lebar area label relatif terhadap lebar podium.
  final double labelWidthFactor;

  /// Rasio lebar : tinggi aset podium.
  double get aspectRatio => designSize.width / designSize.height;

  /// Tinggi podium untuk lebar tertentu.
  double heightForWidth(double width) => width / aspectRatio;

  static const champion = PodiumSlotSpec(
    rank: 1,
    center: Offset(0.5001, 0.3580),
    avatarDiameter: 0.2604,
    frameDiameter: 0.2200,
    labelCenterX: 0.4997,
    labelTop: 0.586,
    isChampion: true,
  );

  static const runnerUp = PodiumSlotSpec(
    rank: 2,
    center: Offset(0.1985, 0.5662),
    avatarDiameter: 0.2246,
    frameDiameter: 0.1823,
    labelCenterX: 0.1855,
    labelTop: 0.748,
    isChampion: false,
  );

  static const thirdPlace = PodiumSlotSpec(
    rank: 3,
    center: Offset(0.8052, 0.5834),
    avatarDiameter: 0.2181,
    frameDiameter: 0.1777,
    labelCenterX: 0.8154,
    labelTop: 0.754,
    isChampion: false,
  );

  /// Layout standar leaderboard SKETCHOO.
  static const standard = PodiumLayout(
    designSize: Size(1536, 1024),
    slots: [champion, runnerUp, thirdPlace],
    labelWidthFactor: 0.28,
  );
}
