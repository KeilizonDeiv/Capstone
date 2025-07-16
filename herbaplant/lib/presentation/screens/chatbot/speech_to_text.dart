import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> initSpeech() async {
    _isInitialized = await _speechToText.initialize();
    return _isInitialized;
  }

  bool get isListening => _speechToText.isListening;

  Future<void> startListening(Function(String) onResult) async {
    if (!_isInitialized) await initSpeech();

    await _speechToText.listen(
      onResult: (result) => onResult(result.recognizedWords),
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<void> cancelListening() async {
    await _speechToText.cancel();
  }

  bool get isAvailable => _isInitialized;
}
