import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/size_config.dart';

class MyFonts {
  static final String _fontFamily = 'Montserrat';

  static TextStyle get w500 =>
      TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w500);
  static TextStyle get w800 =>
      TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800);
  static TextStyle get w300 =>
      TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w300);
  static TextStyle get w400 =>
      TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w400);
  static TextStyle get w700 =>
      TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w700);
  static TextStyle get w600 =>
      TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600);
}

extension TextStyleHelpers on TextStyle {
  TextStyle setColor(Color color) => copyWith(color: color);
  TextStyle factor(double factor) =>
      copyWith(fontSize: factor * SizeConfig.verticalBlockSize!);
  TextStyle size(double size) => copyWith(fontSize: size);
  TextStyle letterSpace(double space) => copyWith(letterSpacing: space);
}
