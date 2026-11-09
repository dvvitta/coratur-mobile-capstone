import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/asset_paths.dart';
import '../../../core/errors/app_failure.dart';
import '../models/sketch_challenge_models.dart';
import '../repositories/sketch_challenge_complete_repository.dart';
import '../widgets/sketch_drawing_board.dart';
import '../widgets/sketch_header.dart';
import '../widgets/sketch_palette.dart';
import '../widgets/sketch_step_progress.dart';
import 'sketch_challenge_result_screen.dart';

class SketchChallengeScreen extends StatefulWidget {
  const SketchChallengeScreen({
    super.key,
    this.initialScore = 20,
    this.initialPromptId,
    this.completeRepository,
  });

  final int initialScore;
  final String? initialPromptId;
  final SketchChallengeCompleteRepository? completeRepository;

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

  final List<SketchChallengePrompt> _prompts = const [
    SketchChallengePrompt(
      id: 'bebek',
      title: 'Bebek',
      instruction: 'Ikuti garis putus - putus, gambar\nbebek lucu!',
      stepText: '1/5',
      guideAssetPath: AssetPaths.sketchGuideBebek,
    ),
    SketchChallengePrompt(
      id: 'kucing',
      title: 'Kucing',
      instruction: 'Ikuti garis putus - putus, gambar\nkucing lucu!',
      stepText: '2/5',
      guideAssetPath: AssetPaths.sketchGuideKucing,
    ),
    SketchChallengePrompt(
      id: 'ikan',
      title: 'Ikan',
      instruction: 'Ikuti garis putus - putus, gambar\nikan!',
      stepText: '3/5',
      guideAssetPath: AssetPaths.sketchGuideIkan,
    ),
    SketchChallengePrompt(
      id: 'kupu_kupu',
      title: 'Kupu-Kupu',
      instruction: 'Ikuti garis putus - putus, gambar\nkupu-kupu!',
      stepText: '4/5',
      guideAssetPath: AssetPaths.sketchGuideKupuKupu,
    ),
    SketchChallengePrompt(
      id: 'kura_kura',
      title: 'Kura-Kura',
      instruction: 'Ikuti garis putus - putus, gambar\nkura-kura!',
      stepText: '5/5',
      guideAssetPath: AssetPaths.sketchGuideKuraKura,
    ),
  ];

  late int _currentPromptIndex;
  Color _selectedColor = _paletteColors[0];
  List<DrawnLine> _lines = [];
  DrawnLine? _activeLine;
  bool _submitting = false;
  Size _canvasSize = Size.zero;
  late DateTime _startedAt;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    final targetId = widget.initialPromptId;
    final index = targetId != null
        ? _prompts.indexWhere((p) => p.id == targetId)
        : -1;
    _currentPromptIndex = index >= 0 ? index : 0;
  }

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

  void _onFinish() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final prompt = _currentPrompt;
    final lines = List<DrawnLine>.from(_lines);
    final strokeCount = lines.length;
    final totalPoints = lines.fold(0, (sum, l) => sum + l.points.length);
    final durationSeconds = DateTime.now().difference(_startedAt).inSeconds;

    SketchCompleteResult result;
    try {
      result =
          await (widget.completeRepository?.completeLevel(
                levelId: prompt.id,
                strokeCount: strokeCount,
                totalPoints: totalPoints,
                durationSeconds: durationSeconds,
              ) ??
              Future.value(
                const SketchCompleteResult(
                  starsEarned: 3,
                  scoreAdded: 20,
                  totalStars: 20,
                  feedbackMessage: 'Wah, hebat sekali! Kamu berhasil!',
                ),
              ));
    } on AppFailure catch (error) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    } catch (_) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hasil gambar belum tersimpan. Coba lagi.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    } finally {
      if (mounted) setState(() => _submitting = false);
    }

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SketchChallengeResultScreen(
          prompt: prompt,
          lines: lines,
          canvasSize: _canvasSize,
          scoreAdded: result.scoreAdded,
          starsEarned: result.starsEarned,
          feedbackMessage: result.feedbackMessage,
          onNext: () {
            Navigator.of(context).pop();
            setState(() {
              _currentPromptIndex = (_currentPromptIndex + 1) % _prompts.length;
              _lines = [];
              _startedAt = DateTime.now();
            });
          },
          onRetry: () {
            Navigator.of(context).pop();
            setState(() {
              _lines = [];
              _startedAt = DateTime.now();
            });
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
                SketchHeader(
                  score: widget.initialScore,
                  onBack: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 12),
                SketchStepProgress(
                  instruction: _currentPrompt.instruction,
                  stepText: _currentPrompt.stepText,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SketchDrawingBoard(
                    title: _currentPrompt.title,
                    guideAssetPath: _currentPrompt.guideAssetPath,
                    lines: _lines,
                    onSizeChanged: (size) => _canvasSize = size,
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
                        final updatedPoints = List<Offset>.from(
                          _activeLine!.points,
                        )..add(event.localPosition);
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
                    onUndo: _undo,
                    onClear: _clearCanvas,
                  ),
                ),
                const SizedBox(height: 12),
                SketchPalette(
                  colors: _paletteColors,
                  selectedColor: _selectedColor,
                  onColorSelected: (color) => setState(() => _selectedColor = color),
                ),
                const SizedBox(height: 12),
                SizedBox(
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
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
