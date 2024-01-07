import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lingua_sync/apis/translation_api.dart';
import 'package:lingua_sync/apis/recognition_api.dart';

class CameraWidget extends StatefulWidget {
  final CameraDescription camera;
  const CameraWidget({required this.camera, Key? key}) : super(key: key);

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController cameraController;
  late Future<void> initCameraFn;
  String? shownText;
  String selectedLanguage = 'French'; // Default language
  bool isTranslating = false;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    initCameraFn = cameraController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  Future<void> _changeLanguage(String language) async {
    setState(() {
      selectedLanguage = language;
    });
  }

  Future<void> _translateImage() async {
    final image = await cameraController.takePicture();
    final recognizedText = await RecognitionApi.recognizeText(
      InputImage.fromFile(
        File(image.path),
      ),
    );
    if (recognizedText == null) return;

    setState(() {
      isTranslating = true;
    });

    final translatedText = await TranslationApi.translateText(
      recognizedText,
      selectedLanguage,
    );

    setState(() {
      shownText = translatedText;
      isTranslating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              FutureBuilder(
                future: initCameraFn,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(cameraController),
                  );
                }),
              ),
              if (shownText != null)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.black45,
                    child: Text(
                      shownText!,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.clear),
              color: const Color.fromRGBO(103, 58, 183, 1),
              onPressed: () {
                setState(() {
                  shownText = null;
                });
              },
            ),
          ),
          if (isTranslating)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    await _translateImage();
                  },
                  child: const Icon(Icons.translate),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () async {
                    await showDialog(
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
                              // Add more language options as needed
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.language),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String text, String language) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _changeLanguage(language);
          Navigator.pop(context);
        },
        child: Text(text),
      ),
    );
  }
}
