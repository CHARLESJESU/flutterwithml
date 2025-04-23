import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class LabelScanner extends StatefulWidget {
  const LabelScanner({super.key});

  @override
  State<LabelScanner> createState() => _LabelScannerState();
}

class _LabelScannerState extends State<LabelScanner> {
  String selectedItem = '';
  File? pickedImage;
  String labelResult = 'No Labels Detected';
  final ImageLabeler imageLabeler = ImageLabeler(options: ImageLabelerOptions());

  /// Pick Image from Gallery
  Future<void> getImageFromGallery() async {
    final XFile? tempStore = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (tempStore == null) return;

    setState(() {
      pickedImage = File(tempStore.path);
      labelResult = 'Scanning...';
    });

    await detectLabels();
  }

  /// Detect Labels
  Future<void> detectLabels() async {
    if (pickedImage == null) return;

    final inputImage = InputImage.fromFile(pickedImage!);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    setState(() {
      labelResult = labels.isNotEmpty
          ? labels.map((label) => "${label.label} (${(label.confidence * 100).toStringAsFixed(1)}%)").join("\n")
          : 'No Labels Found';
    });
  }

  @override
  void dispose() {
    imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedItem = ModalRoute.of(context)!.settings.arguments.toString();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.image, color: Colors.blue),
            onPressed: getImageFromGallery,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (pickedImage != null)
            Center(
              child: Container(
                height: 250.0,
                width: 250.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(pickedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              labelResult,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
