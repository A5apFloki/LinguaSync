import 'package:lingua_sync/home_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lingua_sync/camera_widget.dart';

class ImageRec extends StatefulWidget {
  const ImageRec({Key? key}) : super(key: key);

  @override
  State<ImageRec> createState() => _HomeState();
}

class _HomeState extends State<ImageRec> {
  late Future<List<CameraDescription>> _camerasFuture;

  @override
  void initState() {
    super.initState();
    _camerasFuture = availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CameraDescription>>(
        future: _camerasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            final cameras = snapshot.data!;
            return CameraWidget(camera: cameras.first);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        child: const Icon(Icons.arrow_left),
      ),
    );
  }
}
