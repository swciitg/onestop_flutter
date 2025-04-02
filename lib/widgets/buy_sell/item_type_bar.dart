import 'package:flutter/cupertino.dart';

class ItemTypeBar extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final EdgeInsets margin;
  const ItemTypeBar(
      {super.key,
      required this.text,
      required this.textStyle,
      required this.backgroundColor,
      required this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(100)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
