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
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<SplashResponse>(
        future: LoginStore().isAlreadyAuthenticated(),
          builder: (context, snapshot){
          if(snapshot.hasData)
            {
              SplashResponse result = snapshot.data!;
              if (result == SplashResponse.authenticated && LoginStore.isProfileComplete){
                return const HomePage();
              } else if(result == SplashResponse.blocked){
                return const BlockedPage();
              }else{
                return const LoginPage();
              }
            }
          else if(snapshot.hasError)
            {
              return const Scaffold();
            }
          else
            {
              //Waiting State
              return Scaffold(
              );
            }
      });
  }
}
