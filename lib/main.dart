import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/utility/check_last_updated.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/routes.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await checkLastUpdated();
  runApp(const MyApp());
}
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

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
        Provider<TimetableStore>(
          create: (_) => TimetableStore(),
        ),
        Provider<MapBoxStore>(
          create: (_) => MapBoxStore(),
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
