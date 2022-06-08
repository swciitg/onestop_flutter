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
                    Icons.account_circle,
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
          text: TextSpan(
              text: 'One',
              style: MyFonts.medium
                  .factor(4.39)
                  .letterSpace(1.0)
                  .setColor(lBlue2),
              children: [
                TextSpan(
                  text: '.',
                  style: MyFonts.medium.factor(5.85).setColor(kYellow),
                )
              ]),
        ),
        SizedBox(width: 35, height: 35,)
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
