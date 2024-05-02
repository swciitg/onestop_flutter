import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:upgrader/upgrader.dart';

class OneStopUpgraderMessages extends UpgraderMessages {
  @override
  String get title => 'OneStop Update Available';
  @override
  String get body =>
      'OneStop v{{currentAppStoreVersion}} is now available. You are on a previous version - v{{currentInstalledVersion}}';
}

class OneStopUpgrader extends StatelessWidget {
  final Widget child;
  const OneStopUpgrader({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          dialogTheme: DialogTheme(
            backgroundColor: kBackground,
            titleTextStyle: MyFonts.w600.setColor(lBlue).size(20),
            contentTextStyle: MyFonts.w400.setColor(lBlue),
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: lBlue2, textStyle: MyFonts.w600))),
      child: UpgradeAlert(
          upgrader: Upgrader(
            countryCode: 'IN',
            durationUntilAlertAgain: const Duration(hours: 1),
            showIgnore: false,
            messages: OneStopUpgraderMessages(),
          ),
          child: child),
    );
  }
}
