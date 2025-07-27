import 'dart:math';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmer extends StatelessWidget {
  late final double height;
  late final int count;
  // ignore: prefer_const_constructors_in_immutables
  ListShimmer({
    super.key,
    this.height = 80,
    this.count = 3,
  });

  @override
  Widget build(BuildContext context) {
    Container sample = Container(
      height: height,
      decoration:
          BoxDecoration(color: kBlack, borderRadius: BorderRadius.circular(25)),
    );
    return Shimmer.fromColors(
        period: const Duration(seconds: 1),
        baseColor: kHomeTile,
        highlightColor: lGrey,
        child: SizedBox(
            height: max(400, count * height),
            child: ListView.builder(
                itemCount: count,
                itemBuilder: (_, _) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: sample,
                    ))));
  }
}
