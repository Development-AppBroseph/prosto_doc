import 'package:flutter/material.dart';

class AppImages {
  final double height;
  final double width;
  BoxFit? boxFit;
  AppImages({
    required this.height,
    required this.width,
    this.boxFit,
  });
  // static Image logoImg = assetImage('assets/images/logo.png', height, width);

  Image assetImage(String assetName) {
    return Image.asset(
      assetName,
      width: width,
      height: height,
      fit: boxFit ?? BoxFit.fitHeight,
    );
  }
}
