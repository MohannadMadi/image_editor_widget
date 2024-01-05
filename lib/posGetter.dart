// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
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

class _PositionGetterState extends State<PositionGetter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingActionButton(onPressed: () async {
        await context.read<ImageDetailsProvider>().cropImage(widget.imageFile);
      }),
    );
  }
}
