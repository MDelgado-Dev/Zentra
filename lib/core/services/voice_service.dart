import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  VoiceService({SpeechToText? speechToText})
    : _speech = speechToText ?? SpeechToText();

  final SpeechToText _speech;

  Future<bool> initialize() {
    return _speech.initialize();
  }

  Future<void> startListening({required void Function(String) onResult}) async {
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
    );
  }

  Future<void> stopListening() => _speech.stop();

  bool get isAvailable => _speech.isAvailable;
  bool get isListening => _speech.isListening;
}
