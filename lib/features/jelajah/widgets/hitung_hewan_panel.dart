import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'hitung_hewan_answer_button.dart';
import 'hitung_hewan_layout.dart';

class HitungHewanPanel extends StatelessWidget {
  const HitungHewanPanel({
    super.key,
    required this.layout,
    required this.options,
    required this.selected,
    required this.wrongValue,
    required this.shakeController,
    required this.onSelect,
  });

  final HitungHewanDesignLayout layout;
  final List<int> options;
  final int? selected;
  final int? wrongValue;
  final AnimationController shakeController;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final panelScale = math.max(
      0.0,
      math.min(layout.scale, (layout.size.width - 8) / 391),
    );
    final panelWidth = 391 * panelScale;
    final panelHeight = 201 * panelScale;
    final top = layout.topOf(617);

    return Positioned(
      left: layout.centerX - panelWidth / 2,
      top: top,
      width: panelWidth,
      height: panelHeight,
      child: AnimatedBuilder(
        animation: shakeController,
        builder: (context, child) {
          final progress = shakeController.value;
          final offset = math.sin(progress * math.pi * 6) * (1 - progress) * 7;
          return Transform.translate(offset: Offset(offset, 0), child: child);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F2E7),
                  borderRadius: BorderRadius.circular(panelHeight / 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F2B5B14),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: HitungHewanDashedBorderPainter(
                  color: const Color(0xFFFDE4B6),
                  strokeWidth: 4 * panelScale,
                  radius: panelHeight / 2,
                  dashLength: 8 * panelScale,
                  gapLength: 11 * panelScale,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 52 * panelScale),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < options.length; i++) ...[
                        if (i > 0) SizedBox(width: 23 * panelScale),
                        HitungHewanAnswerButton(
                          key: Key('hitung_hewan_answer_${options[i]}'),
                          value: options[i],
                          scale: panelScale,
                          isSelected: selected == options[i],
                          isWrong: wrongValue == options[i],
                          onTap: () => onSelect(options[i]),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
