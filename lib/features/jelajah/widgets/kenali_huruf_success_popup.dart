import 'package:flutter/material.dart';

class KenaliHurufSuccessPopup extends StatelessWidget {
  const KenaliHurufSuccessPopup({
    super.key,
    required this.scale,
    required this.onContinue,
  });

  final double scale;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0x88000000),
    child: Center(
      child: Container(
        margin: EdgeInsets.all(28 * scale),
        padding: EdgeInsets.all(22 * scale),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F2E7),
          borderRadius: BorderRadius.circular(30 * scale),
          border: Border.all(color: const Color(0xFFB8EFA8), width: 4 * scale),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76 * scale,
              height: 76 * scale,
              decoration: const BoxDecoration(
                color: Color(0xFF73D85C),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 52 * scale,
              ),
            ),
            SizedBox(height: 12 * scale),
            Text(
              'Jawaban Benar!',
              style: TextStyle(
                color: const Color(0xFF3B9E2F),
                fontSize: 25 * scale,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5 * scale),
            Text(
              'Hebat! Kamu berhasil mengenali huruf.',
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
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF73D85C),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18 * scale),
                  ),
                ),
                child: const Text('Lanjut'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
