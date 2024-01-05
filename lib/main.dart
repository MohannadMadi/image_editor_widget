import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:product_image_editor/imageDetailsProvider.dart';
import 'package:product_image_editor/posGetter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ImageDetailsProvider(),
    child: const Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

const int rotateClockWise = 90;
const int rotateCounterClockWise = -90;

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(children: [
          InkWell(
            onTap: () async {
              await context.read<ImageDetailsProvider>().pickImage();
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
          context.watch<ImageDetailsProvider>().pickedImage != null
              ? Container(
                  color: Colors.amber,
                  width: 200,
                  height: 260,
                  child: Image.file(
                      context.watch<ImageDetailsProvider>().pickedImage!),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    await context.read<ImageDetailsProvider>().rotateImage(
                        context.read<ImageDetailsProvider>().pickedImage!,
                        rotateClockWise);

                    debugPrint("SSSSS");
                    setState(() {});
                  },
                  icon: const Icon(Icons.rotate_90_degrees_cw)),
              IconButton(
                  onPressed: () async {
                    await context.read<ImageDetailsProvider>().rotateImage(
                        context.read<ImageDetailsProvider>().pickedImage!,
                        rotateCounterClockWise);
                    debugPrint("SSSSS");
                    setState(() {});
                  },
                  icon: const Icon(Icons.rotate_90_degrees_ccw)),
            ],
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PositionGetter(
                          imageFile: context
                              .watch<ImageDetailsProvider>()
                              .pickedImage!,
                        )));

                // File? croppedImage = await cropImage(pickedImage!);
                // pickedImage = croppedImage;
                setState(() {});
              },
              icon: const Icon(Icons.crop),
            );
          })
        ]),
      ),
    );
  }
}
