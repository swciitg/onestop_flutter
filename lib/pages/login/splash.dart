import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/login/blocked.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  static String id = "/";

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    LoginStore()
        .isAlreadyAuthenticated()
        .then((result) {
      if (result == 0&& LoginStore.isProfileComplete){
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home2', (Route<dynamic> route) => false);
      } else if(result == 2){
        Navigator.of(context).pushNamedAndRemoveUntil(BlockedPage.id, (Route<dynamic> route) => false);
      }else{
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login2', (Route<dynamic> route) => false);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
