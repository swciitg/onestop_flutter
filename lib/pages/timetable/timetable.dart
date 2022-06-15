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
  String sel="";
  int select=0;
  List<Map<int, List<List<String>>>> Data1 = [];
  @override
  Widget build(BuildContext context) {
    Future<Time> timetable = ApiCalling().getTimeTable(
        roll: context.read<LoginStore>().userData["rollno"] ?? "200101095");
    sel=determiningSel();
    adjustTime();
    return FutureBuilder<Time>(
      future: timetable,
      builder: (BuildContext context, AsyncSnapshot<Time> snapshot) {
        if (snapshot.hasData) {
          Data1= ApiCalling().addWidgets(data: snapshot.data!);
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 130,
                  child: DateSlider(select: select,),
                ),
                SizedBox(
                  height: 10,
                ),
                TimeTableSlider(data: Data1[0],select: select, sel: sel,),
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
                TimeTableSlider(data: Data1[1],select: select,sel: sel,),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          Future.delayed(Duration.zero, () => reload(context));
          return Column(
            children: [
              Container(
                height: 130,
                child: DateSlider(select: select,),
              ),
            ],
          );
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

}
