import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';

class ProgressBar extends StatelessWidget {
  final int blue;
  final int grey;
  const ProgressBar({Key? key, required this.blue, required this.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> bars = [];
    if (blue != 0) {
      bars.add(
        Expanded(
            child: Container(
              height: 4,
              color: lBlue2,
              margin: const EdgeInsets.only(right: 2),
            )),
      );
    }
    for (int i = 1; i < blue; i++) {
      bars.add(
        Expanded(
            child: Container(
              height: 4,
              color: lBlue2,
              margin: const EdgeInsets.symmetric(horizontal: 2),
            )),
      );
    }
    for (int i = 0; i < grey - 1; i++) {
      bars.add(
        Expanded(
            child: Container(
              height: 4,
              color: kGrey,
              margin: const EdgeInsets.symmetric(horizontal: 2),
            )),
      );
    }
    if (grey != 0) {
      bars.add(
        Expanded(
            child: Container(
              height: 4,
              color: kGrey,
              margin: const EdgeInsets.only(left: 2),
            )),
      );
    }
    return Row(
      children: bars,
    );
  }
}