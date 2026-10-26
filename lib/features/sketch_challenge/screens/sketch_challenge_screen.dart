import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/asset_paths.dart';
import '../models/sketch_challenge_models.dart';
import 'sketch_challenge_result_screen.dart';
import '../widgets/sketch_canvas_painter.dart';

class SketchChallengeScreen extends StatefulWidget {
  const SketchChallengeScreen({
    super.key,
    this.initialScore = 20,
  });

  final int initialScore;

  @override
  State<SketchChallengeScreen> createState() => _SketchChallengeScreenState();
}

class _SketchChallengeScreenState extends State<SketchChallengeScreen> {
  static const List<Color> _paletteColors = [
    Color(0xFF7C4DFF), // Purple
    Color(0xFFF472B6), // Pink
    Color(0xFFFACC15), // Yellow
    Color(0xFF34D399), // Mint Green
    Color(0xFF3B82F6), // Blue
  ];

  // List 5 prompt gambar putus-putus
  final List<SketchChallengePrompt> _prompts = const [
    SketchChallengePrompt(
      id: 'butterfly',
      title: 'Kupu-kupu',
      instruction: 'Ikuti garis putus - putus, gambar\nkupu-kupu!',
      stepText: '2/5',
    ),
    SketchChallengePrompt(
      id: 'apple',
      title: 'Apel Merah',
      instruction: 'Ikuti garis putus - putus, gambar\napel merah!',
      stepText: '1/5',
    ),
    SketchChallengePrompt(
      id: 'star',
      title: 'Bintang Kecil',
      instruction: 'Ikuti garis putus - putus, gambar\nbintang kecil!',
      stepText: '3/5',
    ),
    SketchChallengePrompt(
      id: 'flower',
      title: 'Bunga Indah',
      instruction: 'Ikuti garis putus - putus, gambar\nbunga indah!',
      stepText: '4/5',
    ),
    SketchChallengePrompt(
      id: 'house',
      title: 'Rumah Impian',
      instruction: 'Ikuti garis putus - putus, gambar\nrumah impian!',
      stepText: '5/5',
    ),
  ];

  final int _currentPromptIndex = 0;
  Color _selectedColor = _paletteColors[0];
  List<DrawnLine> _lines = [];
  DrawnLine? _activeLine;

  SketchChallengePrompt get _currentPrompt => _prompts[_currentPromptIndex];

  void _undo() {
    if (_lines.isNotEmpty) {
      setState(() {
        _lines.removeLast();
      });
    }
  }

  void _clearCanvas() {
    if (_lines.isNotEmpty) {
      setState(() {
        _lines.clear();
      });
    }
  }

  void _onFinish() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SketchChallengeResultScreen(
          prompt: _currentPrompt,
          lines: List<DrawnLine>.from(_lines),
          score: widget.initialScore,
          onNext: () => Navigator.of(context).pop(),
          onRetry: () {
            Navigator.of(context).pop();
            setState(() => _lines = []);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF5F6FE),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FE),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                _buildHeader(),
                const SizedBox(height: 12),
                _buildTitleAndStep(),
                const SizedBox(height: 12),
                Expanded(child: _buildDrawingCanvas()),
                const SizedBox(height: 12),
                _buildPalette(),
                const SizedBox(height: 12),
                _buildFinishButton(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            key: const Key('sketch_back_button'),
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF8B5CF6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Sketch\nChallenge',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3730A3),
              height: 1.15,
              letterSpacing: -0.4,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBE8),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFFDE8A5), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B4DFF).withValues(alpha: 0.08),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetPaths.star,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Skor',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3730A3),
                      height: 1.1,
                    ),
                  ),
                  Text(
                    '${widget.initialScore}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3730A3),
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _currentPrompt.instruction,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E1B4B),
            height: 1.25,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  value: 2 / 5,
                  minHeight: 10,
                  backgroundColor: Color(0xFFE5DEFF),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B4DFF)),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              _currentPrompt.stepText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1B4B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDrawingCanvas() {
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
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE6FD),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _currentPrompt.title,
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
                      _buildCanvasToolButton(
                        key: const Key('sketch_undo_button'),
                        icon: Icons.undo_rounded,
                        onTap: _undo,
                      ),
                      const SizedBox(width: 8),
                      _buildCanvasAssetButton(
                        key: const Key('sketch_clear_button'),
                        assetPath: 'assets/images/eraser.png',
                        onTap: _clearCanvas,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_currentPrompt.guideAssetPath != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        _currentPrompt.guideAssetPath!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const SizedBox(),
                      ),
                    ),
                  Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (event) {
                      setState(() {
                        _activeLine = DrawnLine(
                          points: [event.localPosition],
                          color: _selectedColor,
                          strokeWidth: 5.0,
                        );
                        _lines.add(_activeLine!);
                      });
                    },
                    onPointerMove: (event) {
                      if (_activeLine == null) return;
                      setState(() {
                        final updatedPoints = List<Offset>.from(_activeLine!.points)
                          ..add(event.localPosition);
                        _activeLine = DrawnLine(
                          points: updatedPoints,
                          color: _activeLine!.color,
                          strokeWidth: _activeLine!.strokeWidth,
                        );
                        _lines = List<DrawnLine>.from(_lines)
                          ..[_lines.length - 1] = _activeLine!;
                      });
                    },
                    onPointerUp: (_) => _activeLine = null,
                    onPointerCancel: (_) => _activeLine = null,
                    child: CustomPaint(
                      painter: SketchCanvasPainter(lines: _lines),
                      size: Size.infinite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanvasToolButton({
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
          child: Icon(
            icon,
            color: const Color(0xFF7C4DFF),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCanvasAssetButton({
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

  Widget _buildPalette() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _paletteColors.map((color) {
          final isSelected = _selectedColor == color;
          return GestureDetector(
            onTap: () => setState(() => _selectedColor = color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 44 : 36,
              height: isSelected ? 44 : 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.white, width: 3)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFinishButton() {
    return SizedBox(
      height: 52,
      child: FilledButton(
        key: const Key('sketch_finish_button'),
        onPressed: _onFinish,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF7C4DFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Selesai',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
