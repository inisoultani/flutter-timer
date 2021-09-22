import 'dart:io';

import 'package:flutter/material.dart';

class BJJLogo extends StatelessWidget {
  final String imagePath;
  const BJJLogo({Key? key, required this.imagePath}) : super(key: key);

  Widget buildImageWidget() {
    if (this.imagePath.startsWith('assets')) {
      return Image.asset(imagePath);
    }
    return Image.file(File(imagePath));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      // child: Image.network(
      //   this.imageUrl,
      //   height: 250,
      //   width: double.infinity,
      //   fit: BoxFit.cover,
      // ),
      child: Container(
        height: 140,
        child: buildImageWidget(),
      ),
    );
  }
}
