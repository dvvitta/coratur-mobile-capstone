import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/services/tts_service.dart';
import '../widgets/kenali_huruf_letter_button.dart';
import '../widgets/kenali_huruf_success_popup.dart';
import '../widgets/kenali_huruf_tiger.dart';
import '../widgets/kenali_huruf_white_wave.dart';

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
    _playBackgroundMusic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _speakWithMusicDucked(questions[_question].$3);
    });
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

  @override
  void dispose() {
    _timer?.cancel();
    _wrongGestureTimer?.cancel();
    _wrongResetTimer?.cancel();
    _backgroundPlayer.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _speakWithMusicDucked(String text) async {
    if (!_musicDuckedForSpeech) {
      _musicDuckedForSpeech = true;
      await _backgroundPlayer.setVolume(0.03);
    }
    setState(() {
      _speaking = true;
      _open = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 180), (_) {
      if (mounted) setState(() => _open = !_open);
    });
    await _tts.speak(text);
    _timer?.cancel();
    if (mounted) {
      setState(() {
        _speaking = false;
        _open = false;
      });
    }
    if (_musicDuckedForSpeech) {
      _musicDuckedForSpeech = false;
      await _backgroundPlayer.setVolume(0.10);
    }
  }

  void _showWrongGesture() {
    _wrongGestureTimer?.cancel();
    _wrongResetTimer?.cancel();
    final generation = ++_gestureGeneration;
    if (!mounted) return;

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
                child: KenaliHurufTiger(
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
                child: const KenaliHurufWhiteWave(),
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
                  child: KenaliHurufSuccessPopup(
                    scale: s,
                    onContinue: () =>
                        setState(() => _showSuccessPopup = false),
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
                        (l) => KenaliHurufLetterButton(
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
