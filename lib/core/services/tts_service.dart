import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsStatus { idle, speaking, stopped, error }

/// Shared TTS engine. One request owns callbacks; stale callbacks are ignored.
class TtsService extends ChangeNotifier {
  TtsService._() {
    _tts.setStartHandler(() {
      debugPrint('[TTS] start request=$_requestId locale=$_locale');
      _setStatus(TtsStatus.speaking);
    });
    _tts.setCompletionHandler(() {
      debugPrint('[TTS] complete request=$_requestId');
      _setStatus(TtsStatus.idle);
    });
    _tts.setCancelHandler(() {
      debugPrint(
        '[TTS] cancel request=$_requestId replacing=$_replacingSpeech',
      );
      if (!_replacingSpeech) _setStatus(TtsStatus.stopped);
    });
    _tts.setErrorHandler((message) {
      debugPrint('[TTS] error request=$_requestId: $message');
      _setStatus(TtsStatus.error);
    });
  }

  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  TtsStatus _status = TtsStatus.idle;
  String? _locale;
  Map<String, String>? _selectedVoice;
  bool _initialized = false;
  int _requestId = 0;
  bool _replacingSpeech = false;

  TtsStatus get status => _status;
  bool get isSpeaking => _status == TtsStatus.speaking;
  String? get locale => _locale;

