import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/timetable/date_slider.dart';
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

  @override
  Widget build(BuildContext context) {
    if(data.courses != null)
      {
        List<CourseModel> courses= data.courses!;
        print(DateTime.parse(courses[0].midsem!).minute);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Text("Midsem Schedule", style: MyFonts.w500.size(20).setColor(kWhite),),
            for(var course in courses)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 85),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: kTimetableGreen,
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.transparent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(DateTime.parse(course.midsem!).month.toString(), style: MyFonts.w400.setColor(kWhite),),
                                        Text(
                                          DateTime.parse(course.midsem!).day.toString(),style: MyFonts.w400.setColor(kWhite).size(30),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  course.timing,
                                  style: MyFonts.w300.size(12).setColor(kWhite),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  course.course!,
                                  style: MyFonts.w500.size(15).setColor(kWhite),
                                ),
                                const SizedBox(
                                  height: 3.0,
                                ),
                                Text(
                                  course.instructor!,
                                  style: MyFonts.w400.size(13).setColor(lBlue),
                                ),
                                const SizedBox(
                                  height: 3.0,
                                ),
                                if (course.venue != null)
                                  if(course.venue!.isNotEmpty)
                                    Row(
                                      children: [
                                        const Icon(
                                          FluentIcons.location_12_filled,
                                          color: lBlue,
                                          size: 13,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            course.venue!,
                                            style: MyFonts.w400.size(13).setColor(lBlue),
                                          ),
                                        )
                                      ],
                                    )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
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

getFormatedValue(String time, String type)
{
  DateTime examTime = DateTime.parse(time);
  if(type == "date")
    {
      return examTime.day.toString();
    }
  if(type == "month")
  {
    return examTime.day.toString();
  }
}

