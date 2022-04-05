import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? horizontalBlockSize;
  static double? verticalBlockSize;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
    horizontalBlockSize = (screenWidth)! / 100;
    verticalBlockSize = (screenHeight)! / 100;
  }
}
