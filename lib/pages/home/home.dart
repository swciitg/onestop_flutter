import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/home/navigation_icons.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
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
import 'package:dio/dio.dart';

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
  bool _showBagReminder = false;
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
    _checkLibrarySlot();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      actOnPendingShortcut();
      _checkLibrarySlot();
    }
  }

  Future<void> _checkLibrarySlot() async {
    try {
      final user = OneStopUser.fromJson(LoginStore.userData);
      const baseUrl = String.fromEnvironment("LIB_TOKEN_BASE_URL");

      log('$baseUrl/slot/${user.rollNo}');
      final response = await Dio().get(
        '$baseUrl/slot/${user.rollNo}',
        options: Options(
          headers: {
            "Authorization": "Bearer ${await AuthUserHelpers.getAccessToken()}",
            "Content-Type": "application/json",
            'security-key': Endpoints.apiSecurityKey,
          },
        ),
      );

      log("Library slot response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        if (mounted) {
          // TODO: Check if the user has a library slot after backend ready
          final isBagPresent = true; //data['slotId'] != null;
          context.read<CommonStore>().setBagInLibrary(isBagPresent);
          setState(() {
            _showBagReminder = isBagPresent;
          });
        }
      }
    } catch (e) {
      debugPrint("Error checking library slot: $e");
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
            labelTextStyle: WidgetStateProperty.all(
              MyFonts.w500.setColor(kTabText),
            ),
            iconTheme: WidgetStateProperty.all(
              const IconThemeData(color: kTabText),
            ),
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
          child: Column(
            children: [
              if (_showBagReminder)
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Reminder: You have your bag in the library",
                            style: MyFonts.w500.setColor(kBlack),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child:
                    index !=
                            0 // Check if index is not 0
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: tabs[index],
                        )
                        : tabs[index], // No padding if index is 0
              ),
            ],
          ),
        ),
      ),
    );
  }
}
