import 'package:onestop_dev/globals.dart';
import 'package:onestop_dev/pages/timetable/ApiCallingTimetable.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/timetable.dart';
import 'package:onestop_dev/functions/timetable/Functions.dart';
import 'package:onestop_dev/widgets/timetable/dateSlider.dart';
import 'package:onestop_dev/widgets/timetable/timeTableBuilder.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';

class TimeTableTab extends StatefulWidget {
  static const String id = 'time';
  const TimeTableTab({Key? key}) : super(key: key);
  @override
  State<TimeTableTab> createState() => _TimeTableTabState();
}

class _TimeTableTabState extends State<TimeTableTab> {
  int select = 0;
  String sel = "";
  List<Map<int, List<List<String>>>> Data1 = [];
  @override
  Widget build(BuildContext context) {
    sel = determiningSel();
    adjustTime();
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 130,
            child: DateSlider(),
          ),
          SizedBox(
            height: 10,
          ),
          TimeTableSlider(),
          SizedBox(
            height: 2,
          ),
          Row(children: <Widget>[
            Expanded(
                child: Divider(
              color: Colors.white,
            )),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Lunch Break',
                style: MyFonts.w500.size(12).setColor(Colors.white),
              ),
            ),
            Expanded(
                child: Divider(
              color: Colors.white,
            )),
          ]),
          SizedBox(
            height: 2,
          ),
          TimeTableSlider(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
