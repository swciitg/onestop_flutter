import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/days.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/timetable/home_shimmer.dart';
import 'package:onestop_dev/widgets/ui/animated_expand.dart';
import 'package:provider/provider.dart';

class DateCourse extends StatelessWidget {
  const DateCourse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Observer(builder: (context) {
      if (context.read<TimetableStore>().coursesLoaded) {
        var classes = context.read<TimetableStore>().homeTimeTable;
        bool showArrow = classes.length > 1;
        if (showArrow) {
          context.read<TimetableStore>().setDropDown(false);
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(kday[now.weekday]!,
                          style: MyFonts.w500.size(15).setColor(kWhite)),
                      Text(
                        now.day.toString(),
                        style: MyFonts.w600.size(30).setColor(kWhite),
                      )
                    ],
                  ),
                ),
                Expanded(flex: 36, child: classes[0]),
                const SizedBox(
                  width: 8,
                ),
                ArrowButton(
                  showArrow: showArrow,
                ),
              ],
            ),
            TimetableRow(classes: classes.skip(1).toList()),
          ],
        );
      }
      return const HomeTimetableShimmer();
    });
  }
}

class TimetableRow extends StatelessWidget {
  const TimetableRow({
    Key? key,
    required this.classes,
  }) : super(key: key);

  final List<Widget> classes;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return AnimatedExpand(
        expand: context.read<TimetableStore>().showDropDown,
        child: Column(
          children: classes
              .map((e) => Row(
                    children: [
                      const Expanded(
                        flex: 10,
                        child: SizedBox(),
                      ),
                      Expanded(flex: 36, child: e),
                      const SizedBox(
                        width: 8,
                      ),
                      const Expanded(flex: 7, child: SizedBox()),
                    ],
                  ))
              .toList(),
        ),
      );
      //return SizedBox();
    });
  }
}

class ArrowButton extends StatelessWidget {
  ArrowButton({Key? key, this.showArrow = false}) : super(key: key);
  late final bool showArrow;
  @override
  Widget build(BuildContext context) {
    if (showArrow) {
      return Observer(builder: (context) {
        return Expanded(
            flex: 7,
            child: GestureDetector(
              onTap: () {
                context.read<TimetableStore>().toggleDropDown();
              },
              child: Container(
                height: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: kTimetableGreen,
                ),
                child: Icon(
                  (!context.read<TimetableStore>().showDropDown)
                      ? Icons.keyboard_arrow_down_sharp
                      : Icons.keyboard_arrow_up_sharp,
                  color: Colors.green.shade800,
                ),
              ),
            ));
      });
    }
    return const SizedBox();
  }
}
