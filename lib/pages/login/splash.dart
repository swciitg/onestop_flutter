import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_ui/index.dart';

class SplashPage extends StatefulWidget {
  static String id = "/";

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await LoginStore().checkAuthenticationStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.green500,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              child:
                  ThemeStore.instance.isDarkMode
                      ? Image.asset('assets/images/app_logo_dark.png')
                      : Image.asset('assets/images/app_logo_light.png'),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                height: 40,
                colorFilter: ColorFilter.mode(OColor.white, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
