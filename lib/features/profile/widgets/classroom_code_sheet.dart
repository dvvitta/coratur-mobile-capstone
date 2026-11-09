import 'package:flutter/material.dart';

class ClassroomCodeSheet extends StatefulWidget {
  const ClassroomCodeSheet({super.key});

  @override
  State<ClassroomCodeSheet> createState() => _ClassroomCodeSheetState();
}

class _ClassroomCodeSheetState extends State<ClassroomCodeSheet> {
  static const int _codeLength = 6;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isComplete => _controller.text.trim().length == _codeLength;

  void _onJoin() {
    if (!_isComplete) return;
    final code = _controller.text.trim();
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final text = _controller.text;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDD6FE),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  key: const Key('classroom_close_button'),
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3EFFE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Color(0xFF2B1E70),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 34,
                color: Color(0xFFB45309),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Masukkan Kode Kelas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Minta kode dari gurumu ya!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF736A8C),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _focusNode.requestFocus(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0,
                  child: TextField(
                    key: const Key('classroom_code_input'),
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: _codeLength,
                    autofocus: true,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_codeLength, (index) {
                    final isFilled = index < text.length;
                    final isCurrent =
                        index == text.length && _focusNode.hasFocus;
                    final char = isFilled ? text[index] : '';

                    return _buildPinBox(
                      char: char,
                      isFilled: isFilled,
                      isCurrent: isCurrent,
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EFFE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 22,
                  color: Color(0xFF6C42F5),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Gurumu bisa melihat gambar dan bintangmu\nuntuk membantu belajarmu.',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4C3B78),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: FilledButton(
              key: const Key('classroom_join_button'),
              onPressed: _isComplete ? _onJoin : null,
              style: FilledButton.styleFrom(
                backgroundColor: _isComplete
                    ? const Color(0xFF6C42F5)
                    : const Color(0xFFDDD6FE),
                disabledBackgroundColor: const Color(0xFFDDD6FE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Gabung Kelas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _isComplete ? Colors.white : const Color(0xFF7C3AED),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinBox({
    required String char,
    required bool isFilled,
    required bool isCurrent,
  }) {
    return SizedBox(
      width: 48,
      height: 62,
      child: CustomPaint(
        painter: isFilled || isCurrent
            ? null
            : const DashedBorderPainter(
                color: Color(0xFFC4B5FD),
                borderRadius: 14,
                strokeWidth: 1.8,
                dashLength: 5,
                gapLength: 3.5,
              ),
        child: Container(
          decoration: BoxDecoration(
            color: isFilled ? const Color(0xFFECE7F9) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isCurrent
                ? Border.all(color: const Color(0xFF6C42F5), width: 2)
                : isFilled
                ? Border.all(color: const Color(0xFFD4CCE8), width: 1.2)
                : null,
          ),
          alignment: Alignment.center,
          child: isFilled
              ? Text(
                  char,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1B4B),
                  ),
                )
              : isCurrent
              ? Container(width: 2, height: 24, color: const Color(0xFF6C42F5))
              : null,
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  const DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = Path();

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashLength;
        dashedPath.addPath(
          metric.extractPath(distance, nextDistance.clamp(0.0, metric.length)),
          Offset.zero,
        );
        distance += dashLength + gapLength;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      borderRadius != oldDelegate.borderRadius ||
      strokeWidth != oldDelegate.strokeWidth ||
      dashLength != oldDelegate.dashLength ||
      gapLength != oldDelegate.gapLength;
}
