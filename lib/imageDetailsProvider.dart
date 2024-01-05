import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:product_image_editor/main.dart';

class ImageDetailsProvider extends ChangeNotifier {
  File? pickedImage;
  void changeImage(File image) {
    pickedImage = image;
    notifyListeners();
  }

  Future pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      pickedImage = File(pickedFile!.path);
      debugPrint(pickedImage!.path);
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  Future<void> cropImage(File file) async {
    img.Image? image = await img.decodeImageFile(file.path);
    Rect cropArea = await getImageRect(file);
    int x = cropArea.left.toInt();
    int y = cropArea.top.toInt();
    int width = cropArea.width.toInt();
    int height = cropArea.height.toInt();

    if (width > height) {
      width = height;
    } else {
      height = width;
    }
    img.Image croppedImage =
        img.copyCrop(image!, x: 0, y: 0, height: height, width: width);
// make the name of the new fiile change only in the last path
//example: D:downloads/images/image1.jpg becomes D:downloads/images/"/${DateTime.now().millisecondsSinceEpoch}_cropped.jpg"
    File croppedFile = File(file.path.replaceRange(
        file.path.lastIndexOf('/'),
        file.path.length,
        "/${DateTime.now().millisecondsSinceEpoch}_cropped.jpg"));
    pickedImage = await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));

    notifyListeners();
  }

  Future<void> rotateImage(File imageFile, int rotationAngle) async {
    final image = await img.decodeImageFile(imageFile.path);

    final rotatedImage = img.copyRotate(image!, angle: rotationAngle);
// make the name of the new fiile change only in the last path
//example: D:downloads/images/image1.jpg becomes D:downloads/images/"/${DateTime.now().millisecondsSinceEpoch}_rotated.jpg"
    final rotatedImageFile = File(imageFile.path.replaceRange(
        imageFile.path.lastIndexOf('/'),
        imageFile.path.length,
        "/${DateTime.now().millisecondsSinceEpoch}_rotated.jpg"));
    pickedImage =
        await rotatedImageFile.writeAsBytes(img.encodeJpg(rotatedImage));
    notifyListeners();
  }
}
