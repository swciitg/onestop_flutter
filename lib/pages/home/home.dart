import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/home/navigation_icons.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/food/food_tab.dart';
import 'package:onestop_dev/pages/home/home_tab.dart';
import 'package:onestop_dev/pages/timetable/timetable.dart';
import 'package:onestop_dev/pages/travel/travel.dart';
import 'package:onestop_dev/services/app_shortcuts_service.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:onestop_dev/widgets/ui/onestop_upgrade.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

import '../../widgets/home/home_drawer.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  static String id = "/home2";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int index = 0;
  final tabs = [
    const HomeTab(),
    const FoodTab(),
    const TravelPage(),
    // const EventsScreenWrapper(),
    const TimeTableTab(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    actOnPendingShortcut();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      actOnPendingShortcut();
    }
  }

  void actOnPendingShortcut() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppShortcutsService.handlePendingShortcutAction((index) {
        setState(() {
          this.index = index;
          context.read<MapBoxStore>().mapController = null;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return OneStopUpgrader(
      child: Scaffold(
        key: scaffoldKey,
        drawer: const HomeDrawer(),
        appBar: appBar(context),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: lGrey,
            labelTextStyle: WidgetStateProperty.all(MyFonts.w500.setColor(kTabText)),
            iconTheme: WidgetStateProperty.all(const IconThemeData(color: kTabText)),
          ),
          child: NavigationBar(
            backgroundColor: kTabBar,
            selectedIndex: index,
            onDestinationSelected:
                (index) => setState(() {
                  this.index = index;
                  context.read<MapBoxStore>().mapController = null;
                }),
            destinations: bottomNavIcons(),
          ),
        ),
        body: SafeArea(
          child:
              index !=
                      0 // Check if index is not 0
                  ? Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: tabs[index])
                  : tabs[index], // No padding if index is 0
        ),
      ),
    );
  }
}
