import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/timetable.dart';
import 'package:onestop_dev/widgets/timetable/timetable_tile.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmer extends StatelessWidget {
  const ListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CourseModel c = CourseModel();
    Container sample = Container(
      height: 80,
      decoration:
          BoxDecoration(color: kBlack, borderRadius: BorderRadius.circular(25)),
    );
    return Shimmer.fromColors(
        child: Container(
            height: 400,
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: sample,
                    ))),
        period: Duration(seconds: 1),
        baseColor: kHomeTile,
        highlightColor: lGrey);
  }
}
