import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/Notifications/notifications.dart';
import 'package:onestop_dev/pages/profile.dart';

AppBar appBar(BuildContext context, {bool displayIcon = true}) {
  return AppBar(
    backgroundColor: kBackground,
    iconTheme: const IconThemeData(color: kAppBarGrey),
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        displayIcon
            ? CircleAvatar(
                backgroundColor: kAppBarGrey,
                child: IconButton(
                  icon: const Icon(
                    FluentIcons.person_24_filled,
                    color: lBlue2,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, ProfilePage.id);
                  },
                ),
              )
            : CircleAvatar(
                backgroundColor: kAppBarGrey,
                child: IconButton(
                  icon: const Icon(
                    FluentIcons.arrow_left_24_regular,
                    color: lBlue2,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
        RichText(
          text: TextSpan(children: [
            WidgetSpan(
              child: Row(
                children: [
                  Text(
                    "One",
                    textAlign: TextAlign.center,
                    style:
                        MyFonts.w600.size(23).letterSpace(1.0).setColor(lBlue2),
                  ),
                  Text(
                    ".",
                    textAlign: TextAlign.center,
                    style: MyFonts.w500.size(23).setColor(kYellow),
                  ),
                ],
              ),
            ),
            // TextSpan(
            //   text: '.',
            //   style: MyFonts.w500.factor(5).setColor(kYellow),
            // )
          ]),
          // textAlign: TextAlign.start,
        ),
        // Expanded(
        //   child: Image.asset(
        //     'assets/images/AppLogo.png',
        //     // scale: 4,
        //   ),
        // ),
        const SizedBox(
          width: 35,
          height: 35,
        ),
        CircleAvatar(
            backgroundColor: kAppBarGrey,
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Notif.id);
              },
              icon: Icon(Icons.notifications),
              color: lBlue2,
            )),
      ],
    ),
    elevation: 0.0,
  );
}
