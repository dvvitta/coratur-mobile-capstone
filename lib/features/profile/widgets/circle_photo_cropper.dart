import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Preview crop bulat dengan dukungan zoom & geser.
///
/// Hasil crop diambil dari [capture] sehingga UI cukup memanggil satu method
/// setelah pengguna menekan "Simpan Foto".
class CirclePhotoCropper extends StatefulWidget {
  const CirclePhotoCropper({
    super.key,
    required this.imageBytes,
    this.size = 264,
  });

  final Uint8List imageBytes;
  final double size;

  @override
  State<CirclePhotoCropper> createState() => CirclePhotoCropperState();
}

class CirclePhotoCropperState extends State<CirclePhotoCropper> {
  final GlobalKey _captureKey = GlobalKey();
  final TransformationController _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Mengambil hasil crop sesuai posisi & zoom terakhir.
  Future<Uint8List?> capture({double pixelRatio = 3}) async {
    final object = _captureKey.currentContext?.findRenderObject();
    if (object is! RenderRepaintBoundary) return null;
    final image = await object.toImage(pixelRatio: pixelRatio);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data?.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E6D3FE0),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipOval(
        child: RepaintBoundary(
          key: _captureKey,
          child: InteractiveViewer(
            transformationController: _controller,
            minScale: 1,
            maxScale: 4,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Image.memory(
                widget.imageBytes,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
