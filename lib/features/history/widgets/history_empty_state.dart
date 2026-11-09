import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

/// Tampilan kosong ketika tidak ada karya di filter yang aktif.
///
/// [onStartDrawing] hanya ditampilkan ketika seluruh koleksi kosong
/// (bukan hanya filter aktif). [isEmbedded] menentukan padding bawah.
class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({
    super.key,
    this.onStartDrawing,
    this.isEmbedded = false,
  });

  final VoidCallback? onStartDrawing;
  final bool isEmbedded;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(24, 0, 24, isEmbedded ? 110 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ilustrasi krayon
            SizedBox(
              width: 220,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 180,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB5A9F9),
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(180, 32),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 10,
                    child: Image.asset(
                      AssetPaths.historyCrayon,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum ada karya, nih!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yuk, mulai buat karya\npertamamu!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7C719C),
                height: 1.4,
              ),
            ),

            // Tombol hanya muncul jika koleksi benar-benar kosong
            if (onStartDrawing != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  key: const Key('history_start_drawing_button'),
                  onPressed: onStartDrawing,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF7546F8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Mulai Menggambar',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
