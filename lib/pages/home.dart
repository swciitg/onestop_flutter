import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static String id = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Logged In'),
        ],
      ),
    );
  }
}
