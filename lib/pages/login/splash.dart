import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/enums.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/pages/login/blocked.dart';
import 'package:onestop_dev/pages/login/login.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:shimmer/shimmer.dart';

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
      if (result == SplashResponse.authenticated && LoginStore.isProfileComplete){
        Navigator.of(context).pushNamedAndRemoveUntil(HomePage.id, (Route<dynamic> route) => false);
      }
      else if(result == SplashResponse.blocked){
        Navigator.of(context).pushNamedAndRemoveUntil(BlockedPage.id, (Route<dynamic> route) => false);
      }
      else {
        Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.id, (Route<dynamic> route) => false);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           SizedBox(
             width: 200,
               child: Image.asset('assets/images/logo.png')),
            Image.asset('assets/images/logoo.png'),
          ],
        ),
      ),
    );
  }
}
