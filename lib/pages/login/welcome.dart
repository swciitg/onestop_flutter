import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_spaces.dart';
import 'package:onestop_dev/widgets/login/login_button.dart';
import 'package:onestop_dev/widgets/login/welcome_header.dart';
import 'package:onestop_kit/onestop_kit.dart';

class WelcomePage extends StatelessWidget {
  static const id = "/welcome";
  final Function setLoading;

  const WelcomePage({super.key, required this.setLoading});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final dev = (const String.fromEnvironment("ENV")) == "dev";
    return Scaffold(
      body: dev
          ? Banner(
              message: "DEV",
              location: BannerLocation.topEnd,
              child: _body(),
            )
          : _body(),
    );
  }

  SafeArea _body() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/bg_triangle.png'),
                fit: BoxFit.fill,
              )),
              child: const WelcomeHeader(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MySpaces.horizontalScreenPadding),
              child: LoginButton(
                setLoading: setLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
