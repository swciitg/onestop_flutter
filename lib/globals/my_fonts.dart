import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/size_config.dart';

class MyFonts {
  static const String _fontFamily = 'Montserrat';

  static TextStyle get w500 =>
      const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w500);
  static TextStyle get w800 =>
      const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w800);
  static TextStyle get w300 =>
      const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w300);
  static TextStyle get w400 =>
      const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w400);
  static TextStyle get w700 =>
      const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w700);
  static TextStyle get w600 =>
      const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600);
}

extension TextStyleHelpers on TextStyle {
  TextStyle setColor(Color color) => copyWith(color: color);
  TextStyle factor(double factor) =>
      copyWith(fontSize: factor * SizeConfig.verticalBlockSize!);
  TextStyle size(double size) => copyWith(fontSize: size);
  TextStyle letterSpace(double space) => copyWith(letterSpacing: space);
  TextStyle setHeight(double space) => copyWith(height: space);
}
