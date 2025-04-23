import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class Detailscreen extends StatefulWidget {
  const Detailscreen({super.key});

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  String selectedItem = '';
  File? _imageFile;
  String scannedText = ""; // Store recognized text

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        scannedText = ""; // Clear previous text
      });
    }
  }

  // Function to scan text from image
  Future<void> _scanText() async {
    if (_imageFile == null) return;

    final inputImage = InputImage.fromFile(_imageFile!);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        scannedText = recognizedText.text; // Store recognized text
      });
    } catch (e) {
      setState(() {
        scannedText = "Error: $e";
      });
    } finally {
      textRecognizer.close(); // Close recognizer
    }
  }

  @override
  Widget build(BuildContext context) {
    selectedItem = ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          selectedItem,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.blue,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _pickImage, // Open gallery on button press
            icon: Icon(Icons.add_a_photo, color: Colors.blue),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(width: 250,
                height: 250,
                child: _imageFile != null
                    ? Image.file(_imageFile!) // Display selected image
                    : Text("No image selected"),
              ),
              SizedBox(height: 20),
              Text(
                scannedText.isNotEmpty ? "Recognized Text:\n$scannedText" : "No text recognized",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanText, // Scan text when clicked
        child: Icon(Icons.check),
      ),
    );
  }
}
