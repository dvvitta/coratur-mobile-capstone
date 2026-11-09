import 'package:flutter/material.dart';

class HitungHewanAnswerButton extends StatefulWidget {
  const HitungHewanAnswerButton({
    super.key,
    required this.value,
    required this.scale,
    required this.isSelected,
    required this.isWrong,
    required this.onTap,
  });

  final int value;
  final double scale;
  final bool isSelected;
  final bool isWrong;
  final VoidCallback onTap;

  @override
  State<HitungHewanAnswerButton> createState() =>
      _HitungHewanAnswerButtonState();
}

class _HitungHewanAnswerButtonState extends State<HitungHewanAnswerButton> {
  bool _hovered = false;
  bool _pressed = false;

  static const _palette = <int, _CandyColors>{
    4: _CandyColors(
      faceTop: Color(0xFFFE6BA4),
      faceBottom: Color(0xFFFB4D86),
      edge: Color(0xFFD42862),
      selectionRing: Color(0xFFFFB4CA),
    ),
    5: _CandyColors(
      faceTop: Color(0xFF3FB6FB),
      faceBottom: Color(0xFF26A2F4),
      edge: Color(0xFF1B87D6),
      selectionRing: Color(0xFF8DDBFF),
    ),
    6: _CandyColors(
      faceTop: Color(0xFFFFE979),
      faceBottom: Color(0xFFFFDE3D),
      edge: Color(0xFFF2C900),
      selectionRing: Color(0xFFFFE03D),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final s = widget.scale;

    final width = 102 * s;
    final faceHeight = 93 * s;
    final edgeHeight = 9 * s;
    final radius = 26 * s;

    final colors = _palette[widget.value] ?? _palette[5]!;
    final highlighted =
        widget.isSelected || _hovered || _pressed || widget.isWrong;
    final pressed = _pressed && !widget.isWrong;

    final ringColor = widget.isWrong
        ? const Color(0xFFEF5350)
        : pressed
        ? Colors.white
        : widget.isSelected
        ? colors.selectionRing
        : const Color(0xFFE9DFFF);

    final lift = widget.isWrong
        ? 0.0
        : pressed
        ? -2 * s
        : highlighted
        ? 3 * s
        : 0.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, -lift, 0),
          width: width,
          height: faceHeight + edgeHeight,
          child: Stack(
            children: [
              Positioned(
                left: 3 * s,
                right: 3 * s,
                top: (pressed ? 8 : 12) * s,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.edge,
                    borderRadius: BorderRadius.circular(radius - 2 * s),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: pressed ? 4 * s : 0,
                height: faceHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colors.faceTop, colors.faceBottom],
                    ),
                    boxShadow: highlighted
                        ? [
                            BoxShadow(
                              color: ringColor.withValues(alpha: 0.42),
                              blurRadius: 12 * s,
                              spreadRadius: 1 * s,
                              offset: Offset(0, 3 * s),
                            ),
                          ]
                        : const [],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 14 * s,
                        top: 8 * s,
                        child: Transform.rotate(
                          angle: -0.28,
                          child: Container(
                            width: 22 * s,
                            height: 13 * s,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.42),
                              borderRadius: BorderRadius.circular(7 * s),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 2 * s),
                          child: MediaQuery.withClampedTextScaling(
                            maxScaleFactor: 1.1,
                            child: Text(
                              '${widget.value}',
                              style: TextStyle(
                                fontSize: 48 * s,
                                height: 1,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: const Color(0x33000000),
                                    blurRadius: 4 * s,
                                    offset: Offset(0, 2 * s),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (highlighted)
                Positioned(
                  key: Key('hitung_hewan_ring_${widget.value}'),
                  left: -4 * s,
                  right: -4 * s,
                  top: -4 * s,
                  height: faceHeight + 8 * s,
                  child: IgnorePointer(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius + 4 * s),
                        border: Border.all(color: ringColor, width: 4 * s),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CandyColors {
  const _CandyColors({
    required this.faceTop,
    required this.faceBottom,
    required this.edge,
    required this.selectionRing,
  });

  final Color faceTop;
  final Color faceBottom;
  final Color edge;
  final Color selectionRing;
}
