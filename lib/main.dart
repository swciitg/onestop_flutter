import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/utility/check_last_updated.dart';
import 'package:onestop_dev/functions/utility/connectivity.dart';
import 'package:onestop_dev/pages/login/splash.dart';
import 'package:onestop_dev/routes.dart';
import 'package:onestop_dev/services/notifications_service.dart';
import 'package:onestop_dev/services/app_shortcuts_service.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/event_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/medical_timetable_store.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';
import 'package:terminate_restart/terminate_restart.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TerminateRestart.instance.initialize();
  if (await hasInternetConnection()) {
    await Future.wait([
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      checkLastUpdated(),
    ]);
    await NotificationService().initNotifications();
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await AppShortcutsService.initialize();
  await ThemeStore.instance.initTheme();

  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugInvertOversizedImages = false;
    debugInvertOversizedImages = false;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeStore>(create: (_) => ThemeStore()),
        Provider<LoginStore>(create: (_) => LoginStore()),
        Provider<RestaurantStore>(create: (_) => RestaurantStore()),
        Provider<MapBoxStore>(create: (_) => MapBoxStore()),
        Provider<CommonStore>(create: (_) => CommonStore()),
        Provider<TravelStore>(create: (_) => TravelStore()),
        Provider<EventsStore>(create: (_) => EventsStore()),
        Provider<TimetableStore>(create: (_) => TimetableStore()),
        Provider<MedicalTimetableStore>(create: (_) => MedicalTimetableStore()),
      ],
      child: Consumer<ThemeStore>(
        builder: (context, themeStore, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            initialRoute: SplashPage.id,
            theme: themeStore.lightThemeData,
            darkTheme: themeStore.darkThemeData,
            themeMode: themeStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            title: 'OneStop IITG',
            routes: routes,
          );
        },
      ),
    );
  }
}
