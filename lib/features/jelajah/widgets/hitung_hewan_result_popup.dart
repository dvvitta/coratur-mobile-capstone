import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'hitung_hewan_layout.dart';

class HitungHewanResultPopup extends StatelessWidget {
  const HitungHewanResultPopup({
    super.key,
    required this.layout,
    required this.isCorrect,
    required this.onAction,
  });

  final HitungHewanDesignLayout layout;
  final bool isCorrect;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final scale = math.min(layout.size.width / 412, layout.size.height / 917);

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.42),
        child: Center(
          child: AnimatedScale(
            scale: 1,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutBack,
            child: Container(
              key: const Key('hitung_hewan_result_popup'),
              width: 350 * scale,
              padding: EdgeInsets.fromLTRB(
                20 * scale,
                22 * scale,
                20 * scale,
                18 * scale,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F2E7),
                borderRadius: BorderRadius.circular(30 * scale),
                border: Border.all(
                  color: isCorrect
                      ? const Color(0xFFB8EFA8)
                      : const Color(0xFFFFB4C7),
                  width: 4 * scale,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76 * scale,
                    height: 76 * scale,
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? const Color(0xFF73D85C)
                          : const Color(0xFFFF6B8A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCorrect ? Icons.check_rounded : Icons.close_rounded,
                      color: Colors.white,
                      size: 52 * scale,
                    ),
                  ),
                  SizedBox(height: 12 * scale),
                  Text(
                    isCorrect ? 'Jawaban Benar!' : 'Jawaban Salah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isCorrect
                          ? const Color(0xFF3B9E2F)
                          : const Color(0xFFD94A68),
                      fontSize: 25 * scale,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5 * scale),
                  Text(
                    isCorrect
                        ? 'Hebat! Kamu berhasil menghitungnya.'
                        : 'Yuk coba hitung lagi dengan teliti.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF665E83),
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16 * scale),
                  SizedBox(
                    width: double.infinity,
                    height: 46 * scale,
                    child: ElevatedButton(
                      key: const Key('hitung_hewan_result_popup_button'),
                      onPressed: onAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCorrect
                            ? const Color(0xFF73D85C)
                            : const Color(0xFFFF6B8A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18 * scale),
                        ),
                      ),
                      child: Text(
                        isCorrect ? 'Lanjut' : 'Coba Lagi',
                        style: TextStyle(
                          fontSize: 15 * scale,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HitungHewanSuccessBanner extends StatelessWidget {
  const HitungHewanSuccessBanner({
    super.key,
    required this.layout,
    required this.showSuccess,
  });

  final HitungHewanDesignLayout layout;
  final bool showSuccess;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: layout.topOf(617) - 58 * layout.scale,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: showSuccess ? 1 : 0,
          duration: const Duration(milliseconds: 220),
          child: Center(
            child: Container(
              key: const Key('hitung_hewan_success_banner'),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x260E3D1A),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'Hebat! Jawabanmu benar',
                    style: TextStyle(
                      fontSize: 13.5 * layout.scale,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF3B7A2A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
