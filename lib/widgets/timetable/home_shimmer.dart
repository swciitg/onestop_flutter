import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:shimmer/shimmer.dart';

class HomeTimetableShimmer extends StatelessWidget {
  const HomeTimetableShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(seconds: 1),
        baseColor: kHomeTile,
        highlightColor: lGrey,
        child: Container(
          decoration: const BoxDecoration(
              color: kHomeTile,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          height: 110,
          width: double.infinity,
        ));
  }
}
