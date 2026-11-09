import 'package:flutter/material.dart';

class MissionsHeader extends StatelessWidget {
  const MissionsHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Misi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        TextButton(
          key: const Key('missions_back_button'),
          onPressed: onBack,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF5B34EA),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Kembali'),
              SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
