class HitungHewanLevel {
  const HitungHewanLevel({
    required this.id,
    required this.background,
    required this.correctAnswer,
    required this.options,
  });

  final String id;
  final String background;
  final int correctAnswer;
  final List<int> options;
}

/// Soal statis FE. Popup hasil menyusul setelah desain final tersedia.
const hitungHewanLevels = [
  HitungHewanLevel(
    id: 'bebek',
    background: 'assets/hitung_hewan/bebek.png',
    correctAnswer: 5,
    options: [4, 5, 6],
  ),
  HitungHewanLevel(
    id: 'kucing',
    background: 'assets/hitung_hewan/Kucing.png',
    correctAnswer: 4,
    options: [3, 4, 5],
  ),
  HitungHewanLevel(
    id: 'ikan',
    background: 'assets/hitung_hewan/ikan.png',
    correctAnswer: 6,
    options: [5, 6, 7],
  ),
  HitungHewanLevel(
    id: 'kelinci',
    background: 'assets/hitung_hewan/kelinci.png',
    correctAnswer: 3,
    options: [2, 3, 4],
  ),
];
