import 'package:flutter/material.dart';

/// Card tips di bagian bawah halaman Unggah Gambar.
class UploadTipsCard extends StatelessWidget {
  const UploadTipsCard({super.key});

  static const _tips = [
    'Gunakan gambar yang jelas dan terang',
    'Pastikan objek dalam kotak',
    'Format yang didukung: JPG, PNG',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDD5FF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Tips
          const Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: Color(0xFF7C4DFF), size: 20),
              SizedBox(width: 8),
              Text(
                'Tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Daftar tips
          ..._tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A7A9A),
                      height: 1.5,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A7A9A),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
