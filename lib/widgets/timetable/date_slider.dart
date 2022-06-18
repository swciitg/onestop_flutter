import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/days.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:provider/provider.dart';

class DateSlider extends StatefulWidget {
  DateSlider({Key? key}) : super(key: key);
  @override
  State<DateSlider> createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  @override
  Widget build(BuildContext context) {
    TimetableStore ttStore = context.read<TimetableStore>();
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
              },
              child: FittedBox(
                child: Observer(builder: (context) {
                  bool selected = ttStore.selectedDate == index;
                  TextStyle tStyle = MyFonts.w500.size(14).setColor(kWhite);
                  if (!selected)
                    tStyle = MyFonts.w500.size(14).setColor(kGrey7);
                  return Container(
                    // height: 125,
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
