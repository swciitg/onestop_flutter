import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onestop_dev/globals.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/pages/food/food_tab.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:onestop_dev/widgets/mapBox.dart';
import 'package:onestop_dev/models/timetable.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:provider/provider.dart';
import '../globals/days.dart';

class HomePage extends StatefulWidget {
  static String id = "/home2";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

double lat = userlat;
double long = userlong;

class _HomePageState extends State<HomePage> {
  int index = 0;
  final tabs = [
    HomeTab(),
    FoodTab(),
    TravelPage(),
    TimeTable1(),
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: lGrey,
            labelTextStyle:
                MaterialStateProperty.all(MyFonts.medium.setColor(kTabText)),
            iconTheme:
                MaterialStateProperty.all(IconThemeData(color: kTabText))),
        child: NavigationBar(
          backgroundColor: kTabBar,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() {
            this.index = index;
          }),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              selectedIcon: Icon(
                Icons.home_filled,
                color: lBlue2,
              ),
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_outlined),
              label: 'Food',
              selectedIcon: Icon(
                Icons.restaurant_outlined,
                color: lBlue2,
              ),
            ),
            NavigationDestination(
              icon: Icon(Icons.directions_bus_outlined),
              label: 'Travel',
              selectedIcon: Icon(
                Icons.directions_bus,
                color: lBlue2,
              ),
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'Timetable',
              selectedIcon: Icon(
                Icons.calendar_today,
                color: lBlue2,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: tabs[index],
        ),
      ),
      floatingActionButton: (index == 3)
          ? FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                _showMyDialog();
              },
              child: Icon(Icons.add),
            )
          : SizedBox(),
    );
  }

  Event buildEvent({required String title}) {
    return Event(
      title: title,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(hours: 1)),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey.shade900,
          content: SingleChildScrollView(
              child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  print('assignment');
                  Add2Calendar.addEvent2Cal(
                    buildEvent(title: 'Assignment'),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        child: ImageIcon(
                          AssetImage('assets/images/pencil.png'),
                          color: Color.fromRGBO(212, 227, 255, 100),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Assignmments',
                        style: MyFonts.medium.size(20).setColor(
                              Color.fromRGBO(212, 227, 255, 100),
                            ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  print('exam');
                  Add2Calendar.addEvent2Cal(
                    buildEvent(title: 'Exam'),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        child: ImageIcon(
                          AssetImage('assets/images/exam.png'),
                          color: Color.fromRGBO(212, 227, 255, 100),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Exam',
                        style: MyFonts.medium.size(20).setColor(
                              Color.fromRGBO(212, 227, 255, 100),
                            ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
        );
      },
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedIndex = 0;

  void rebuildParent(int newSelectedIndex) {
    print('Reloaded');
    setState(() {
      selectedIndex = newSelectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          MapBox(
            lat: lat,
            long: long,
            selectedIndex: selectedIndex,
            rebuildParent: rebuildParent,
            istravel: true,
          ),
          SizedBox(
            height: 10,
          ),
          DateCourse(),
          SizedBox(
            height: 10,
          ),
          QuickLinks(),
          SizedBox(
            height: 10,
          ),
          // Services(),
          // SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}

class DateCourse extends StatelessWidget {
  const DateCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                      child: Text('MON',
                          style: MyFonts.medium.size(20).setColor(kWhite))),
                  FittedBox(
                      child: Text(
                    '24',
                    style: MyFonts.extraBold.size(40).setColor(kWhite),
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
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.fromRGBO(101, 174, 130, 0.16)),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 100,
            child: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.green.shade800,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.fromRGBO(101, 174, 130, 0.16)),
          ),
        )
      ],
    );
  }
}

class QuickLinks extends StatelessWidget {
  const QuickLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kHomeTile,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Quick Links',
                    style: MyFonts.medium.size(10).setColor(kWhite),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  HomeTabTile(
                      label: "IP Settings",
                      icon: Icons.computer_outlined,
                      routeId: "/ip"),
                  SizedBox(
                    width: 5,
                  ),
                  HomeTabTile(
                    label: "Blogs",
                    icon: Icons.article_outlined,
                    routeId: "/blogs",
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  HomeTabTile(
                    label: "Lost and Found",
                    icon: Icons.find_in_page_outlined,
                    routeId: "/lostFoundHome",
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  HomeTabTile(
                      label: "Contacts", icon: Icons.contact_mail_outlined, routeId: "/contacto",),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}

// class Services extends StatelessWidget {
//   const Services({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 140,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: kHomeTile,
//       ),
//       child: Container(
//         height: 160,
//         padding: const EdgeInsets.all(4),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: FittedBox(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.all(5),
//                   child: Text(
//                     'Services',
//                     style: MyFonts.medium.size(10).setColor(kWhite),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   SizedBox(
//                     width: 5,
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   HomeTabTile(
//                       label: "Rent and Sell", icon: Icons.local_atm_outlined),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   HomeTabTile(
//                       label: "Shops", icon: Icons.shopping_cart_outlined),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   HomeTabTile(label: "Intranet", icon: Icons.language_outlined),
//                   SizedBox(
//                     width: 5,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class BusTile extends StatelessWidget {
  final time;
  final isLeft;
  const BusTile({Key? key, required this.time, this.isLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      //color: Colors.amberAccent,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(34, 36, 41, 1),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        textColor: Colors.white,
        leading: const CircleAvatar(
          backgroundColor: Color.fromRGBO(255, 227, 125, 1),
          radius: 20,
          child: Icon(
            IconData(
              0xe1d5,
              fontFamily: 'MaterialIcons',
            ),
            color: Color.fromRGBO(39, 49, 65, 1),
          ),
        ),
        title: Text(
          time,
          style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
        trailing: isLeft
            ? const Text(
                'Left',
                style: TextStyle(color: Color.fromRGBO(135, 145, 165, 1)),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
      ),
    );
  }
}

final playerPointsToAdd =
    ValueNotifier<int>(0); //TODO 1st: ValueNotifier declaration

class TravelPage extends StatefulWidget {
  const TravelPage({Key? key}) : super(key: key);
  @override
  State<TravelPage> createState() => _TravelPageState();
}

List<Map<String, dynamic>> BusStops = [
  {
    'name': 'Kameng Bus Stop',
    'lat': 30.000000,
    'long': 60.000000,
    'status': 'left',
    'time': '1:45 PM',
    'distance': '1.4km',
    'ind': 0,
  },
  {
    'name': 'Manas Bus Stop',
    'lat': 40.000000,
    'long': 50.000000,
    'status': 'left',
    'time': '1:45 PM',
    'distance': '1.4km',
    'ind': 1,
  }
];

List<Map<String, dynamic>> Buses = [
  {
    'status': false,
    'time': '1:45 PM',
  }
];

class _TravelPageState extends State<TravelPage> {
  int selectBusesorStops = 0;
  bool isCity = false;
  bool isCampus = false;

  int selectedIndex = 0;

  void rebuildParent(int newSelectedIndex) {
    print('Reloaded');
    setState(() {
      selectedIndex = newSelectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MapBox(
            selectedIndex: selectedIndex,
            lat: lat,
            long: long,
            rebuildParent: rebuildParent,
            istravel: false,
          ),
          SizedBox(
            height: 10,
          ),
          (selectedIndex == 0)
              ? Column(
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectBusesorStops = 0;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                            child: Container(
                              height: 32,
                              width: 83,
                              color: (selectBusesorStops == 0)
                                  ? lBlue2
                                  : kBlueGrey,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /*Icon(
                              IconData(0xe1d5, fontFamily: 'MaterialIcons'),
                              color: (selectBusesorStops == 0)
                                  ? Color.fromRGBO(39, 49, 65, 1)
                                  : Colors.white,
                            ),*/
                                  Text(
                                    "Stops",
                                    style: TextStyle(
                                      color: (selectBusesorStops == 0)
                                          ? kBlueGrey
                                          : kWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectBusesorStops = 1;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                            child: Container(
                              height: 32,
                              width: 83,
                              color: (selectBusesorStops == 1)
                                  ? lBlue2
                                  : kBlueGrey,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /*Icon(
                              IconData(0xe1d5, fontFamily: 'MaterialIcons'),
                              color: (selectBusesorStops == 1)
                                  ? Color.fromRGBO(39, 49, 65, 1)
                                  : Colors.white,
                            ),*/
                                  Text(
                                    "Bus",
                                    style: TextStyle(
                                      color: (selectBusesorStops == 1)
                                          ? kBlueGrey
                                          : kWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    (selectBusesorStops == 0)
                        ? Column(
                            children: BusStops.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isSelected = item['ind'];
                                      lat = item['lat'];
                                      long = item['long'];
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    //color: Colors.amberAccent,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(34, 36, 41, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(
                                          color: (isSelected == item['ind'])
                                              ? Color.fromRGBO(101, 144, 210, 1)
                                              : Color.fromRGBO(34, 36, 41, 1)),
                                    ),
                                    child: ListTile(
                                      textColor: Colors.white,
                                      leading: const CircleAvatar(
                                        backgroundColor:
                                            Color.fromRGBO(255, 227, 125, 1),
                                        radius: 26,
                                        child: Icon(
                                          IconData(
                                            0xe1d5,
                                            fontFamily: 'MaterialIcons',
                                          ),
                                          color: Color.fromRGBO(39, 49, 65, 1),
                                        ),
                                      ),
                                      title: Text(
                                        item['name'],
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1)),
                                      ),
                                      subtitle: Text(
                                        item['distance'],
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                119, 126, 141, 1)),
                                      ),
                                      trailing: (item['status'] == 'left')
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Left',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          135, 145, 165, 1)),
                                                ),
                                                Text(
                                                  item['time'],
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          195, 198, 207, 1)),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              item['time'],
                                              style: TextStyle(color: lBlue2),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : SizedBox(),
                    (selectBusesorStops == 1)
                        ? Column(
                            children: [
                              Container(
                                child: ListTile(
                                  title: Text(
                                    'Campus -> City',
                                    style: TextStyle(color: kWhite),
                                  ),
                                  subtitle: Text(
                                    'Starting from Biotech park',
                                    style: TextStyle(color: kGrey),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isCity = !isCity;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              isCity
                                  ? Column(
                                      children: Buses.map((e) {
                                      return BusTile(
                                        time: e['time'],
                                        isLeft: e['status'],
                                      );
                                    }).toList())
                                  : Container(),
                              Container(
                                child: ListTile(
                                  title: Text(
                                    'City -> Campus',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'Starting from City',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isCampus = !isCampus;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              isCampus
                                  ? Column(
                                      children: Buses.map((e) {
                                      return BusTile(
                                        time: e['time'],
                                        isLeft: e['status'],
                                      );
                                    }).toList())
                                  : Container(),
                            ],
                          )
                        : SizedBox(),
                  ],
                )
              : Column(
                  children: Buses.map((e) {
                  return BusTile(
                    time: e['time'],
                    isLeft: e['status'],
                  );
                }).toList())
        ],
      ),
    );
  }
}

class TimeTable1 extends StatefulWidget {
  static const String id = 'time';
  const TimeTable1({Key? key}) : super(key: key);
  @override
  State<TimeTable1> createState() => _TimeTable1State();
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

class _TimeTable1State extends State<TimeTable1> {
  int select = 0;
  int sel = -1;
  int sele = -1;
  // final Future<Time> timetable = ApiCalling().getTimeTable(roll: context.read<LoginStore>().userData["rollno"]);
  Map<int, List<List<String>>> Data1 = {};
  Map<int, List<List<String>>> Data2 = {};
  @override
  Widget build(BuildContext context) {
    Future<Time> timetable = ApiCalling().getTimeTable(roll: context.read<LoginStore>().userData["rollno"]??"200101095");
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
                                          Text(
                                            Data1[dates[select].weekday]![index]
                                                [2],
                                            style: MyFonts.light
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
                                          // Icon(
                                          //   Icons.location_pin,
                                          //   size: 13,
                                          //   color: Color.fromRGBO(
                                          //       212, 227, 255, 100),
                                          // ),
                                          Text(
                                            Data2[dates[select].weekday]![index]
                                                [2],
                                            style: MyFonts.light
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
    if (now1.hour >= 9 && now1.hour < 10 && now1.minute < 56) {
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

