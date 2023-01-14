import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/home/action_button.dart';
import 'package:onestop_dev/functions/home/navigation_icons.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/pages/food/food_tab.dart';
import 'package:onestop_dev/pages/home/home_tab.dart';
import 'package:onestop_dev/pages/timetable/timetable.dart';
import 'package:onestop_dev/pages/travel/travel.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'dart:io' show Platform;
class OneStopUpgraderMessages extends UpgraderMessages {
  @override
  String get title => 'OneStop Update Available';
  @override
  String get body => 'OneStop v{{currentAppStoreVersion}} is now available. You are on a previous version - v{{currentInstalledVersion}}';
  // @override
  // String get body => 'OneStop v{{currentAppStoreVersion}} is now available. You are on a previous version - v{{currentInstalledVersion}} \n\nNote: ${Platform.isIOS ? 'AppStore' : 'PlayStore'} may sometimes take time to display the "Update" button. Try again later if you are unable to update at the moment.';

}

void tryFunc() async {
  var ps = PlayStoreSearchAPI();
  var res = await ps.lookupById('com.swciitg.onestop2');
  if (res!=null) {
    var resp = PlayStoreResults.redesignedReleaseNotes(res);
    print("notes = $resp");

  }
}

class HomePage extends StatefulWidget {
  static String id = "/home2";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final tabs = [
    const HomeTab(),
    const FoodTab(),
    const TravelPage(),
    const TimeTableTab(),
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    tryFunc();
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: DialogTheme(
          backgroundColor: kBackground,
          titleTextStyle: MyFonts.w600.setColor(lBlue).size(20),
          contentTextStyle: MyFonts.w400.setColor(lBlue),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: lBlue2,
            textStyle: MyFonts.w600
          )
        )
      ),
      child: UpgradeAlert(
        upgrader: Upgrader(
          countryCode: 'IN',
          durationUntilAlertAgain: const Duration(hours: 1),
          debugDisplayAlways: true,
          showIgnore: false,
          messages: OneStopUpgraderMessages(),
          debugLogging: true,
        ),
        child: Provider(
          create: (_) => TimetableStore(),
          child: Scaffold(
            appBar: appBar(context),
            bottomNavigationBar: NavigationBarTheme(
              data: NavigationBarThemeData(
                  indicatorColor: lGrey,
                  labelTextStyle:
                      MaterialStateProperty.all(MyFonts.w500.setColor(kTabText)),
                  iconTheme: MaterialStateProperty.all(
                      const IconThemeData(color: kTabText))),
              child: NavigationBar(
                backgroundColor: kTabBar,
                selectedIndex: index,
                onDestinationSelected: (index) => setState(() {
                  this.index = index;
                  context.read<MapBoxStore>().mapController = null;
                }),
                destinations: bottomNavIcons(),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: tabs[index],
              ),
            ),
            floatingActionButton: homeActionButton(context, index),
          ),
        ),
      ),
    );
  }
}
