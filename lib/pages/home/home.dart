import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/home/action_button.dart';
import 'package:onestop_dev/functions/home/navigation_icons.dart';
import 'package:onestop_dev/functions/timetable/show_dialog.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/pages/food/food_tab.dart';
import 'package:onestop_dev/pages/home/home_tab.dart';
import 'package:onestop_dev/pages/timetable/timetable.dart';
import 'package:onestop_dev/pages/travel/travel.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';

class HomePage extends StatefulWidget {
  static String id = "/home2";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final tabs = [
    HomeTab(),
    FoodTab(),
    TravelPage(),
    TimeTableTab(),
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
            MaterialStateProperty.all(MyFonts.w500.setColor(kTabText)),
            iconTheme:
            MaterialStateProperty.all(IconThemeData(color: kTabText))),
        child: NavigationBar(
          backgroundColor: kTabBar,
          selectedIndex: index,
          onDestinationSelected: (index) =>
              setState(() {
                this.index = index;
              }),
          destinations: bottomNavIcons(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: tabs[index],
        ),
      ),
      floatingActionButton: homeActionButton(context,index),
    );
  }
}
