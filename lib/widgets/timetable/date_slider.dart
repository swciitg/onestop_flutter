import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/days.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class DateSlider extends StatefulWidget {
  const DateSlider({super.key});

  @override
  State<DateSlider> createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  @override
  Widget build(BuildContext context) {
    TimetableStore ttStore = context.read<TimetableStore>();
    ttStore.initialiseDates();
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                ttStore.setDate(index);
                ttStore.setDay(ttStore.dates[index].weekday - 1);
              },
              child: FittedBox(
                child: Observer(builder: (context) {
                  bool selected = ttStore.selectedDate == index;
                  TextStyle tStyle = MyFonts.w500.size(14).setColor(kWhite);
                  if (!selected) {
                    tStyle = MyFonts.w500.size(14).setColor(kGrey7);
                  }
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selected ? kTimetableGreen : Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(kday[ttStore.dates[index].weekday]!,
                              style: tStyle),
                          Text(
                            ttStore.dates[index].day.toString(),
                            style: tStyle.size(30),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        });
  }
}
