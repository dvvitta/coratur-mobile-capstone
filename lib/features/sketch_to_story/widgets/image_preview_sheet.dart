import 'dart:io';

import 'package:flutter/material.dart';

/// Bottom sheet preview gambar yang sudah dipilih user.
///
/// Menampilkan thumbnail gambar, tombol "Gunakan Gambar Ini"
/// dan tombol "Pilih Ulang".
class ImagePreviewSheet extends StatelessWidget {
  const ImagePreviewSheet({
    super.key,
    required this.imageFile,
    required this.onConfirm,
    required this.onRetry,
  });

  final File imageFile;
  final VoidCallback onConfirm;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A7C4DFF),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDD5FF),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Label
          const Text(
            'Gambar Terpilih',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),

          // Preview thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              imageFile,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          // Tombol Gunakan
          _PrimaryButton(
            label: 'Gunakan Gambar Ini',
            icon: Icons.check_rounded,
            onTap: onConfirm,
          ),
          const SizedBox(height: 10),

          // Tombol Pilih Ulang
          _SecondaryButton(label: 'Pilih Ulang', onTap: onRetry),
        ],
      ),
    );
  }
}

// ── Buttons ───────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: [Color(0xFF7C4DFF), Color(0xFF9C70FF)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x447C4DFF),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDDD5FF), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7C4DFF),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
