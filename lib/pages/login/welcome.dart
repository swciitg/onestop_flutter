import 'package:flutter/material.dart';
import 'package:onestop_dev/widgets/login/welcome_header.dart';
import 'package:onestop_kit/onestop_kit.dart';

class WelcomePage extends StatelessWidget {
  static const id = "/welcome";
  final Function setLoading;

  const WelcomePage({super.key, required this.setLoading});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WelcomeHeader(setLoading: setLoading);
  }
}
