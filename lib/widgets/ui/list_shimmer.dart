import 'dart:math';

import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmer extends StatelessWidget {
  late final double height;
  late final int count;
  // ignore: prefer_const_constructors_in_immutables
  ListShimmer({super.key, this.height = 80, this.count = 3});

  @override
  Widget build(BuildContext context) {
    Container sample = Container(
      height: height,
      decoration: BoxDecoration(
        color: OColor.gray200,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
    );
    return Shimmer.fromColors(
      period: const Duration(seconds: 1),
      baseColor: OColor.gray200,
      highlightColor: OColor.gray300,
      child: SizedBox(
        height: max(400, count * height),
        child: ListView.builder(
          itemCount: count,
          itemBuilder: (_, _) => Padding(padding: const EdgeInsets.all(OSpacing.xs), child: sample),
        ),
      ),
    );
  }
}
