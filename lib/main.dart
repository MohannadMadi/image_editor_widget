import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
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

  final rotatedImage = img.copyRotate(image!, angle: rotationAngle);

  final rotatedImageFile =
      File(imageFile.path.replaceAll('.jpg', '_rotated.jpg'));
  await rotatedImageFile.writeAsBytes(img.encodeJpg(rotatedImage));

  return rotatedImageFile;
}

// Future<File?> cropImage(File imageFile) async {
//   final ImageCropper imageCropper = ImageCropper();
//   try {
//     CroppedFile? cropResult = await imageCropper.cropImage(
//       sourcePath: imageFile.path,
//       aspectRatio: const CropAspectRatio(ratioX: 0.50, ratioY: 1.0),
//       compressQuality: 100,
//       maxHeight: 222,
//       maxWidth: 222,
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Image',
//           toolbarColor: Colors.deepOrange,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//         ),
//         IOSUiSettings(),
//       ],
//     );

//     // Use cropResult.path to get the path of the cropped image
//     return File(cropResult!.path);
//   } catch (e) {
//     debugPrint("---------------------$e");
//   }
//   return null;
// }

Future<File> cropImage(File file, Rect cropArea) async {
  Uint8List bytes = await file.readAsBytes();
  img.Image? image = img.decodeImage(bytes);

  int x = cropArea.left.toInt();
  int y = cropArea.top.toInt();
  int width = cropArea.width.toInt();
  int height = cropArea.height.toInt();

  img.Image croppedImage =
      img.copyCrop(image!, x: x, y: y, height: height, width: width);

  // Directory tempDir = await getTemporaryDirectory();
  // String tempPath = tempDir.path;

  File croppedFile = File(file.path.replaceAll('.jpg', '_cropped.jpg'));
  await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));

  return croppedFile;
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
              ? Container(
                  color: Colors.amber,
                  width: 200,
                  height: 260,
                  child: Image.file(pickedImage!),
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
          ),
          IconButton(
            onPressed: () async {
              Rect rect = Rect.fromLTWH(50, 50, 100, 100);

              File? croppedImage = await cropImage(pickedImage!, rect);
              pickedImage = croppedImage;
              setState(() {});
            },
            icon: const Icon(Icons.crop),
          )
        ]),
      ),
    );
  }
}
