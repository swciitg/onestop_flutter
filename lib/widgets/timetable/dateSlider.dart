import 'package:flutter/material.dart';
import '../../../globals/days.dart';
import '../../../globals/my_colors.dart';
import '../../../globals/my_fonts.dart';
import 'package:onestop_dev/globals.dart';
class DateSlider extends StatefulWidget {
  int select;
  DateSlider({Key? key,required this.select}) : super(key: key);

  @override
  State<DateSlider> createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.select = index;
                });
              },
              child: FittedBox(
                child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: (widget.select == index)
                        ? Color.fromRGBO(101, 174, 130, 0.16)
                        : Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                            child: Text(
                                kday[dates[index].weekday]!,
                                style: MyFonts.w500
                                    .size(20)
                                    .setColor(kWhite))),
                        FittedBox(
                            child: Text(
                              dates[index].day.toString(),
                              style: MyFonts.w800
                                  .size(40)
                                  .setColor(kWhite),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

DateTime now = DateTime.now();
DateTime day1 = now.add(Duration(days: 1));
DateTime day2 = now.add(Duration(days: 2));
DateTime day3 = now.add(Duration(days: 3));
DateTime day4 = now.add(Duration(days: 4));
List<DateTime> dates = [
  now,
  day1,
  day2,
  day3,
  day4,
];

