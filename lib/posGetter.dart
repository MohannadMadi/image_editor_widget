// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:product_image_editor/imageDetailsProvider.dart';
import 'package:product_image_editor/main.dart';
import 'package:provider/provider.dart';

class PositionGetter extends StatefulWidget {
  File imageFile;

  PositionGetter({
    super.key,
    required this.imageFile,
  });

  @override
  State<PositionGetter> createState() => _PositionGetterState();
}

double imgPosVertiacal = 0;
double imgPosHorisontal = 0;
GlobalKey imgKey = GlobalKey();
GlobalKey cropperKey = GlobalKey();

void getImagePosition() {
  RenderBox imgBox = imgKey.currentContext!.findRenderObject() as RenderBox;

  Offset imgPosition = imgBox.localToGlobal(Offset.zero);

  print('First Widget Position: $imgPosition');
}

void getCropperPosition() {
  RenderBox cropperBox =
      cropperKey.currentContext!.findRenderObject() as RenderBox;

  Offset cropperPosition = cropperBox.localToGlobal(Offset.zero);

  print('First Widget Position: $cropperPosition');
}

class _PositionGetterState extends State<PositionGetter> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var watchIMageDetailsProviider = context.watch<ImageDetailsProvider>();
    var readIMageDetailsProviider = context.read<ImageDetailsProvider>();
    return Scaffold(
        body:
            //  FloatingActionButton(onPressed: () async {
            //   await context.read<ImageDetailsProvider>().cropImage(widget.imageFile);
            // }),
            Stack(
      children: [
        AnimatedPositioned(
          duration: Duration.zero,
          top: imgPosVertiacal,
          left: imgPosHorisontal,
          child: SizedBox(
              key: imgKey,
              width: screenWidth,
              child: Image.file(
                  context.watch<ImageDetailsProvider>().pickedImage!)),
        ),
        Center(
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                imgPosVertiacal += details.delta.dy;
                getImagePosition();
              });
            },
            onHorizontalDragUpdate: (details) {
              setState(() {
                imgPosHorisontal += details.delta.dx;
              });
            },
            child: Container(
              key: cropperKey,
              width: screenWidth,
              height: screenWidth,
              color: Color(0x2fffffff),
            ),
          ),
        )
      ],
    ));
  }
}
