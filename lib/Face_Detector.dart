import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  String selectedItem = '';
  File? _image;
  List<Face> _faces = [];
  final ImagePicker _picker = ImagePicker();
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  // Function to pick an image and detect faces
  Future<void> _pickImageAndDetectFaces() async {
    final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) return;

    setState(() {
      _image = File(imageFile.path);
      _faces = [];
    });

    final inputImage = InputImage.fromFilePath(_image!.path);
    final faces = await _faceDetector.processImage(inputImage);

    setState(() {
      _faces = faces;
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedItem = ModalRoute.of(context)?.settings.arguments?.toString() ?? 'Face Detector';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          selectedItem,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.blue,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (_image != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(_image!, height: 300),
            ),
          Text(
            'Faces Detected: ${_faces.length}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: _pickImageAndDetectFaces,
            child: const Text("Pick Image & Detect Faces"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }
}
