import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/sketch_challenge_models.dart';
import 'sketch_canvas_painter.dart';

class SketchDrawingBoard extends StatelessWidget {
  const SketchDrawingBoard({
    super.key,
    required this.title,
    this.guideAssetPath,
    required this.lines,
    required this.onPointerDown,
    required this.onPointerMove,
    required this.onPointerUp,
    required this.onPointerCancel,
    required this.onUndo,
    required this.onClear,
    this.onSizeChanged,
  });

  final String title;
  final String? guideAssetPath;
  final List<DrawnLine> lines;
  final ValueChanged<PointerDownEvent> onPointerDown;
  final ValueChanged<PointerMoveEvent> onPointerMove;
  final ValueChanged<PointerUpEvent> onPointerUp;
  final ValueChanged<PointerCancelEvent> onPointerCancel;
  final VoidCallback onUndo;
  final VoidCallback onClear;
  final ValueChanged<Size>? onSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4DFF).withValues(alpha: 0.06),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE6FD),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2B1E70),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToolButton(
                        key: const Key('sketch_undo_button'),
                        icon: Icons.undo_rounded,
                        onTap: onUndo,
                      ),
                      const SizedBox(width: 8),
                      _buildAssetButton(
                        key: const Key('sketch_clear_button'),
                        assetPath: 'assets/images/eraser.png',
                        onTap: onClear,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  onSizeChanged?.call(
                    Size(constraints.maxWidth, constraints.maxHeight),
                  );
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if (guideAssetPath != null)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _buildGuideWidget(guideAssetPath!),
                        ),
                      Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerDown: onPointerDown,
                        onPointerMove: onPointerMove,
                        onPointerUp: onPointerUp,
                        onPointerCancel: onPointerCancel,
                        child: CustomPaint(
                          painter: SketchCanvasPainter(lines: lines),
                          size: Size.infinite,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideWidget(String path) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(path, fit: BoxFit.contain);
    }
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const SizedBox(),
    );
  }

  Widget _buildToolButton({
    required Key key,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        key: key,
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF7C4DFF), size: 20),
        ),
      ),
    );
  }

  Widget _buildAssetButton({
    required Key key,
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        key: key,
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3FF),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(7),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
