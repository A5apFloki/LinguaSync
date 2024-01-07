import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationApi {
  static Future<String?> translateText(
    String recognizedText,
    String targetLanguage,
  ) async {
    try {
      final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
      final languageCode =
          await languageIdentifier.identifyLanguage(recognizedText);
      languageIdentifier.close();

      final translatedText = await _translateChunks(
        recognizedText,
        languageCode,
        targetLanguage.toLowerCase(),
      );

      return translatedText;
    } catch (e) {
      return null;
    }
  }

  static Future<String> _translateChunks(
    String recognizedText,
    String sourceLanguage,
    String targetLanguage,
  ) async {
    const chunkSize = 500; // Define chunk size
    final chunks = <String>[];
    for (var i = 0; i < recognizedText.length; i += chunkSize) {
      chunks.add(recognizedText.substring(
          i,
          i + chunkSize < recognizedText.length
              ? i + chunkSize
              : recognizedText.length));
    }

    final List<String> translatedChunks =
        await Future.wait(chunks.map((chunk) async {
      final translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.values
            .firstWhere((element) => element.bcpCode == sourceLanguage),
        targetLanguage: _getSelectedLanguage(targetLanguage),
      );
      final translatedText = await translator.translateText(chunk);
      translator.close();
      return translatedText;
    }));

    return translatedChunks.join();
  }

  static TranslateLanguage _getSelectedLanguage(String language) {
    switch (language) {
      case 'english':
        return TranslateLanguage.english;
      case 'french':
        return TranslateLanguage.french;
      case 'spanish':
        return TranslateLanguage.spanish;
      default:
        return TranslateLanguage.french; // Default to french
    }
  }
}
