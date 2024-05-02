import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/timetable/course_model.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/timetable/date_slider.dart';
import 'package:onestop_dev/widgets/timetable/exam_schedule_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/widgets/ui/guest_restrict.dart';

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
    var store = context.read<TimetableStore>();
    return LoginStore.isGuest
        ? const GuestRestrictAccess()
        : SingleChildScrollView(
            child: Observer(builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toggle to change to either timetable or exam schedule
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            if (!(store.isTimetable)) {
                              store.setTT();
                            }
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                            child: Container(
                              height: 32,
                              color: (store.isTimetable) ? lBlue2 : kGrey2,
                              child: Center(
                                child: Text("Timetable",
                                    style: (store.isTimetable)
                                        ? MyFonts.w500.setColor(kBlueGrey)
                                        : MyFonts.w500.setColor(kWhite)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            if (store.isTimetable) {
                              store.setTT();
                            }
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                            child: Container(
                              height: 32,
                              color: !(store.isTimetable) ? lBlue2 : kGrey2,
                              child: Center(
                                child: Text(
                                  "Schedule",
                                  style: !(store.isTimetable)
                                      ? MyFonts.w500.setColor(kBlueGrey)
                                      : MyFonts.w500.setColor(kWhite),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Timetable column
                  (store.isTimetable)
                      ? Column(
                          children: [
                            //Day selector
                            const SizedBox(
                              height: 130,
                              child: DateSlider(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                                future: store.initialiseTT(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return ListShimmer();
                                  }
                                  return Observer(builder: (context) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: store.todayTimeTable.length,
                                        itemBuilder: (context, index) =>
                                            store.todayTimeTable[index]);
                                  });
                                }),
                          ],
                        )
                      // Exam schedule column
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<RegisteredCourses>(
                                future: store.getCourses(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return ListShimmer();
                                  } else if (!snapshot.hasData) {
                                    return ListShimmer();
                                  }
                                  return ScheduleList(
                                      data: snapshot.requireData);
                                })
                          ],
                        ),
                ],
              );
            }),
          );
  }
}

//Exam schedule column widgdet
class ScheduleList extends StatefulWidget {
  final RegisteredCourses data;
  const ScheduleList({super.key, required this.data});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  // checks if mids are done, if true then endsem is shown on top
  bool isMidsDone = false;

  // Sort the courses according to date and time
  List<CourseModel> _sort(List<CourseModel> input, {String type = "midsem"}) {
    if (type == "midsem") {
      input.removeWhere(
          (element) => element.midsem == null || element.midsem == "");
      input.sort((a, b) =>
          DateTime.parse(a.midsem!).isAfter(DateTime.parse(b.midsem!))
              ? 1
              : -1);
      if (DateTime.parse(input.last.midsem!).isBefore(DateTime.now())) {
        isMidsDone = true;
      }
    } else {
      input.removeWhere(
          (element) => element.endsem == null || element.endsem == "");
      input.sort((a, b) =>
          DateTime.parse(a.endsem!).isAfter(DateTime.parse(b.endsem!))
              ? 1
              : -1);
    }
    return input;
  }

  final Widget _noData = Column(
    children: [
      const SizedBox(
        height: 25,
      ),
      Center(
        child: Text(
          'No data found',
          style: MyFonts.w500.size(14).setColor(kGrey8),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (widget.data.courses != null) {
      List<CourseModel> endsem = _sort(widget.data.courses!, type: "endsem");
      List<CourseModel> midsem = _sort(widget.data.courses!);
      for (var course in midsem) {
        course.venue = course.midsemVenue;
      }
      for (var course in endsem) {
        course.venue = course.endsemVenue;
      }

      List<Widget> examColumn = [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            midsem.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Midsem Schedule",
                      style: MyFonts.w500.size(20).setColor(kWhite),
                    ),
                  )
                : Container(),
            for (var course in midsem)
              ExamTile(
                course: course,
                isEndSem: false,
              ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            endsem.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Endsem Schedule",
                      style: MyFonts.w500.size(20).setColor(kWhite),
                    ),
                  )
                : Container(),
            for (var course in endsem)
              ExamTile(
                course: course,
                isEndSem: true,
              ),
          ],
        ),
      ];

      if (isMidsDone) {
        examColumn = examColumn.reversed.map((e) => e).toList();
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        midsem.isEmpty && endsem.isEmpty
            ? _noData
            : Column(
                children: examColumn,
              ),
      ]);
    } else {
      return _noData;
    }
  }
}
