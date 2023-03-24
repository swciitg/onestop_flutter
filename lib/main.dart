// ignore_for_file: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/utility/check_last_updated.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/routes.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/notifications_provider.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await checkLastUpdated();
  await checkForNotifications();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token is $fcmToken");
  
  await APIService.createUser(fcmToken ?? '');
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        )
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: kBackground,
            splashColor: Colors.transparent),
        title: 'OneStop 2.0',
        routes: routes,
      ),
    );
  }
}
