// ignore_for_file: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/utility/check_last_updated.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/pages/login/splash.dart';
import 'package:onestop_dev/routes.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/notifications_provider.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    checkLastUpdated(),
  ]);
  await Future.wait([
    checkForNotifications(),
    FirebaseMessaging.instance.getToken(),
  ]);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("IN MY APP");
    debugInvertOversizedImages = true;
    return MultiProvider(
      providers: [
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        ),
        Provider<RestaurantStore>(
          create: (_) => RestaurantStore(),
        ),
        Provider<MapBoxStore>(
          create: (_) => MapBoxStore(),
        ),
        Provider<CommonStore>(
          create: (_) => CommonStore(),
        ),
        Provider<TravelStore>(
          create: (_) => TravelStore(),
        ),
        Provider<TimetableStore>(
          create: (_) => TimetableStore(),
        )
      ],
      child: MaterialApp(
          navigatorKey: navigatorKey,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          initialRoute: SplashPage.id,
          theme: ThemeData(
              scaffoldBackgroundColor: kBackground,
              splashColor: Colors.transparent),
          title: 'OneStop 2.0',
          routes: routes),
    );
  }
}
