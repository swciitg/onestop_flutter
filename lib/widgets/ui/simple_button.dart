import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class SimpleButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final String label;
  final BorderRadius? borderRadius;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;
  const SimpleButton(
      {super.key,
      this.height,
      this.width,
      this.backgroundColor,
      required this.label,
      this.borderRadius,
      this.labelStyle,
      this.padding,
      this.margin,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor ?? lBlue2,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: labelStyle ?? MyFonts.w500.size(16).setColor(kBlack),
          ),
        ),
      ),
    );
  }
}
