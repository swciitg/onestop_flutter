import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/qr.dart';

// TODO: Make profile picture clickable and redirect to QR
AppBar appBar(BuildContext context, {bool displayIcon = true}) {
  return AppBar(
    backgroundColor: kBackground,
    iconTheme: IconThemeData(color: kAppBarGrey),
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        displayIcon
            ? CircleAvatar(
                child: IconButton(
                  icon: const Icon(
                    FluentIcons.person_24_filled,
                    color: lBlue2,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, QRPage.id);
                  },
                ),
                backgroundColor: kAppBarGrey,
              )
            : CircleAvatar(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: lBlue2),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: kAppBarGrey,
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
        SizedBox(
          width: 35,
          height: 35,
        )
        // CircleAvatar(
        //     backgroundColor: kAppBarGrey,
        //     child: IconButton(
        //       onPressed: () {},
        //       icon: Icon(Icons.notifications),
        //       color: lBlue2,
        //     )),
      ],
    ),
    elevation: 0.0,
  );
}
