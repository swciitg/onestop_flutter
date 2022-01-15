import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';
import 'package:onestop_dev/globals/mySpaces.dart';
import 'package:onestop_dev/globals/sizeConfig.dart';

class PowerUp extends StatelessWidget {
  const PowerUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = 'Powering up servers at CSE Department!';
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MySpaces.horizontalScreenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 3,
                child:
                Image.asset('assets/images/no_internet_illustration.png'),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: MyFonts.medium.setColor(kGrey).factor(4.39),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
