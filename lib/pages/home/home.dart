import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/home/bottom_nav_item.dart';
import 'package:onestop_dev/pages/food/food_tab.dart';
import 'package:onestop_dev/pages/home/home_tab.dart';
import 'package:onestop_dev/pages/profile/profile_tab.dart';
import 'package:onestop_dev/pages/timetable/timetable_page.dart';
import 'package:onestop_dev/pages/travel/travel.dart';
import 'package:onestop_dev/services/app_shortcuts_service.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:onestop_dev/widgets/ui/onestop_upgrade.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  static String id = "/home2";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int index = 0;
  late List<Widget> tabs;

  static final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(
      name: 'Home',
      selectedIcon: FluentIcons.home_24_filled,
      unselectedIcon: FluentIcons.home_24_regular,
    ),
    BottomNavItem(
      name: 'Food',
      selectedIcon: FluentIcons.food_24_filled,
      unselectedIcon: FluentIcons.food_24_regular,
    ),
    BottomNavItem(
      name: 'Travel',
      selectedIcon: FluentIcons.vehicle_bus_24_filled,
      unselectedIcon: FluentIcons.vehicle_bus_24_regular,
    ),
    BottomNavItem(
      name: 'Profile',
      selectedIcon: FluentIcons.person_24_filled,
      unselectedIcon: FluentIcons.person_24_regular,
    ),
  ];
  @override
  @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     actOnPendingShortcut();
  //   }
  // }
  // void actOnPendingShortcut() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     AppShortcutsService.handlePendingShortcutAction((index) {
  //       setState(() {
  //         this.index = index;
  //         context.read<MapBoxStore>().mapController = null;
  //       });
  //     });
  //   });
  // }
  @override
  void initState() {
    super.initState();
    tabs = [
      HomeTab(
        moveToTimeTableView: () {
          Navigator.pushNamed(context, TimetablePage.id);
        },
        moveToFoodMenuSection: () {
          setState(() {
            index = 1;
          });
        },
      ),
      const FoodTab(),
      const TravelPage(),
      // const EventsScreenWrapper(),
      const ProfileTab(),
    ];
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
        backgroundColor: OColor.gray100,

        key: scaffoldKey,
        appBar: appBar(context, displayDrawer: false, displayIcon: false),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;
            return SizedBox(
              height: height,
              width: width,
              child: Stack(
                children: [
                  tabs[index],
                  Positioned(bottom: 0, left: 0, right: 0, child: _bottomNavBar(context)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(Platform.isIOS ? 40 : OCornerRadius.l),
        boxShadow: [
          BoxShadow(
            color: OColor.black.withValues(alpha: 0.06),
            blurRadius: 9,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: OColor.black.withValues(alpha: 0.03),
            blurRadius: 17,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: OColor.black.withValues(alpha: 0.02),
            blurRadius: 23,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children:
            bottomNavItems.asMap().entries.map((entry) {
              final int itemIndex = entry.key;
              final BottomNavItem item = entry.value;

              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      index = itemIndex;
                      context.read<MapBoxStore>().mapController = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: index == itemIndex ? OColor.green100 : null,
                      borderRadius: BorderRadius.circular(Platform.isIOS ? 40 : OCornerRadius.m),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          index == itemIndex ? item.selectedIcon : item.unselectedIcon,
                          color: index == itemIndex ? OColor.green600 : OColor.gray800,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        OText(
                          text: item.name,
                          style: OTextStyle.bodyXSmall.copyWith(
                            color: index == itemIndex ? OColor.green600 : OColor.gray800,
                            letterSpacing: 0.48,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
