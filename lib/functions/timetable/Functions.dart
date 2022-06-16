import 'package:flutter/material.dart';
import 'package:onestop_dev/widgets/timetable/dateSlider.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';
Future<void> reload(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            backgroundColor: Colors.transparent,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Error',
                  style: MyFonts.w700.size(24).setColor(kWhite),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'You\'ve run into the error,please reload.',
                  style: MyFonts.w400.size(14).setColor(Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(85, 95, 113, 100)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Replay.png',
                        height: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Reload',
                        style: MyFonts.w500.size(14).setColor(Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    },
  );
}

String determiningSel() {
  DateTime now1 = DateTime.now();
  if (now1.hour < 10 && now1.minute < 56) {
    return "09:00 - 09:55 AM";
  } else if (now1.hour >= 10 && now1.hour < 11 && now1.minute < 56) {
    return "10:00 - 10:55 AM";
  } else if (now1.hour >= 11 && now1.hour < 12 && now1.minute < 56) {
    return "11:00 - 11:55 AM";
  } else if (now1.hour >= 12 && now1.hour < 13 && now1.minute < 56) {
    return "12:00 - 12:55 PM";
  } else if (now1.hour >= 13 && now1.hour < 15 && now1.minute < 56) {
    return "02:00 - 02:55 PM";
  } else if (now1.hour >= 15 && now1.hour < 16 && now1.minute < 56) {
    return "03:00 - 03:55 PM";
  } else if (now1.hour >= 16 && now1.hour < 17 && now1.minute < 56) {
    return "04:00 - 04:55 PM";
  } else if (now1.hour >= 17 && now1.hour < 18 && now1.minute < 56) {
    return "05:00 - 05:55 PM";
  }
  return "";
}

adjustTime() {
  dates[0] = DateTime.now();
  if (dates[0].weekday == 2) {
    dates[4] = dates[3].add(Duration(days: 3));
  } else if (dates[0].weekday == 3) {
    dates[3] = dates[2].add(Duration(days: 3));
    dates[4] = dates[3].add(Duration(days: 1));
  } else if (dates[0].weekday == 4) {
    dates[2] = dates[1].add(Duration(days: 3));
    dates[3] = dates[2].add(Duration(days: 1));
    dates[4] = dates[3].add(Duration(days: 1));
  } else if (dates[0].weekday == 5) {
    dates[1] = dates[0].add(Duration(days: 3));
    dates[2] = dates[1].add(Duration(days: 1));
    dates[3] = dates[2].add(Duration(days: 1));
    dates[4] = dates[3].add(Duration(days: 1));
  } else if (dates[0].weekday == 6) {
    dates[0] = dates[0].add(Duration(days: 2));
    dates[1] = dates[0].add(Duration(days: 1));
    dates[2] = dates[1].add(Duration(days: 1));
    dates[3] = dates[2].add(Duration(days: 1));
    dates[4] = dates[3].add(Duration(days: 1));
  } else if (dates[0].weekday == 7) {
    dates[0] = dates[0].add(Duration(days: 1));
    dates[1] = dates[0].add(Duration(days: 1));
    dates[2] = dates[1].add(Duration(days: 1));
    dates[3] = dates[2].add(Duration(days: 1));
    dates[4] = dates[3].add(Duration(days: 1));
  }
}