  void _setStatus(TtsStatus value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  Future<bool> initialize() async {
    if (_initialized) return _locale == 'id-ID';
    try {
      if (kIsWeb) {
        // Browser voice lists often omit locale metadata even when speechSynthesis
        // can speak. Do not reject Web TTS based on getLanguages.
        _locale = 'id-ID';
        debugPrint('[TTS] web platform: use requested locale=$_locale');
      } else {
        final languages = await _tts.getLanguages;
        final available = languages.map((value) => value.toString()).toList();
        _locale = available.cast<String?>().firstWhere(
          (value) => value?.toLowerCase() == 'id-id',
          orElse: () => null,
        );
        debugPrint('[TTS] languages=${available.length} id-ID=$_locale');
        if (_locale == null) {
          _initialized = true;
          _setStatus(TtsStatus.error);
          return false;
        }
      }
      // flutter_tts returns List<dynamic> containing Map<dynamic, dynamic>
      // on Android. Normalize keys and values before passing voice back.
      List<Map<String, String>> voices = const [];
      try {
        if (kIsWeb) {
          debugPrint('[TTS] web platform: skip Android voice enumeration');
        } else {
          final rawVoices = await _tts.getVoices;
          final allVoices = <Map<String, String>>[];
          for (final rawVoice in rawVoices) {
            if (rawVoice is! Map) continue;
            final voice = <String, String>{};
            rawVoice.forEach((key, value) {
              if (key != null && value != null) {
                voice[key.toString()] = value.toString();
              }
            });
            if (voice.isNotEmpty) allVoices.add(voice);
          }
          debugPrint('[TTS] all voices=$allVoices');
          voices = allVoices.where((voice) {
            final language = (voice['locale'] ?? voice['language'] ?? '')
                .toLowerCase()
                .replaceAll('_', '-');
            return language == 'id-id' || language.startsWith('id-');
          }).toList();
          debugPrint('[TTS] Indonesian voices=$voices');
        }
      } catch (error) {
        debugPrint('[TTS] voice list unavailable: $error; using default voice');
      }

      if (kIsWeb) {
        debugPrint('[TTS] web platform: use browser default voice');
      } else if (voices.isEmpty) {
        debugPrint('[TTS] no Indonesian voice found; using engine default');
      } else {
        final local = voices.where((voice) {
          final name = '${voice['name']} ${voice['variant']}'.toLowerCase();
          return name.contains('local');
        }).toList();
        final candidates = local.isNotEmpty ? local : voices;
        _selectedVoice = candidates.first;
        final voiceResult = await _tts.setVoice(_selectedVoice!);
        debugPrint(
          '[TTS] selected ${local.isNotEmpty ? 'local' : 'available'} voice='
          '$_selectedVoice result=$voiceResult',
        );
      }

      final languageResult = await _tts.setLanguage(_locale!);
      final rateResult = await _tts.setSpeechRate(0.49);
      final pitchResult = await _tts.setPitch(1.0);
      final volumeResult = await _tts.setVolume(1.0);
      final completionResult = await _tts.awaitSpeakCompletion(true);
      debugPrint(
        '[TTS] configured language=$languageResult rate=$rateResult '
        'pitch=$pitchResult volume=$volumeResult '
        'awaitCompletion=$completionResult',
      );
      _initialized = true;
      _setStatus(TtsStatus.idle);
      return true;
    } catch (error) {
      debugPrint('[TTS] initialize error: $error');
      _initialized = true;
      _setStatus(TtsStatus.error);
      return false;
    }
  }

  Future<bool> speakWithVoiceSettings(
    String text,
    String voiceId, {
    double pitch = 1.0,
    double speechRate = 0.49,
  }) async {
    final value = text.trim();
    if (value.isEmpty) {
      debugPrint('[TTS] sample skipped: empty text voice=$voiceId');
      return false;
    }
    final request = ++_requestId;
    debugPrint(
      '[TTS] sample voice=$voiceId locale=id-ID rate=$speechRate pitch=$pitch '
      'request=$request text="$value"',
    );
    try {
      final ready = await initialize();
      if (!ready || request != _requestId) {
        debugPrint('[TTS] sample aborted voice=$voiceId ready=$ready');
        return false;
      }
      final result = await _tts.setVoice(<String, String>{
        'name': voiceId,
        'locale': 'id-ID',
      });
      debugPrint('[TTS] sample setVoice voice=$voiceId result=$result');
      await _tts.setLanguage('id-ID');
      await _tts.setSpeechRate(speechRate);
      await _tts.setPitch(pitch);
      await _tts.stop();
      if (request != _requestId) return false;
      final speakResult = await _tts.speak(value);
      debugPrint('[TTS] sample speak voice=$voiceId result=$speakResult');
      return speakResult == 1 || speakResult == true || speakResult == null;
    } catch (error) {
      debugPrint('[TTS] sample error voice=$voiceId error=$error');
      if (request == _requestId) _setStatus(TtsStatus.error);
      return false;
    }
  }

  Future<bool> speakWithVoice(String text, String voiceId) async {
    return speakWithVoiceSettings(text, voiceId);
  }

  /* legacy implementation removed */
  /*
    final value = text.trim();
    if (value.isEmpty) {
      debugPrint('[TTS] sample skipped: empty text voice=$voiceId');
      return false;
    }
    final request = ++_requestId;
    debugPrint(
      '[TTS] sample voice=$voiceId locale=id-ID rate=0.49 pitch=1.0 '
      'request=$request text="$value"',
    );
    try {
      final ready = await initialize();
      if (!ready || request != _requestId) {
        debugPrint('[TTS] sample aborted voice=$voiceId ready=$ready');
        return false;
      }
      final result = await _tts.setVoice(<String, String>{
        'name': voiceId,
        'locale': 'id-ID',
      });
      debugPrint('[TTS] sample setVoice voice=$voiceId result=$result');
      await _tts.setLanguage('id-ID');
      await _tts.setSpeechRate(0.49);
      await _tts.setPitch(1.0);
      await _tts.stop();
      if (request != _requestId) return false;
      final speakResult = await _tts.speak(value);
      debugPrint('[TTS] sample speak voice=$voiceId result=$speakResult');
      return speakResult == 1 || speakResult == true || speakResult == null;
    } catch (error) {
      debugPrint('[TTS] sample error voice=$voiceId error=$error');
      if (request == _requestId) _setStatus(TtsStatus.error);
      return false;
    }
  }
  */

  Future<bool> speak(String text) async {
    final value = text.trim();
    if (value.isEmpty) {
      debugPrint('[TTS] speak skipped: empty text');
      return false;
    }
    final request = ++_requestId;
    debugPrint('[TTS] speak request=$request text="$value"');
    final ready = await initialize();
    debugPrint('[TTS] initialize result=$ready request=$request');
    if (!ready || request != _requestId) {
      debugPrint(
        '[TTS] speak aborted request=$request ready=$ready current=$_requestId',
      );
      return false;
    }
    try {
      _replacingSpeech = true;
      await _tts.stop();
      _replacingSpeech = false;
      if (request != _requestId) return false;
      final result = await _tts.speak(value);
      debugPrint('[TTS] speak result=$result request=$request');
      return result == 1 || result == true || result == null;
    } catch (error) {
      debugPrint('[TTS] speak error request=$request: $error');
      if (request == _requestId) _setStatus(TtsStatus.error);
      return false;
    }
  }

  Future<void> stop() async {
    final request = ++_requestId;
    debugPrint('[TTS] stop request=$request');
    try {
      await _tts.stop();
    } catch (error) {
      debugPrint('[TTS] stop error: $error');
    }
    _replacingSpeech = false;
    _setStatus(TtsStatus.stopped);
  }
}
