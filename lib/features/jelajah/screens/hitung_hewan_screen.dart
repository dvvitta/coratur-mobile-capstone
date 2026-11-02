import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/hitung_hewan_level.dart';

/// Halaman mini-game "Hitung Hewan".
///
/// Seluruh geometri diambil langsung dari referensi desain
/// `assets/illustrations/hitung bebekk.png` (kanvas 412 x 917):
/// panel krem `y 617..817`, tiga tombol 102 x 102 di `y 669`, dan
/// ring kuning sebagai penanda tombol yang sedang disorot.
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

  /// Override opsional untuk widget test/preview.
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

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  Timer? _successTimer;
  Timer? _wrongTimer;

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

            final layout = _DesignLayout(
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
                _buildPanel(layout),
                _buildSuccessBanner(layout),
                if (_showResultPopup) _buildResultPopup(layout),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(_DesignLayout layout) {
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

  Widget _buildInstruction(_DesignLayout layout) {
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

  Widget _buildPanel(_DesignLayout layout) {
    // Skala panel dibatasi agar tetap masuk layar pada rasio yang ekstrem.
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
        animation: _shakeController,
        builder: (context, child) {
          final progress = _shakeController.value;
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
                painter: _DashedBorderPainter(
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
                      for (var i = 0; i < _options.length; i++) ...[
                        if (i > 0) SizedBox(width: 23 * panelScale),
                        _AnswerButton(
                          key: Key('hitung_hewan_answer_${_options[i]}'),
                          value: _options[i],
                          scale: panelScale,
                          isSelected: _selected == _options[i],
                          isWrong: _wrongValue == _options[i],
                          onTap: () => _onSelect(_options[i]),
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

  Widget _buildResultPopup(_DesignLayout layout) {
    final scale = math.min(layout.size.width / 412, layout.size.height / 917);
    final isCorrect = _lastAnswerCorrect;

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.42),
        child: Center(
          child: AnimatedScale(
            scale: 1,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutBack,
            child: Container(
              key: const Key('hitung_hewan_result_popup'),
              width: 350 * scale,
              padding: EdgeInsets.fromLTRB(
                20 * scale,
                22 * scale,
                20 * scale,
                18 * scale,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F2E7),
                borderRadius: BorderRadius.circular(30 * scale),
                border: Border.all(
                  color: isCorrect
                      ? const Color(0xFFB8EFA8)
                      : const Color(0xFFFFB4C7),
                  width: 4 * scale,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76 * scale,
                    height: 76 * scale,
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? const Color(0xFF73D85C)
                          : const Color(0xFFFF6B8A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCorrect ? Icons.check_rounded : Icons.close_rounded,
                      color: Colors.white,
                      size: 52 * scale,
                    ),
                  ),
                  SizedBox(height: 12 * scale),
                  Text(
                    isCorrect ? 'Jawaban Benar!' : 'Jawaban Salah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isCorrect
                          ? const Color(0xFF3B9E2F)
                          : const Color(0xFFD94A68),
                      fontSize: 25 * scale,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5 * scale),
                  Text(
                    isCorrect
                        ? 'Hebat! Kamu berhasil menghitungnya.'
                        : 'Yuk coba hitung lagi dengan teliti.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF665E83),
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16 * scale),
                  SizedBox(
                    width: double.infinity,
                    height: 46 * scale,
                    child: ElevatedButton(
                      key: const Key('hitung_hewan_result_popup_button'),
                      onPressed: () {
                        setState(() {
                          _showResultPopup = false;
                          if (isCorrect) {
                            _goToNextLevel();
                          } else {
                            _showResultPopup = false;
                            _selected = null;
                            _wrongValue = null;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCorrect
                            ? const Color(0xFF73D85C)
                            : const Color(0xFFFF6B8A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18 * scale),
                        ),
                      ),
                      child: Text(
                        isCorrect ? 'Lanjut' : 'Coba Lagi',
                        style: TextStyle(
                          fontSize: 15 * scale,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessBanner(_DesignLayout layout) {
    return Positioned(
      left: 0,
      right: 0,
      top: layout.topOf(617) - 58 * layout.scale,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _showSuccess ? 1 : 0,
          duration: const Duration(milliseconds: 220),
          child: Center(
            child: Container(
              key: const Key('hitung_hewan_success_banner'),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x260E3D1A),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'Hebat! Jawabanmu benar',
                    style: TextStyle(
                      fontSize: 13.5 * layout.scale,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF3B7A2A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pemetaan koordinat desain 412 x 917 ke layar, mengikuti penskalaan
/// `BoxFit.cover` dari latar `bebek.png` (841 x 1871) agar panel dan
/// tombol selalu menempel tepat di atas area rerumputan.
class _DesignLayout {
  _DesignLayout(this.size) {
    final coverScale = math.max(size.width / 841, size.height / 1871);
    final backgroundWidth = 841 * coverScale;
    final backgroundHeight = 1871 * coverScale;

    _dx = (size.width - backgroundWidth) / 2;
    _dy = (size.height - backgroundHeight) / 2;
    // 1 piksel desain = 841 / 412 piksel gambar, lalu diskalakan ke layar.
    scale = coverScale * (841 / 412);
  }

  final Size size;

  late final double _dx;
  late final double _dy;
  late final double scale;

  double get centerX => size.width / 2;

  Offset point(double x, double y) => Offset(_dx + x * scale, _dy + y * scale);

  double topOf(double y) => _dy + y * scale;
}

/// Tombol angka bergaya permen 3D: badan berwarna cerah, alas lebih gelap
/// setebal 9 px desain, kilau putih di kiri atas, dan ring kuning saat
/// disorot/ditekan.
class _AnswerButton extends StatefulWidget {
  const _AnswerButton({
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
  State<_AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<_AnswerButton> {
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

    // Kuning hanya muncul setelah tombol dipilih/hover.
    // Saat jari menekan, gunakan putih agar feedback tidak menyatu dengan
    // warna tombol kuning pada desain.
    final ringColor = widget.isWrong
        ? const Color(0xFFEF5350)
        : pressed
        ? Colors.white
        : widget.isSelected
        ? colors.selectionRing
        : const Color(0xFFE9DFFF);

    // Saat disorot tombol terangkat, saat ditekan turun sedikit.
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
              // Alas 3D (lebih gelap, sedikit masuk ke dalam).
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

              // Badan tombol.
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
                      // Kilau kiri atas.
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

              // Ring kuning mengikuti desain tombol "5" pada referensi.
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

/// Border putus-putus mengikuti lengkung panel (tanpa library tambahan).
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius - inset)),
      );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..color = color
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.radius != radius ||
      oldDelegate.dashLength != dashLength ||
      oldDelegate.gapLength != gapLength;
}
