import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/pages/notifications/notifications.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

AppBar appBar(BuildContext context, {bool displayIcon = true, bool displayDrawer = true}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: false,
    scrolledUnderElevation: 0,
    elevation: 0.0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            displayDrawer
                ? CircleAvatar(
                  backgroundColor: OColor.green100,
                  child: IconButton(
                    icon: Icon(Icons.menu, color: OColor.green600),
                    onPressed: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                )
                : displayIcon
                ? CircleAvatar(
                  backgroundColor: OColor.green100,
                  child: IconButton(
                    icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.green600),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
                : SizedBox.shrink(),
            SizedBox(width: displayIcon ? 8 : 0),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Row(
                      children: [
                        OText(
                          text: 'One',
                          style: OTextStyle.headingLarge.copyWith(
                            color: OColor.gray800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        OText(
                          text: '.',
                          style: OTextStyle.headingLarge.copyWith(color: OColor.green600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // textAlign: TextAlign.start,
            ),
          ],
        ),
        Row(
          children: [
            // Theme toggle button
            Consumer<ThemeStore>(
              builder: (context, themeStore, child) {
                return IconButton(
                  onPressed: () async {
                    await themeStore.toggleTheme();
                  },
                  icon: Icon(
                    themeStore.isLightMode
                        ? FluentIcons.weather_moon_24_regular
                        : FluentIcons.weather_sunny_24_regular,
                    color: OColor.green600,
                  ),
                );
              },
            ),
            // Notification button
            IconButton(
              onPressed: () {
                context.read<CommonStore>().isPersonalNotif = true;
                Navigator.pushNamed(context, NotificationPage.id);
              },
              icon: Icon(FluentIcons.alert_32_regular, color: OColor.green600),
            ),
          ],
        ),
      ],
    ),
  );
}
