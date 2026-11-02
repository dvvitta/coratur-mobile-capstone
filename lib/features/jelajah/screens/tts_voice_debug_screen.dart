import 'package:flutter/material.dart';

import '../../../core/services/tts_service.dart';

class TtsVoiceDebugScreen extends StatefulWidget {
  const TtsVoiceDebugScreen({super.key});
  @override
  State<TtsVoiceDebugScreen> createState() => _TtsVoiceDebugScreenState();
}

class _TtsVoiceDebugScreenState extends State<TtsVoiceDebugScreen> {
  static const sample =
      'Halo, adik pintar! Yuk, kita belajar huruf bersama. Wah, hebat sekali!';
  static const voices = [
    'id-id-x-ide-local',
    'id-id-x-idd-local',
    'id-id-x-dfz-local',
  ];
  static const settings = [
    (1.0, 0.49, 'Baseline'),
    (1.05, 0.49, 'Hangat'),
    (1.10, 0.48, 'Ceria'),
    (1.15, 0.48, 'Imut'),
  ];
  final _tts = TtsService.instance;
  String? _playing;

  Future<void> _play(
    String voice,
    double pitch,
    double rate,
    String label,
  ) async {
    if (_playing != null) return;
    final id = '$voice • $label';
    setState(() => _playing = id);
    try {
      await _tts.speakWithVoiceSettings(
        sample,
        voice,
        pitch: pitch,
        speechRate: rate,
      );
    } finally {
      if (mounted) setState(() => _playing = null);
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Debug TTS Voice')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Baseline pitch 1.0 / rate 0.49. Dengarkan kombinasi bertahap.',
        ),
        const SizedBox(height: 16),
        for (final voice in voices) ...[
          Text(voice, style: const TextStyle(fontWeight: FontWeight.w900)),
          for (final setting in settings)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                key: Key('tts_${voice}_${setting.$3}'),
                onPressed: _playing == null
                    ? () => _play(voice, setting.$1, setting.$2, setting.$3)
                    : null,
                child: Text(
                  '${setting.$3} • pitch ${setting.$1} • rate ${setting.$2}',
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
        if (_playing != null) Text('Memutar: $_playing'),
      ],
    ),
  );
}
