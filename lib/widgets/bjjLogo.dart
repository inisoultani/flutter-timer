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
    return Container(
      height: 0,
      constraints: BoxConstraints.loose(Size.fromHeight(100.0)),
      //color: Colors.black,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.blueAccent,
      ),
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: [
          Positioned(
            // left: -35,
            top: -70,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              // child: Image.network(
              //   this.imageUrl,
              //   height: 250,
              //   width: double.infinity,
              //   fit: BoxFit.cover,
              // ),
              child: Container(
                height: 100,
                child: buildImageWidget(),
              ),
            ),
          ),
        ],
        clipBehavior: Clip.none,
      ),
    );
  }
}
