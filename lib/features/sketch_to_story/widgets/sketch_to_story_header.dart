import 'package:flutter/material.dart';

/// AppBar-style header: back-button kiri, title di tengah.
///
/// [title] opsional — default "Sketch to Story".
/// Title diposisikan tepat di tengah Stack agar tidak terpengaruh
/// lebar back-button.
class SketchToStoryHeader extends StatelessWidget {
  const SketchToStoryHeader({
    super.key,
    required this.onBack,
    this.title = 'Sketch to Story',
  });

  final VoidCallback onBack;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Title tepat di tengah layar
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),

          // Back button pinned kiri, constraints ketat agar tidak melebar
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
