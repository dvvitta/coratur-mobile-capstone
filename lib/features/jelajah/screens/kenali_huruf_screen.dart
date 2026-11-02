import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/services/tts_service.dart';

class KenaliHurufScreen extends StatefulWidget {
  const KenaliHurufScreen({super.key, this.visualAnimationTest = false});
  final bool visualAnimationTest;
  @override
  State<KenaliHurufScreen> createState() => _KenaliHurufScreenState();
}

class _KenaliHurufScreenState extends State<KenaliHurufScreen> {
  final _tts = TtsService.instance;
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  bool _musicDuckedForSpeech = false;
  Timer? _timer;
  Timer? _wrongGestureTimer;
  Timer? _wrongResetTimer;
  int _gestureGeneration = 0;
  int _headPose = 0;
  bool _open = false;
  bool _speaking = false;
  int _question = 0;
  bool _showSuccessPopup = false;
  final questions = const [
    ('A', 'Apel', 'Ayo pilih huruf A!'),
    ('B', 'Bola', 'Ayo pilih huruf B!'),
    ('C', 'Ceri', 'Ayo pilih huruf C!'),
  ];
  @override
  void initState() {
    super.initState();
    _tts.addListener(_sync);
    _playBackgroundMusic();
    if (widget.visualAnimationTest) {
      _start();
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _speakWithMusicDucked(questions[0].$3),
      );
    }
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundPlayer.setVolume(0.10);
      await _backgroundPlayer.play(AssetSource('backsound/sound_jelajah.mp3'));
    } catch (error) {
      debugPrint('[KenaliHuruf] background music error: $error');
    }
  }

  Future<void> _speakWithMusicDucked(String text) async {
    if (!_musicDuckedForSpeech) {
      _musicDuckedForSpeech = true;
      await _backgroundPlayer.setVolume(0.02);
    }
    await _tts.speak(text);
  }

  void _sync() {
    if (widget.visualAnimationTest || !mounted) return;
    final active = _tts.isSpeaking;
    if (active) {
      if (!_musicDuckedForSpeech) {
        _musicDuckedForSpeech = true;
        _backgroundPlayer.setVolume(0.02);
      }
      _start();
      if (!_speaking) setState(() => _speaking = true);
      return;
    }
    _stopMouthAnimation();
    if (_musicDuckedForSpeech) {
      _musicDuckedForSpeech = false;
      _backgroundPlayer.setVolume(0.10);
    }
  }

  void _stopMouthAnimation() {
    _timer?.cancel();
    _timer = null;
    if (mounted && (_speaking || _open)) {
      setState(() {
        _speaking = false;
        _open = false;
      });
    }
  }

  void _start() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (!mounted) return;
      setState(() => _open = !_open);
    });
    if (mounted && !_speaking) setState(() => _speaking = true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wrongGestureTimer?.cancel();
    _wrongResetTimer?.cancel();
    _gestureGeneration++;
    _timer = null;
    _open = false;
    _headPose = 0;
    _tts.removeListener(_sync);
    _backgroundPlayer.dispose();
    if (!widget.visualAnimationTest) _tts.stop();
    super.dispose();
  }

  void _showWrongGesture() {
    _wrongGestureTimer?.cancel();
    _wrongResetTimer?.cancel();
    final generation = ++_gestureGeneration;
    if (!mounted) return;

    // Hold each pose during cross-fade. No overlapping timers/callbacks.
    setState(() => _headPose = 1);
    _wrongGestureTimer = Timer.periodic(const Duration(milliseconds: 360), (
      timer,
    ) {
      if (!mounted || generation != _gestureGeneration) {
        timer.cancel();
        return;
      }
      setState(() => _headPose = _headPose == 1 ? 2 : 1);
    });
    _wrongResetTimer = Timer(const Duration(milliseconds: 1500), () {
      _wrongGestureTimer?.cancel();
      _wrongGestureTimer = null;
      if (mounted && generation == _gestureGeneration) {
        setState(() => _headPose = 0);
      }
    });
  }

  Future<void> choose(String l) async {
    final correct = l == questions[_question].$1;
    await _tts.stop();
    if (!mounted) return;
    if (correct) {
      await _speakWithMusicDucked('Bagus sekali! Kamu hebat.');
      if (!mounted) return;
      setState(() {
        _question = (_question + 1) % questions.length;
        _showSuccessPopup = true;
      });
    } else {
      _showWrongGesture();
      await _speakWithMusicDucked('Belum tepat, yuk coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (c, box) {
          final s = box.maxWidth / 412;
          final tigerH = box.maxWidth * 1.5;
          final footerH = box.maxWidth * 840 / 1871;
          return Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                width: box.maxWidth,
                height: footerH,
                child: Image.asset(
                  'assets/images/footerkenali.png',
                  width: box.maxWidth,
                  height: footerH,
                  fit: BoxFit.fill,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                width: box.maxWidth,
                height: tigerH,
                child: _TalkingTiger(
                  mouthOpen: _speaking && _open,
                  headPose: _headPose,
                  width: box.maxWidth,
                  height: tigerH,
                ),
              ),
              Positioned(
                top: 510 * s,
                left: 0,
                right: 0,
                height: 110 * s,
                child: const _WhiteWave(),
              ),
              Positioned(
                top: 48 * s,
                left: 18 * s,
                width: 58 * s,
                height: 58 * s,
                child: Material(
                  color: Colors.transparent,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF8F6AF7),
                    child: IconButton(
                      key: const Key('kenali_huruf_back'),
                      tooltip: 'Kembali ke Jelajah Cilik',
                      onPressed: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamedAndRemoveUntil(
                          AppRoutes.jelajahCilik,
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
              ),
              if (_showSuccessPopup)
                Positioned.fill(
                  child: _SuccessPopup(
                    scale: s,
                    onContinue: () => setState(() => _showSuccessPopup = false),
                  ),
                ),
              Positioned(
                top: 57 * s,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Text(
                    'Kenali Huruf',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24 * s,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF4632AB),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 114 * s,
                right: 25 * s,
                child: GestureDetector(
                  key: const Key('kenali_huruf_speak'),
                  onTap: () => _speakWithMusicDucked(questions[_question].$3),
                  child: Container(
                    padding: EdgeInsets.all(10 * s),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25 * s),
                    ),
                    child: Icon(
                      Icons.volume_up_rounded,
                      color: const Color(0xFF6C42F5),
                      size: 30 * s,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 570 * s,
                left: 31 * s,
                right: 31 * s,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['A', 'B', 'C']
                      .map(
                        (l) => _LetterButton(
                          key: Key('kenali_huruf_option_$l'),
                          letter: l,
                          scale: s,
                          onTap: () => choose(l),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SuccessPopup extends StatelessWidget {
  const _SuccessPopup({required this.scale, required this.onContinue});
  final double scale;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0x88000000),
    child: Center(
      child: Container(
        margin: EdgeInsets.all(28 * scale),
        padding: EdgeInsets.all(22 * scale),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F2E7),
          borderRadius: BorderRadius.circular(30 * scale),
          border: Border.all(color: const Color(0xFFB8EFA8), width: 4 * scale),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76 * scale,
              height: 76 * scale,
              decoration: const BoxDecoration(
                color: Color(0xFF73D85C),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 52 * scale,
              ),
            ),
            SizedBox(height: 12 * scale),
            Text(
              'Jawaban Benar!',
              style: TextStyle(
                color: const Color(0xFF3B9E2F),
                fontSize: 25 * scale,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5 * scale),
            Text(
              'Hebat! Kamu berhasil mengenali huruf.',
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
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF73D85C),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18 * scale),
                  ),
                ),
                child: const Text('Lanjut'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _TalkingTiger extends StatelessWidget {
  const _TalkingTiger({
    required this.mouthOpen,
    required this.headPose,
    required this.width,
    required this.height,
  });
  final bool mouthOpen;
  final int headPose;
  final double width, height;
  String get _assetPath {
    if (headPose == 1) return 'assets/karakter/tiger right.png';
    if (headPose == 2) return 'assets/karakter/tiger left.png';
    return mouthOpen
        ? 'assets/karakter/tiger speak.png'
        : 'assets/karakter/tiger idle.png';
  }

  Widget _image(String path) => Image.asset(
    path,
    width: width,
    height: height,
    fit: BoxFit.fill,
    gaplessPlayback: true,
  );

  @override
  Widget build(BuildContext c) {
    final image = _image(_assetPath);
    // Pose assets are opaque RGB images. Cross-fade blends their white
    // backgrounds and creates a flash, so swap pose atomically.
    return image;
  }
}

class _WhiteWave extends StatelessWidget {
  const _WhiteWave();
  @override
  Widget build(BuildContext c) => CustomPaint(painter: _WavePainter());
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Path()
      ..moveTo(0, 22)
      ..quadraticBezierTo(s.width * .2, -5, s.width * .4, 20)
      ..quadraticBezierTo(s.width * .7, 50, s.width, 12)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    c.drawPath(p, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

class _LetterButton extends StatelessWidget {
  const _LetterButton({
    super.key,
    required this.letter,
    required this.scale,
    required this.onTap,
  });
  final String letter;
  final double scale;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext c) {
    final color = {
      'A': const Color(0xFFFF8EAA),
      'B': const Color(0xFF8CC4FF),
      'C': const Color(0xFFBBA4FF),
    }[letter]!;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24 * scale),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24 * scale),
        child: SizedBox(
          width: 107 * scale,
          height: 120 * scale,
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 52 * scale,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
