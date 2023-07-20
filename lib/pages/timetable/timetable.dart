import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/timetable/date_slider.dart';
import 'package:onestop_dev/widgets/timetable/exam_schedule_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/widgets/ui/guest_restrict.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';
import '../../models/timetable/course_model.dart';
import '../../models/timetable/registered_courses.dart';

class TimeTableTab extends StatefulWidget {
  static const String id = '/time';
  const TimeTableTab({Key? key}) : super(key: key);
  @override
  State<TimeTableTab> createState() => _TimeTableTabState();
}

class _TimeTableTabState extends State<TimeTableTab> {
  List<Map<int, List<List<String>>>> data1 = [];
  @override
  Widget build(BuildContext context) {
    return LoginStore.isGuest ? const GuestRestrictAccess() : SingleChildScrollView(
      child: Observer(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      (context.read<TimetableStore>().setTT());
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40),
                      ),
                      child: Container(
                        height: 32,
                        width: 140,
                        color: (context.read<TimetableStore>().isTimetable)
                            ? lBlue2
                            : kGrey2,
                        child: Center(
                          child: Text("Timetable",
                              style: (context.read<TimetableStore>().isTimetable)
                                  ? MyFonts.w500.setColor(kBlueGrey)
                                  : MyFonts.w500.setColor(kWhite)),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      (context.read<TimetableStore>().setTT());
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40),
                      ),
                      child: Container(
                        height: 32,
                        width: 140,
                        color: !(context.read<TimetableStore>().isTimetable)
                            ? lBlue2
                            : kGrey2,
                        child: Center(
                          child: Text(
                            "Schedule",
                            style: !(context.read<TimetableStore>().isTimetable)
                                ? MyFonts.w500.setColor(kBlueGrey)
                                : MyFonts.w500.setColor(kWhite),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          (context.read<TimetableStore>().isTimetable)?Column(
            children: [
              const SizedBox(
                height: 130,
                child: DateSlider(),
              ),
              const SizedBox(
                height: 10,
              ),
              Observer(builder: (context) {
                if (context.read<TimetableStore>().coursesLoaded) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount:
                      context.read<TimetableStore>().todayTimeTable.length,
                      itemBuilder: (context, index) =>
                      context.read<TimetableStore>().todayTimeTable[index]);
                }
                return ListShimmer();
              }),
            ],
          ):Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<RegisteredCourses>(
                future: DataProvider.getTimeTable(roll: "200101071"),
                  builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Container();
                  }
                  else if(!snapshot.hasData)
                  {
                    return Container();
                  }
                return ScheduleList(data: snapshot.requireData);
              })
            ],
          ),

            ],
          );
        }
      ),
    );
  }
}

class ScheduleList extends StatelessWidget {
  final RegisteredCourses data;
  const ScheduleList({super.key, required this.data});

  List<CourseModel> _sort(List<CourseModel> input, {String type = "midsem"})
  {
    if(type == "midsem")
    {
      input.sort((a,b) => DateTime.parse(a.midsem!).isAfter(DateTime.parse(b.midsem!)) ? 1 : -1);
    }
    else
    {
      input.sort((a,b) => DateTime.parse(a.endsem!).isAfter(DateTime.parse(b.endsem!)) ? 1 : -1);
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    if(data.courses != null)
      {
        List<CourseModel> endsem = _sort(data.courses!, type: "endsem");
        List<CourseModel> midsem = _sort(data.courses!);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Text("Midsem Schedule", style: MyFonts.w500.size(20).setColor(kWhite),),
            for(var course in midsem)
              ExamTile(course: course),
            const SizedBox(
              height: 8,
            ),
            Text("Endsem Schedule", style: MyFonts.w500.size(20).setColor(kWhite),),
            for(var course in endsem)
              ExamTile(course: course, isEndSem: true,)
          ],
        );
      }
    else
      {
        return Column(

        );
      }

  }
}



