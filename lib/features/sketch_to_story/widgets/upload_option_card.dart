import 'package:flutter/material.dart';

import '../models/upload_option.dart';

/// Card opsi upload: icon circle ungu di kiri, teks di kanan.
class UploadOptionCard extends StatelessWidget {
  const UploadOptionCard({
    super.key,
    required this.option,
    required this.onTap,
  });

  final UploadOption option;
  final VoidCallback? onTap;

  static const _purple = Color(0xFF7C4DFF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        key: Key('upload_option_${option.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8E4FF), width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F7C4DFF),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
            color: Colors.white,
          ),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: _purple,
                  shape: BoxShape.circle,
                ),
                child: Icon(option.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),

              // Teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.description,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A7A9A),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
