import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:shimmer/shimmer.dart';

class HomeTimetableShimmer extends StatelessWidget {
  const HomeTimetableShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          decoration: BoxDecoration(
              color: kHomeTile,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          height: 110,
          width: double.infinity,
        ),
        period: Duration(seconds: 1),
        baseColor: kHomeTile,
        highlightColor: lGrey);
  }
}
