import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/repository/api_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/notifications/notif_toggle.dart';
import 'package:onestop_kit/onestop_kit.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              FluentIcons.arrow_left_24_regular,
              color: kWhite2,
            )),
        title: Text(
          'Notification Settings',
          style: MyFonts.w500.setColor(kWhite),
        ),
      ),
      body: Column(
        children: [
          NotifToggle(text: NotificationCategories.cabSharing),
          NotifToggle(text: NotificationCategories.lost),
          NotifToggle(text: NotificationCategories.found),
          NotifToggle(text: NotificationCategories.buy),
          NotifToggle(text: NotificationCategories.sell),
          ElevatedButton(
            onPressed: () async {
              if (isLoading) {
                return;
              }
              setState(() {
                isLoading = true;
              });
              try {
                await APIRepository()
                    .updateUserNotifPref(LoginStore.userData['notifPref']);
              } catch (e) {
                //print(e);
              }
              setState(() {
                isLoading = false;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: kGrey9),
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    'Save',
                    style: MyFonts.w500.setColor(lBlue),
                  ),
          )
        ],
      ),
    );
  }
}
