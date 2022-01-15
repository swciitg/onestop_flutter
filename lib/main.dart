import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/home.dart';
import 'package:onestop_dev/pages/home_sketch.dart';
import 'package:onestop_dev/pages/login.dart';
import 'package:onestop_dev/pages/splash.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Timetable Admin',
        initialRoute: '/',
        routes: {
          SplashPage.id: (context) => const SplashPage(),
          HomePage.id: (context) => const HomePage(),
          LoginPage.id: (context) => const LoginPage(),
          HomePageSketch.id: (context) => const HomePageSketch(),
        },
      ),
    );


  }
}

