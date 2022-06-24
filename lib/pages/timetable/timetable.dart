import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/timetable/time_range.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/timetable/date_slider.dart';
import 'package:onestop_dev/widgets/timetable/home_shimmer.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
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
    print("Rebuild course_model.dart");
    sel = findTimeRange();
    //adjustTime();
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
          Observer(builder: (context) {
            if (context.read<TimetableStore>().coursesLoaded) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount:
                      context.read<TimetableStore>().todayTimeTable.length,
                  itemBuilder: (context, index) =>
                      context.read<TimetableStore>().todayTimeTable[index]);
            }
            return ListShimmer();
          }),
        ],
      ),
    );
  }
}
