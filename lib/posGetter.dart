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

late double imgPosVertiacal;
late double imgPosHorisontal;
late GlobalKey imgKey;
late GlobalKey cropperKey;

Offset getImagePosition() {
  RenderBox imgBox = imgKey.currentContext!.findRenderObject() as RenderBox;

  Offset imgPosition = imgBox.localToGlobal(Offset.zero);

  return imgPosition;
}

Offset getImageEndPosition() {
  RenderBox imgBox = imgKey.currentContext!.findRenderObject() as RenderBox;

  Offset imgPosition =
      imgBox.localToGlobal(Offset(imgBox.size.width, imgBox.size.height));

  return imgPosition;
}

Offset getCropperPosition() {
  RenderBox cropperBox =
      cropperKey.currentContext!.findRenderObject() as RenderBox;

  Offset cropperPosition = cropperBox.localToGlobal(Offset.zero);

  return cropperPosition;
}

Offset getCropperEndPosition() {
  RenderBox cropperBox =
      cropperKey.currentContext!.findRenderObject() as RenderBox;

  Offset cropperPosition = cropperBox
      .localToGlobal(Offset(cropperBox.size.width, cropperBox.size.height));

  return cropperPosition;
}

Size getCropperSize() {
  RenderBox cropperBox =
      cropperKey.currentContext!.findRenderObject() as RenderBox;
  return cropperBox.size;
}

Size getImageSize() {
  RenderBox? imageBox = imgKey.currentContext?.findRenderObject() as RenderBox?;

  // Check if imageBox is not null before accessing its properties
  if (imageBox != null) {
    return imageBox.size;
  } else {
    // Return a default size or handle the null case as needed
    return Size.zero;
  }
}

bool isHeightLarger() {
  RenderBox imgBox = imgKey.currentContext!.findRenderObject() as RenderBox;

  Size imgSize = imgBox.size;

  return imgSize.height > imgSize.width ? true : false;
}

late Size imgSize;

class _PositionGetterState extends State<PositionGetter> {
  @override
  void initState() {
    imgPosVertiacal = 0;
    imgPosHorisontal = 0;
    imgKey = GlobalKey();
    cropperKey = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Now, it's safe to access the context and initialize imgSize
      setState(() {
        imgPosVertiacal = (MediaQuery.of(context).size.center(Offset.zero).dy -
            imgSize.height / 2);
        imgPosHorisontal = MediaQuery.of(context).size.center(Offset.zero).dx -
            imgSize.width / 2;
      });
    });

    super.initState();
  }

  bool init = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Offset center = MediaQuery.of(context).size.center(Offset.zero);

    var watchIMageDetailsProviider = context.watch<ImageDetailsProvider>();
    var readIMageDetailsProviider = context.read<ImageDetailsProvider>();

    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeInOut,
          top: imgPosVertiacal,
          left: imgPosHorisontal,
          child: SizedBox(
              key: imgKey,
              // width: screenWidth,
              child: Image.file(
                context.watch<ImageDetailsProvider>().pickedImage!,
                width: screenWidth,
              )),
        ),
        Center(
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                print(details.delta.dy);
                if (!details.delta.dy.isNegative &&
                    (getImagePosition().dy + details.delta.dy) <=
                        getCropperPosition().dy) {
                  imgPosVertiacal += details.delta.dy;
                } else if (!details.delta.dy.isNegative) {
                  imgPosVertiacal = getCropperPosition().dy;
                }
                if (details.delta.dy.isNegative &&
                    (getImageEndPosition().dy + details.delta.dy) >=
                        getCropperEndPosition().dy) {
                  imgPosVertiacal += details.delta.dy;
                } else if (details.delta.dy.isNegative) {
                  imgPosVertiacal = getCropperPosition().dy -
                      (getImageSize().height - getCropperSize().height);
                }
              });
            },
            onHorizontalDragUpdate: (details) {
              setState(() {
                print(details.delta.dy);
                if (!details.delta.dx.isNegative &&
                    (getImagePosition().dx + details.delta.dx) <=
                        getCropperPosition().dx) {
                  imgPosHorisontal += details.delta.dx;
                } else if (!details.delta.dx.isNegative) {
                  imgPosHorisontal = getCropperPosition().dx;
                }
                if (details.delta.dx.isNegative &&
                    (getImageEndPosition().dx + details.delta.dx) >=
                        getCropperEndPosition().dx) {
                  imgPosHorisontal += details.delta.dx;
                } else if (details.delta.dx.isNegative) {
                  imgPosHorisontal = getCropperPosition().dx -
                      (getImageSize().width - getCropperSize().width);
                }
              });
            },
            child: Container(
              key: cropperKey,
              width: screenWidth,
              height: screenWidth,
              color: Color(0x2fffffff),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(),
            InkWell(
              onTap: () async {
                await readIMageDetailsProviider.cropImage(getImagePosition());
                Navigator.of(context).pop();
              },
              child:
                  Container(color: Colors.black, child: Text("Save Changes")),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        )
      ],
    ));
  }
}
