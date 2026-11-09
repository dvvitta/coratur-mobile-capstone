import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/hitung_hewan_level.dart';
import '../widgets/hitung_hewan_layout.dart';
import '../widgets/hitung_hewan_panel.dart';
import '../widgets/hitung_hewan_result_popup.dart';

class HitungHewanScreen extends StatefulWidget {
  const HitungHewanScreen({
    super.key,
    this.level = const HitungHewanLevel(
      id: 'bebek',
      background: 'assets/hitung_hewan/bebek.png',
      correctAnswer: 5,
      options: [4, 5, 6],
    ),
    this.options,
    this.correctAnswer,
  });

  final HitungHewanLevel level;
  final List<int>? options;
  final int? correctAnswer;

  @override
  State<HitungHewanScreen> createState() => _HitungHewanScreenState();
}

class _HitungHewanScreenState extends State<HitungHewanScreen>
    with SingleTickerProviderStateMixin {
  int? _selected;
  int? _wrongValue;
  bool _showSuccess = false;
  bool _showResultPopup = false;
  bool _lastAnswerCorrect = false;
  late HitungHewanLevel _currentLevel;
  final AudioPlayer _backgroundPlayer = AudioPlayer();

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  Timer? _successTimer;
  Timer? _wrongTimer;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.level;
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundPlayer.setVolume(0.10);
      await _backgroundPlayer.play(AssetSource('backsound/sound_jelajah.mp3'));
    } catch (error) {
      debugPrint('[HitungHewan] background music error: $error');
    }
  }

  @override
  void dispose() {
    _successTimer?.cancel();
    _wrongTimer?.cancel();
    _backgroundPlayer.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  List<int> get _options => widget.options ?? _currentLevel.options;
  int get _correctAnswer => widget.correctAnswer ?? _currentLevel.correctAnswer;
  bool get _hasAnsweredCorrectly => _selected == _correctAnswer;

  void _onSelect(int value) {
    if (_hasAnsweredCorrectly) return;

    HapticFeedback.selectionClick();
    setState(() {
      _selected = value;
      _wrongValue = value == _correctAnswer ? null : value;
    });

    if (value == _correctAnswer) {
      HapticFeedback.mediumImpact();
      _successTimer?.cancel();
      _successTimer = Timer(const Duration(milliseconds: 2600), () {
        if (mounted) setState(() => _showSuccess = false);
      });
      setState(() {
        _showSuccess = true;
        _lastAnswerCorrect = true;
        _showResultPopup = true;
      });
    } else {
      _lastAnswerCorrect = false;
      _showResultPopup = true;
      _shakeController.forward(from: 0);
      _wrongTimer?.cancel();
      _wrongTimer = Timer(const Duration(milliseconds: 650), () {
        if (!mounted) return;
        setState(() {
          _selected = null;
          _wrongValue = null;
        });
      });
    }
  }

  void _goToNextLevel() {
    final index = hitungHewanLevels.indexWhere(
      (level) => level.id == _currentLevel.id,
    );
    final next = index >= 0 && index + 1 < hitungHewanLevels.length
        ? hitungHewanLevels[index + 1]
        : hitungHewanLevels.first;

    _successTimer?.cancel();
    _wrongTimer?.cancel();
    setState(() {
      _currentLevel = next;
      _selected = null;
      _wrongValue = null;
      _showSuccess = false;
      _showResultPopup = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF4FA82E),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
              return const SizedBox.shrink();
            }

            final layout = HitungHewanDesignLayout(
              Size(constraints.maxWidth, constraints.maxHeight),
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    _currentLevel.background,
                    key: const Key('hitung_hewan_background'),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                _buildBackButton(layout),
                _buildInstruction(layout),
                HitungHewanPanel(
                  layout: layout,
                  options: _options,
                  selected: _selected,
                  wrongValue: _wrongValue,
                  shakeController: _shakeController,
                  onSelect: _onSelect,
                ),
                HitungHewanSuccessBanner(
                  layout: layout,
                  showSuccess: _showSuccess,
                ),
                if (_showResultPopup)
                  HitungHewanResultPopup(
                    layout: layout,
                    isCorrect: _lastAnswerCorrect,
                    onAction: () {
                      setState(() {
                        _showResultPopup = false;
                        if (_lastAnswerCorrect) {
                          _goToNextLevel();
                        } else {
                          _selected = null;
                          _wrongValue = null;
                        }
                      });
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(HitungHewanDesignLayout layout) {
    final size = 46 * layout.scale;
    final position = layout.point(26, 109);

    return Positioned(
      left: position.dx,
      top: position.dy,
      width: size,
      height: size,
      child: Material(
        color: const Color(0xFF8F6AF7),
        shape: const CircleBorder(),
        elevation: 0,
        shadowColor: const Color(0x558F6AF7),
        child: InkWell(
          key: const Key('hitung_hewan_back_button'),
          customBorder: const CircleBorder(),
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x338F6AF7),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 25 * layout.scale,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(HitungHewanDesignLayout layout) {
    final position = layout.point(83, 109);

    return Positioned(
      left: position.dx,
      top: position.dy,
      width: 312 * layout.scale,
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.15,
        child: Text(
          'Yuk, hitung ada berapa\nbebek di gambar ini!',
          key: const Key('hitung_hewan_instruction'),
          style: TextStyle(
            fontSize: 20.5 * layout.scale,
            height: 1.26,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF4632AB),
            letterSpacing: -0.3 * layout.scale,
          ),
        ),
      ),
    );
  }
}
