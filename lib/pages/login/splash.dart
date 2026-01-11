import 'package:flutter/material.dart';
import 'package:onestop_dev/stores/login_store.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 200, child: Image.asset('assets/images/logo.png')),
            Image.asset('assets/images/logoo.png'),
          ],
        ),
      ),
    );
  }
}
