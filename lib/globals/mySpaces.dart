import 'package:onestop_dev/globals/sizeConfig.dart';

class MySpaces {
  static double get horizontalScreenPadding =>
      (4.86 * SizeConfig.horizontalBlockSize!);
  static double get listTileLeftPadding =>
      (0.06 * (SizeConfig.screenWidth! - 2 * 10));
}
