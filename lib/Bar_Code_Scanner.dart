import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarCodeScanner extends StatefulWidget {
  const BarCodeScanner({super.key});

  @override
  State<BarCodeScanner> createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner> {
  String selectedItem = '';
  File? pickedImage;
  String barcodeResult = 'No Barcode Detected';

  /// Pick Image from Gallery
  Future<void> getImageFromGallery() async {
    final XFile? tempStore = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (tempStore == null) return;

    setState(() {
      pickedImage = File(tempStore.path);
      barcodeResult = 'Scanning...';
    });

    decodeBarCode();
  }

  /// Decode Barcode
  Future<void> decodeBarCode() async {
    if (pickedImage == null) return;

    final inputImage = InputImage.fromFile(pickedImage!);
    final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.ean13, BarcodeFormat.upca]);

    try {
      final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
      await barcodeScanner.close();

      setState(() {
        barcodeResult = barcodes.isNotEmpty
            ? barcodes.first.displayValue ?? 'No Barcode Found'
            : 'No Barcode Found';
      });
    } catch (e) {
      setState(() {
        barcodeResult = 'Error: ${e.toString()}';
      });
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.blue,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.blue),
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
              barcodeResult,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
