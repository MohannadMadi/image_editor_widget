import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
const int rotateClockWise = 90;
const int rotateCounterClockWise = -90;
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

Future<File> rotateImage(File imageFile, int rotationAngle) async {
  final image = img.decodeImage(await imageFile.readAsBytes());

  // Rotate the image (e.g., rotate by 90 degrees)
  final rotatedImage = img.copyRotate(image!, angle: rotationAngle);

  // Create a new File instance for the rotated image
  final rotatedImageFile =
      File(imageFile.path.replaceAll('.jpg', '_rotated.jpg'));
  await rotatedImageFile.writeAsBytes(img.encodeJpg(rotatedImage));

  return rotatedImageFile;
}

Future<void> cropImage() async {
  final ImageCropper imageCropper = ImageCropper();

  pickedImage = (await imageCropper.cropImage(
      sourcePath: pickedImage!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      compressQuality: 100,
      maxWidth: 700,
      maxHeight: 700,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(),
      ])) as File?;
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(children: [
          InkWell(
            onTap: () async {
              await pickImage();

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
              ? InkWell(
                  onTap: () async {
                    setState(() {});
                  },
                  child: Container(
                    color: Colors.amber,
                    width: 200,
                    height: 260,
                    child: Image.file(pickedImage!),
                  ),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    pickedImage =
                        await rotateImage(pickedImage!, rotateClockWise);
                    debugPrint("SSSSS");
                    setState(() {});
                  },
                  icon: const Icon(Icons.rotate_90_degrees_cw)),
              IconButton(
                  onPressed: () async {
                    pickedImage =
                        await rotateImage(pickedImage!, rotateCounterClockWise);
                    debugPrint("SSSSS");
                    setState(() {});
                  },
                  icon: const Icon(Icons.rotate_90_degrees_ccw)),
            ],
          )
        ]),
      ),
    );
  }
}
