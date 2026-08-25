import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/models/home/bottom_nav_item.dart';
import 'package:onestop_dev/pages/events/clubs_fest_page.dart';
import 'package:onestop_dev/pages/events/events_home_page.dart';
import 'package:onestop_dev/pages/events_feed/events_appbar.dart';
import 'package:onestop_dev/pages/events_feed/events_screen.dart';
import 'package:onestop_dev/pages/food/food_tab.dart';
import 'package:onestop_dev/pages/home/home_tab.dart';
import 'package:onestop_dev/pages/home/library_helper.dart';
import 'package:onestop_dev/pages/profile/profile_tab.dart';
import 'package:onestop_dev/pages/timetable/timetable_page.dart';
import 'package:onestop_dev/pages/travel/travel.dart';
import 'package:onestop_dev/services/app_shortcuts_service.dart';
import 'package:onestop_dev/services/deep_link_service.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:onestop_dev/widgets/ui/onestop_upgrade.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  static String id = "/home2";

  /// Used by DeepLinkService to signal a tab switch without pushing a new route.
  static final ValueNotifier<int?> pendingTab = ValueNotifier(null);

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int index = 0;

  /// Whether the user is currently in the Events sub-navigation mode.
  bool _isEventsMode = false;

  /// The active sub-tab index within Events mode.
  /// 0 = Events, 1 = Clubs/Fest.
  int _eventsSubIndex = 0;

  bool _showBagReminder = false;
  String _bagReminderMessage = "Reminder: You have your bag in the library";
  bool _isBannedDialogShowing = false;

  static final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(
      name: 'Home',
      selectedIcon: FluentIcons.home_24_filled,
      unselectedIcon: FluentIcons.home_24_regular,
    ),
    BottomNavItem(
      name: 'Travel',
      selectedIcon: FluentIcons.vehicle_bus_24_filled,
      unselectedIcon: FluentIcons.vehicle_bus_24_regular,
    ),
    BottomNavItem(
      name: 'Events',
      selectedIcon: FluentIcons.calendar_24_filled,
      unselectedIcon: FluentIcons.calendar_24_regular,
    ),
    BottomNavItem(
      name: 'Profile',
      selectedIcon: FluentIcons.person_24_filled,
      unselectedIcon: FluentIcons.person_24_regular,
    ),
  ];

  /// Nav items shown when the user is in Events sub-navigation mode.
  static final List<BottomNavItem> _eventsNavItems = [
    BottomNavItem(
      name: 'Home',
      selectedIcon: FluentIcons.arrow_left_24_filled,
      unselectedIcon: FluentIcons.arrow_left_24_regular,
    ),
    BottomNavItem(
      name: 'Events',
      selectedIcon: FluentIcons.calendar_24_filled,
      unselectedIcon: FluentIcons.calendar_24_regular,
    ),
    BottomNavItem(
      name: 'Clubs/Fest',
      selectedIcon: FluentIcons.people_community_24_filled,
      unselectedIcon: FluentIcons.people_community_24_regular,
    ),
  ];

  Future<void> _checkLibrarySlot() async {
    await checkLibrarySlot(
      context: context,
      isMounted: () => mounted,
      onStateUpdate: (showReminder, message) {
        debugPrint(
          "Library slot reminder updated: showReminder=$showReminder, message=$message",
        );
        setState(() {
          _showBagReminder = showReminder;
          if (message != null) {
            _bagReminderMessage = message;
          }
        });
      },
      isBannedDialogShowing: _isBannedDialogShowing,
      setDialogShowing: (isShowing) {
        debugPrint(
          "Library slot dialog showing state updated: isShowing=$isShowing",
        );
        _isBannedDialogShowing = isShowing;
      },
    );
  }

  /// The default home tabs.
  List<Widget> get _homeTabs => [
    HomeTab(
      showBagReminder: _showBagReminder,
      bagReminderMessage: _bagReminderMessage,
      onDismissBagReminder: () {
        setState(() {
          _showBagReminder = false;
        });
      },
      moveToTimeTableView: () {
        navigatorKey.currentState?.pushNamed(TimetablePage.id);
      },
      moveToFoodMenuSection: () {
        setState(() {
          index = 1;
        });
      },
    ),
    const TravelPage(),
    const EventsHomePage(),
    const ProfileTab(),
  ];

  /// The sub-tabs within Events mode.
  static const List<Widget> _eventsTabs = [EventsHomePage(), ClubsFestPage()];

  /// Returns the correct tab list and index based on current mode.
  Widget get _activeTab {
    if (_isEventsMode) {
      return _eventsTabs[_eventsSubIndex];
    }
    return _homeTabs[index];
  }

  /// Needed for bounds-checking in deep link / shortcut handlers.
  List<Widget> get tabs => _homeTabs;

  @override
  void initState() {
    super.initState();
    _checkLibrarySlot();
    WidgetsBinding.instance.addObserver(this);
    actOnPendingShortcut();
    HomePage.pendingTab.addListener(_onPendingTab);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Handle tab argument from deep link (e.g. onestopiitg://home2?tab=1)
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args.containsKey('tab')) {
        final tab = args['tab'] as int?;
        if (tab != null && tab >= 0 && tab < tabs.length) {
          setState(() => index = tab);
        }
      }
      DeepLinkService.instance.handlePendingLink();
    });
  }

  void _onPendingTab() {
    final tab = HomePage.pendingTab.value;
    if (tab != null && tab >= 0 && tab < _homeTabs.length && mounted) {
      setState(() => index = tab);
      HomePage.pendingTab.value = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    HomePage.pendingTab.removeListener(_onPendingTab);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      actOnPendingShortcut();
      _checkLibrarySlot();
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

  /// Enters events mode, showing the events-specific nav bar.
  void _enterEventsMode() {
    setState(() {
      _isEventsMode = true;
      _eventsSubIndex = 0;
    });
  }

  /// Exits events mode, returning to the main home tab.
  void _exitEventsMode() {
    setState(() {
      _isEventsMode = false;
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return OneStopUpgrader(
      child: PopScope(
        canPop: !_isEventsMode,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && _isEventsMode) {
            _exitEventsMode();
          }
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: OColor.gray100,
          key: scaffoldKey,
          appBar:
              _isEventsMode
                  ? null
                  : appBar(
                    context,
                    displayDrawer: false,
                    displayIcon: false,
                    systemUiOverlayStyle: Theme.of(context)
                        .appBarTheme
                        .systemOverlayStyle
                        ?.copyWith(statusBarColor: Colors.transparent),
                  ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final width = constraints.maxWidth;
              return SizedBox(
                height: height,
                width: width,
                child: Stack(
                  children: [
                    Column(children: [Expanded(child: _activeTab)]),
                    Positioned(
                      bottom: Platform.isIOS ? 8 : bottomInset,
                      left: 0,
                      right: 0,
                      child: _bottomNavBar(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    final items = _isEventsMode ? _eventsNavItems : bottomNavItems;
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Events mode (3 items) gets a narrower bar; default mode (4 items)
    // spans most of the screen width. Matches the Figma proportions
    // (~261/390 for events, near-full for default).
    final double navWidth =
        _isEventsMode ? screenWidth * 0.70 : screenWidth - 16;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: navWidth,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(
            Platform.isIOS ? 40 : OCornerRadius.l,
          ),
          boxShadow: [
            BoxShadow(
              color: OColor.black.withValues(alpha: 0.06),
              blurRadius: 9,
              offset: const Offset(0, 6),
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
              items.asMap().entries.map((entry) {
                final int itemIndex = entry.key;
                final BottomNavItem item = entry.value;

                // Determine if this item is currently selected.
                final bool isSelected;
                if (_isEventsMode) {
                  // In events mode: index 0 is "Back" (never highlighted),
                  // index 1 = Events, index 2 = Clubs/Fest.
                  isSelected =
                      itemIndex != 0 && (itemIndex - 1) == _eventsSubIndex;
                } else {
                  isSelected = itemIndex == index;
                }

                return Expanded(
                  child: InkWell(
                    onTap: () => _onNavItemTap(context, itemIndex),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? OColor.green100 : null,
                        borderRadius: BorderRadius.circular(
                          Platform.isIOS ? 40 : OCornerRadius.m,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected
                                ? item.selectedIcon
                                : item.unselectedIcon,
                            color:
                                isSelected ? OColor.green600 : OColor.gray800,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          OText(
                            text: item.name,
                            style: OTextStyle.bodyXSmall.copyWith(
                              color:
                                  isSelected ? OColor.green600 : OColor.gray800,
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
      ),
    );
  }

  /// Handles taps on bottom nav bar items, dispatching differently
  /// based on whether we're in default mode or events mode.
  void _onNavItemTap(BuildContext context, int itemIndex) {
    if (_isEventsMode) {
      // Events mode nav: [Back, Events, Clubs/Fest]
      switch (itemIndex) {
        case 0:
          // "Home" / Back — exit events mode, go to Home.
          _exitEventsMode();
          break;
        case 1:
          // Events tab
          setState(() => _eventsSubIndex = 0);
          break;
        case 2:
          // Clubs/Fest tab
          setState(() => _eventsSubIndex = 1);
          break;
      }
    } else {
      // Default mode nav: [Home, Travel, Events, Profile]
      if (itemIndex == 2) {
        // Tapping "Events" enters events mode.
        _enterEventsMode();
      } else {
        setState(() {
          index = itemIndex;
          context.read<MapBoxStore>().mapController = null;
        });
      }
    }
  }
}
