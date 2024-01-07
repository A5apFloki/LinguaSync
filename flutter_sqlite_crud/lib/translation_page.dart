import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TextEditingController _textController = TextEditingController();
  String selectedLanguage = 'English'; // Default language
  String translatedText = '';
  late OpenAI openAI;

  @override
  void initState() {
    super.initState();
    openAI = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
      enableLog: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Translation'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Enter text to translate',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _showLanguageDialog(context),
                    child: const Text('Select Language'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      minimumSize: Size(150, 40),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: translateText,
                    child: const Text('Translate'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      minimumSize: Size(150, 40),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    translatedText,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void translateText() {
    final textToTranslate = _textController.text.trim();
    if (textToTranslate.isNotEmpty) {
      final request = CompleteText(
        prompt: "Translate '$textToTranslate' to +$selectedLanguage",
        maxTokens: 200,
        model: TextDavinci3Model(),
      );
      openAI.onCompletion(request: request).then((it) {
        setState(() {
          translatedText = it!.choices.last.text; // Clear old text
        });
      }).catchError((error) {});
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageButton(
                'English',
                'English',
              ),
              _buildLanguageButton(
                'French',
                'French',
              ),
              _buildLanguageButton(
                'Spanish',
                'Spanish',
              ),
              _buildLanguageButton(
                'German',
                'German',
              ),
              _buildLanguageButton(
                'Chinese',
                'Chinese',
              ),
              _buildLanguageButton(
                'Japanese',
                'Japanese',
              ),
              _buildLanguageButton(
                'Russian',
                'Russian',
              ),
              _buildLanguageButton(
                'Italian',
                'Italian',
              ),
              _buildLanguageButton(
                'Portuguese',
                'Portuguese',
              ),
              _buildLanguageButton(
                'Arabic',
                'Arabic',
              ),
              // Add more language options as needed
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageButton(String displayText, String value) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedLanguage = value;
          Navigator.pop(context); // Close the dialog
        });
      },
      child: Text(displayText),
    );
  }
}
