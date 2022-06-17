import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/my_spaces.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 91,
          child: SafeArea(
            bottom: false,
            top: true,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MySpaces.horizontalScreenPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0),
                              child: Text(
                                'Welcome to',
                                style: MyFonts.w500
                                    .setColor(kWhite),
                              ),
                            ),
                            Text('your OneStop',
                                style: MyFonts.w500
                                    .setColor(kWhite)),
                            Text('solution for all',
                                style: MyFonts.w500
                                    .setColor(kWhite)),
                            Text('things IITG',
                                style: MyFonts.w500
                                    .setColor(kWhite)),
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                        'assets/images/login_illustration.png'),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: Container(),
        ),
      ],
    );
  }
}
