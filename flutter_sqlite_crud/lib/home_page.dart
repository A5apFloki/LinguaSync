import 'package:flutter/material.dart';
import 'package:lingua_sync/Views/notes.dart';
import 'package:lingua_sync/translation_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to the NotesPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ImageRec()),
                );
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Text Recognition'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Add your action for translation here
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('Translation'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TranslationPage()),
                );
                // Add your action for AI service here
              },
              icon: const Icon(Icons.android),
              label: const Text('AI Service'),
            ),
          ],
        ),
      ),
    );
  }
}
