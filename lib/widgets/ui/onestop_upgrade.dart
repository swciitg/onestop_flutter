import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';
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

  const OneStopUpgrader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: DialogThemeData(
          backgroundColor: OColor.white,
          titleTextStyle: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
          contentTextStyle: OTextStyle.bodyMedium.copyWith(color: OColor.gray600),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: OColor.green600,
            textStyle: OTextStyle.labelMedium,
          ),
        ),
      ),
      child: UpgradeAlert(
        upgrader: Upgrader(
          countryCode: 'IN',
          durationUntilAlertAgain: const Duration(hours: 1),
          messages: OneStopUpgraderMessages(),
        ),
        showIgnore: false,
        child: child,
      ),
    );
  }
}
