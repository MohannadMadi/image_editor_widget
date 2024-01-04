import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

File? pickedImage;

Future pickImage() async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    pickedImage = File(pickedFile!.path);
    debugPrint(pickedImage!.path);
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<File?> resizeImage(File originalImage) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    originalImage.path,
    originalImage.path, // Overwrite the original file
    quality: 90,
    minWidth: 80,
    minHeight: 60,
  );

  return result as File;
}

Future<img.Image?> rotateImage(File imageFile, int direction) async {
  final image = img.decodeImage(await imageFile.readAsBytes());

  // Rotate the image (e.g., rotate by 90 degrees)
  final rotatedImage = img.copyRotate(image!, angle: 90 * direction);
  rotatedImage;
  return rotatedImage;
}

Future<File?> resizeAndRotateImage(File originalImage, int direction) async {
  final resizedImage = await resizeImage(originalImage);
  if (resizedImage == null) {
    // Handle resizing error
    return null;
  }

  final rotatedImage = await rotateImage(resizedImage, direction);
  if (rotatedImage == null) {
    // Handle rotation error
    return null;
  }

  return rotatedImage as File;
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(children: [
          InkWell(
            onTap: () async {
              await pickImage();
              rotateImage(pickedImage!, -1);
              setState(() {});
            },
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.green.shade300),
              alignment: Alignment.center,
              child: const Text("Add image"),
            ),
          ),
          pickedImage != null
              ? Container(
                  color: Colors.amber,
                  width: 200,
                  height: 200,
                  child: Image.file(pickedImage!),
                )
              : Container(),
        ]),
      ),
    );
  }
}
