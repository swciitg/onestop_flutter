import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_spaces.dart';
import 'package:onestop_dev/widgets/login/login_button.dart';
import 'package:onestop_dev/widgets/login/welcome_header.dart';

import '../../globals/size_config.dart';

class WelcomePage extends StatelessWidget {
  static String id = "/login2";
  // final Function setLoading;
  const WelcomePage({Key? key, 
  // required this.setLoading
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: 
      SafeArea(
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
                padding: EdgeInsets.symmetric(
                    horizontal: MySpaces.horizontalScreenPadding
                    ),
                child: const LoginButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
