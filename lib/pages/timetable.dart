import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onestop_dev/globals/days.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/timetable.dart';
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
  int sel = -1;
  int sele = -1;
  // final Future<Time> timetable = ApiCalling().getTimeTable(roll: context.read<LoginStore>().userData["rollno"]);
  Map<int, List<List<String>>> Data1 = {};
  Map<int, List<List<String>>> Data2 = {};
  @override
  Widget build(BuildContext context) {
    Future<Time> timetable = ApiCalling().getTimeTable(
        roll: context.read<LoginStore>().userData["rollno"] ?? "200101095");
    determiningSel();
    adjustTime();
    return FutureBuilder<Time>(
      future: timetable,
      builder: (BuildContext context, AsyncSnapshot<Time> snapshot) {
        if (snapshot.hasData) {
          addWidgets(data: snapshot.data!);
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 130,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                select = index;
                              });
                            },
                            child: FittedBox(
                              child: Container(
                                height: 125,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: (select == index)
                                      ? Color.fromRGBO(101, 174, 130, 0.16)
                                      : Colors.transparent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                          child: Text(
                                              kday[dates[index].weekday]!,
                                              style: MyFonts.medium
                                                  .size(20)
                                                  .setColor(kWhite))),
                                      FittedBox(
                                          child: Text(
                                        dates[index].day.toString(),
                                        style: MyFonts.extraBold
                                            .size(40)
                                            .setColor(kWhite),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: Data1[dates[select].weekday]!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: (sel == index)
                                ? Color.fromRGBO(101, 174, 130, 0.16)
                                : Color.fromRGBO(120, 120, 120, 0.16),
                            border: (sel == index)
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
                                        Data1[dates[select].weekday]![index][0],
                                        style: MyFonts.light
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
                                              Data1[dates[select].weekday]![
                                                  index][1],
                                              style: MyFonts.medium
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
                                          Expanded(
                                            child: Text(
                                              Data1[dates[select].weekday]![
                                                  index][2],
                                              style: MyFonts.light
                                                  .size(13)
                                                  .setColor(Color.fromRGBO(
                                                      212, 227, 255, 100)),
                                            ),
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
                    }),
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
                      style: MyFonts.medium.size(12).setColor(Colors.white),
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
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: Data2[dates[select].weekday]!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: (sel == index)
                                ? Color.fromRGBO(101, 174, 130, 0.16)
                                : Color.fromRGBO(120, 120, 120, 0.16),
                            border: (sel == index)
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
                                        Data2[dates[select].weekday]![index][0],
                                        style: MyFonts.light
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
                                              Data2[dates[select].weekday]![
                                                  index][1],
                                              style: MyFonts.medium
                                                  .size(15)
                                                  .setColor(kWhite),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              Data2[dates[select].weekday]![
                                                  index][2],
                                              style: MyFonts.light
                                                  .size(13)
                                                  .setColor(Color.fromRGBO(
                                                      212, 227, 255, 100)),
                                            ),
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
                    }),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          Future.delayed(Duration.zero, () => _reload());
          return Column(
            children: [
              Container(
                height: 130,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              select = index;
                            });
                          },
                          child: FittedBox(
                            child: Container(
                              height: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: (select == index)
                                    ? Color.fromRGBO(101, 174, 130, 0.16)
                                    : Colors.transparent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                        child: Text(kday[dates[index].weekday]!,
                                            style: MyFonts.medium
                                                .size(20)
                                                .setColor(kWhite))),
                                    FittedBox(
                                        child: Text(
                                      dates[index].day.toString(),
                                      style: MyFonts.extraBold
                                          .size(40)
                                          .setColor(kWhite),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
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

  addWidgets({required Time data}) {
    data.courses!.sort((a, b) => a.slot!.compareTo(b.slot!));
    List<List<String>> a1 = [];
    List<List<String>> a2 = [];
    List<List<String>> a3 = [];
    List<List<String>> a4 = [];
    List<List<String>> a5 = [];
    List<List<String>> a11 = [];
    List<List<String>> a21 = [];
    List<List<String>> a31 = [];
    List<List<String>> a41 = [];
    List<List<String>> a51 = [];
    for (int i = 1; i <= 5; i++) {
      for (var v in data.courses!) {
        if (i == 1 && v.slot == 'A')
          a1.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'B')
          a1.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'D')
          a1.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'F')
          a1.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'A1')
          a11.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'B1')
          a11.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'D1')
          a11.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'F1')
          a11.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 2 && v.slot == 'A')
          a2.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'C')
          a2.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'D')
          a2.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'F')
          a2.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'A1')
          a21.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'C1')
          a21.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'D1')
          a21.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'F1')
          a21.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 3 && v.slot == 'A')
          a3.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'C')
          a3.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'E')
          a3.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'G')
          a3.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'A1')
          a31.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'C1')
          a31.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'E1')
          a31.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'G1')
          a31.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 4 && v.slot == 'B')
          a4.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'C')
          a4.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'E')
          a4.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'G')
          a4.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'B1')
          a41.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'C1')
          a41.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'E1')
          a41.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'G1')
          a41.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 5 && v.slot == 'B')
          a5.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'C')
          a5.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'F')
          a5.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'G')
          a5.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'B1')
          a51.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'C1')
          a51.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'F1')
          a51.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'G1')
          a51.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);
      }
    }
    Data1.addAll({1: a1});
    Data1.addAll({2: a2});
    Data1.addAll({3: a3});
    Data1.addAll({4: a4});
    Data1.addAll({5: a5});

    Data2.addAll({1: a11});
    Data2.addAll({2: a21});
    Data2.addAll({3: a31});
    Data2.addAll({4: a41});
    Data2.addAll({5: a51});
  }

  determiningSel() {
    DateTime now1 = DateTime.now();
    if (now1.hour < 10 && now1.minute < 56) {
      setState(() {
        sel = 0;
      });
    } else if (now1.hour >= 10 && now1.hour < 11 && now1.minute < 56) {
      setState(() {
        sel = 1;
      });
    } else if (now1.hour >= 11 && now1.hour < 12 && now1.minute < 56) {
      setState(() {
        sel = 2;
      });
    } else if (now1.hour >= 12 && now1.hour < 13 && now1.minute < 56) {
      setState(() {
        sel = 3;
      });
    } else {
      setState(() {
        sel = -1;
      });
    }

    if (now1.hour >= 14 && now1.hour < 15 && now1.minute < 56) {
      setState(() {
        sele = 0;
      });
    } else if (now1.hour >= 15 && now1.hour < 16 && now1.minute < 56) {
      setState(() {
        sele = 1;
      });
    } else if (now1.hour >= 16 && now1.hour < 17 && now1.minute < 56) {
      setState(() {
        sele = 2;
      });
    } else if (now1.hour >= 17 && now1.hour < 18 && now1.minute < 56) {
      setState(() {
        sele = 3;
      });
    } else {
      setState(() {
        sele = -1;
      });
    }
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

  Future<void> _reload() async {
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
                    style: MyFonts.bold.size(24).setColor(kWhite),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'You\'ve run into the error,please reload.',
                    style: MyFonts.regular.size(14).setColor(Colors.white),
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
                          style: MyFonts.medium.size(14).setColor(Colors.white),
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
}

class ApiCalling {
  Future<Time> getTimeTable({required String roll}) async {
    final response = await post(
      Uri.parse('https://hidden-depths-09275.herokuapp.com/get-my-courses'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({
        "roll_number": roll,
      }),
    );
    if (response.statusCode == 200) {
      return Time.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception(response.statusCode);
    }
  }
}

DateTime now = DateTime.now();
DateTime day1 = now.add(Duration(days: 1));
DateTime day2 = now.add(Duration(days: 2));
DateTime day3 = now.add(Duration(days: 3));
DateTime day4 = now.add(Duration(days: 4));
List<DateTime> dates = [
  now,
  day1,
  day2,
  day3,
  day4,
];
