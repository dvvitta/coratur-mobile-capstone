/// Satu entri di papan peringkat.
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatarIndex,
    this.avatarAsset,
    this.isCurrentUser = false,
  });

  final int rank;
  final String name;
  final int score;

  /// Indeks avatar (0–N) yang dipetakan ke list avatar asset bawaan.
  final int avatarIndex;

  /// Path asset avatar opsional (misal avatar anak laki-laki / perempuan).
  final String? avatarAsset;

  /// True jika baris ini mewakili user yang sedang login.
  final bool isCurrentUser;

  /// Format skor dengan titik pemisah ribuan (contoh: 1250 -> '1.250').
  String get formattedScore {
    final str = score.toString();
    final buffer = StringBuffer();
    final len = str.length;
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
