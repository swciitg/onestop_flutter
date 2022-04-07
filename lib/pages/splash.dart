import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/stores/login_store.dart';

class SplashPage extends StatefulWidget {
  static String id = "/";

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<LoginStore>(context, listen: false)
        .isAlreadyAuthenticated()
        .then((result) {
      if (result) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home2', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
