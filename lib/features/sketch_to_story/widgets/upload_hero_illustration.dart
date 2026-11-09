import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

/// Ilustrasi hero halaman Unggah Gambar.
///
/// Menggunakan [AssetPaths.image21] — gambar gajah pegang kamera
/// dengan speech bubble "Pilih cara untuk mengunggah gambar karya anak"
/// yang sudah menjadi satu kesatuan dalam asset.
class UploadHeroIllustration extends StatelessWidget {
  const UploadHeroIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        AssetPaths.image21,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}
