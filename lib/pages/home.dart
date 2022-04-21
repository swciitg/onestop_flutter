import 'package:flutter/material.dart';
import 'package:onestop_dev/globals.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/pages/food/food_tab.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:onestop_dev/widgets/mapBox.dart';

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
    Center(
        child: Text(
      'Timetable',
      style: MyFonts.extraBold.setColor(kWhite).size(30),
    )),
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
        ));
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
          SizedBox(height: 10,),
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
          Services(),
          SizedBox(
            height: 10,
          ),
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
                      label: "IP Settings", icon: Icons.computer_outlined,routeId:"/ip"),
                  SizedBox(
                    width: 5,
                  ),
                  HomeTabTile(label: "Blogs", icon: Icons.article_outlined,routeId: "/blogs",),
                  SizedBox(
                    width: 5,
                  ),
                  HomeTabTile(
                      label: "Medical Emergency",
                      icon: Icons.medical_services_outlined),
                  SizedBox(
                    width: 5,
                  ),
                  HomeTabTile(
                      label: "Contacts", icon: Icons.contact_mail_outlined),
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

class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kHomeTile,
      ),
      child: Container(
        height: 160,
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
                    'Services',
                    style: MyFonts.medium.size(10).setColor(kWhite),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
                      label: "Rent and Sell", icon: Icons.local_atm_outlined),
                  SizedBox(
                    width: 5,
                  ),
                  HomeTabTile(
                      label: "Shops", icon: Icons.shopping_cart_outlined),
                  SizedBox(
                    width: 5,
                  ),
                  HomeTabTile(label: "Intranet", icon: Icons.language_outlined),
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
                        FlatButton(
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
                                  ? Color.fromRGBO(118, 172, 255, 1)
                                  : Color.fromRGBO(39, 49, 65, 1),
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
                                          ? Color.fromRGBO(39, 49, 65, 1)
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FlatButton(
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
                                  ? Color.fromRGBO(118, 172, 255, 1)
                                  : Color.fromRGBO(39, 49, 65, 1),
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
                                          ? Color.fromRGBO(39, 49, 65, 1)
                                          : Colors.white,
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
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      118, 172, 255, 1)),
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'Starting from Biotech park',
                                    style: TextStyle(color: Colors.grey),
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
