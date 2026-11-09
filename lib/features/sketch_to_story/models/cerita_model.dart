import 'dart:io';

/// Data model untuk satu cerita hasil Sketch to Story.
///
/// Berisi judul, paragraf isi cerita, pesan moral, dan referensi gambar asli.
class CeritaModel {
  const CeritaModel({
    required this.judul,
    required this.paragraf,
    required this.pesanMoral,
    required this.imageFile,
  });

  final String judul;

  /// Isi cerita dipecah per-paragraf.
  final List<String> paragraf;

  final String pesanMoral;

  /// Gambar yang diunggah user (ditampilkan sebagai hero di atas).
  final File imageFile;

  /// Placeholder / mock data untuk preview & development.
  static CeritaModel mock({File? imageFile}) => CeritaModel(
        judul: 'Mobil Merah yang Baik Hati',
        paragraf: const [
          'Di sebuah desa kecil, ada sebuah mobil merah yang selalu membantu '
              'teman-temannya. Suatu hari, mobil merah melihat seekor kelinci '
              'kesulitan membawa barang yang berat.',
          'Mobil merah pun berhenti dan membantunya membawa. Mereka bekerja '
              'sama hingga barang itu sampai ke tempat tujuan. Sejak saat itu, '
              'semua hewan di desa selalu mengingat kebaikan mobil merah.',
        ],
        pesanMoral: 'Berbuat baik selalu membawa hal yang lebih baik.',
        imageFile: imageFile ?? File(''),
      );
}
