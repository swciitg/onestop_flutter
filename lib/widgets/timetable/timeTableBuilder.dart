import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/functions/timetable/Functions.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/timetable.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/timetable/dateSlider.dart';
import 'package:provider/provider.dart';

class TimeTableSlider extends StatefulWidget {
  TimeTableSlider({Key? key}) : super(key: key);

  @override
  State<TimeTableSlider> createState() => _TimeTableSliderState();
}

class _TimeTableSliderState extends State<TimeTableSlider> {
  String sel='';
  @override
  Widget build(BuildContext context) {
    sel=determiningSel();
    TimetableStore ttStore = context.read<TimetableStore>();
    print("Rebuild");
    // print("in slider ${widget.data} and select = ${widget.select} sel = ${widget.sel} and itemCOUnt = ${widget.data[dates[widget.select - 1].weekday]!.length}");
    return Observer(
      builder: (context) {
        int select= ttStore.selectedDate;
        List<TimetableDay> data = context.read<TimetableStore>().allTimetableCourses;
        return ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: data[ttStore.dates[select].weekday].morning.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                child: Container(
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(25),
                  //   color:
                  //   (sel == data[dates[select].weekday].morning[index].timing)
                  //       ? Color.fromRGBO(101, 174, 130, 0.16)
                  //       : Color.fromRGBO(120, 120, 120, 0.16),
                  //   border:
                  //   (sel == data[dates[select].weekday].morning[index].timing)
                  //       ? Border.all(color: Colors.blueAccent)
                  //       : Border.all(color: Colors.transparent),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: Image.asset(
                                    'assets/images/class.png'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data[ttStore.dates[select].weekday].morning[index].timing,
                                style: MyFonts.w300
                                    .size(12)
                                    .setColor(kWhite),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data[ttStore.dates[select].weekday].morning[index].course!,
                                      style: MyFonts.w500
                                          .size(15)
                                          .setColor(kWhite),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                children: [
                                  // Icon(
                                  //   Icons.location_pin,
                                  //   size: 13,
                                  //   color: Color.fromRGBO(
                                  //       212, 227, 255, 100),
                                  // ),
                                  Text(
                                    data[ttStore.dates[select].weekday].morning[index].instructor!,
                                    style: MyFonts.w300
                                        .size(13)
                                        .setColor(Color.fromRGBO(
                                        212, 227, 255, 100)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }
    );
  }
}


class TimetableTile extends StatelessWidget {
  late final CourseModel course;
  TimetableTile({
    Key? key,
    required this.course
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sel = determiningSel();
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color:
          (sel == course.timing)
              ? Color.fromRGBO(101, 174, 130, 0.16)
              : Color.fromRGBO(120, 120, 120, 0.16),
          border:
          (sel == course.timing)
              ? Border.all(color: Colors.blueAccent)
              : Border.all(color: Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Image.asset(
                          'assets/images/class.png'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      course.timing,
                      style: MyFonts.w300
                          .size(12)
                          .setColor(kWhite),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            course.course!,
                            style: MyFonts.w500
                                .size(15)
                                .setColor(kWhite),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Row(
                      children: [
                        // Icon(
                        //   Icons.location_pin,
                        //   size: 13,
                        //   color: Color.fromRGBO(
                        //       212, 227, 255, 100),
                        // ),
                        Text(
                          course.instructor!,
                          style: MyFonts.w300
                              .size(13)
                              .setColor(Color.fromRGBO(
                              212, 227, 255, 100)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LunchDivider extends StatelessWidget {
  const LunchDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
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
    ]);
  }
}
