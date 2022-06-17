import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/days.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/timetable/timeTableBuilder.dart';

class DateCourse extends StatefulWidget {
  String sel;
  List<Map<int,List<List<String>>>>data;
  DateCourse({
    Key? key,
    required this.data,
    required this.sel,
  }) : super(key: key);

  @override
  State<DateCourse> createState() => _DateCourseState();
}

class _DateCourseState extends State<DateCourse> {
  bool show = false;
  DateTime now=DateTime.now();
  List<String> determiningClass() {
    for (var v in widget.data[0][now.weekday]!) {
      if (v[0] == widget.sel) return v;
    }
    for (var v in widget.data[1][now.weekday]!) {
      if (v[0] == widget.sel) return v;
    }
    return ['', 'No Class Right now', ''];
  }

  @override
  Widget build(BuildContext context) {
    List<String> ans = determiningClass();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                          child: Text(kday[now.weekday]!,
                              style: MyFonts.w500.size(20).setColor(kWhite))),
                      FittedBox(
                          child: Text(
                            now.day.toString(),
                            style: MyFonts.w800.size(40).setColor(kWhite),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color.fromRGBO(101, 174, 130, 0.16),
                  border: Border.all(color: Colors.transparent),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: (widget.data[0][now.weekday] != null ||
                      widget.data[1][now.weekday] != null)
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (ans[0] != '')
                                ? Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Image.asset(
                                  'assets/images/class.png'),
                            )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ans[0],
                              style:
                              MyFonts.w300.size(12).setColor(kWhite),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ans[1],
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
                                Text(
                                  ans[2],
                                  style: MyFonts.w300.size(13).setColor(
                                      Color.fromRGBO(212, 227, 255, 100)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0),
                        child: Text("It's a Holiday! Enjoy!!"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    show = !show;
                  });
                },
                child: Container(
                  height: 100,
                  child: Icon(
                    (!show)
                        ? Icons.keyboard_arrow_down_sharp
                        : Icons.keyboard_arrow_up_sharp,
                    color: Colors.green.shade800,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromRGBO(101, 174, 130, 0.16)),
                ),
              ),
            )
          ],
        ),
        (show)?(widget.sel.compareTo('12:00 - -12:55 PM')>0)?TimeTableSlider(data: widget.data[0], select: now.weekday, sel: widget.sel):TimeTableSlider(data: widget.data[1], select: now.weekday, sel: widget.sel):SizedBox(),
      ],
    );
  }
}
