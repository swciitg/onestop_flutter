import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/pages/notifications/notifications.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:provider/provider.dart';

AppBar appBar(
  BuildContext context, {
  bool displayIcon = true,
}) {
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
                    // FluentIcons.person_24_filled,
                    Icons.menu,
                    color: lBlue2,
                  ),
                  // onPressed: () {
                  //   // Navigator.pushNamed(context, ProfilePage.id);
                  //   // print(ProfileModel.fromJson(LoginStore.userData));
                  //   // print(LoginStore.userData);
                  //   // Navigator.push(context, MaterialPageRoute(builder: (buildContext) => ProfilePage(profileModel: ProfileModel.fromJson(LoginStore.userData),)));
                  // },
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
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
          ]),
          // textAlign: TextAlign.start,
        ),
        CircleAvatar(
            backgroundColor: kAppBarGrey,
            child: IconButton(
              onPressed: () {
                context.read<CommonStore>().isPersonalNotif = true;
                Navigator.pushNamed(context, NotificationPage.id);
              },
              icon: const Icon(
                FluentIcons.alert_24_filled,
                color: lBlue2,
              ),
              color: lBlue2,
            ))
      ],
    ),
    elevation: 0.0,
  );
}
