import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  static final stt.SpeechToText _speech = stt.SpeechToText();

  static Future<void> listen(Function(String) onResult) async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) => onResult(result.recognizedWords),
      );
    } else {
      onResult("Speech recognition unavailable");
    }
  }

  static void stop() {
    _speech.stop();
  }
}
