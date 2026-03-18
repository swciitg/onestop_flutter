import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/services/app_icon_service.dart';
import 'package:onestop_dev/widgets/login/welcome_header.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';

class WelcomePage extends StatefulWidget {
  static const id = "/welcome";
  final Function setLoading;

  const WelcomePage({super.key, required this.setLoading});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    final iconName = ThemeStore.instance.isDarkMode ? 'dark' : 'light';
    AppIconService.setIcon(iconName);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final dev = (const String.fromEnvironment("ENV")) == "dev";
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body:
          dev
              ? Banner(
                message: "DEV",
                location: BannerLocation.topEnd,
                child: _body(),
              )
              : _body(),
    );
  }

  SafeArea _body() {
    return SafeArea(child: WelcomeHeader(setLoading: widget.setLoading));
  }
}
