import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/notifications/notif_toggle.dart';
import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool lost = LoginStore.notifData["lost"]!;
  bool found = LoginStore.notifData["found"]!;
  bool cab= LoginStore.notifData["cab sharing"]!;
  bool announcement = LoginStore.notifData["announcement"]!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        title:  Text('Notification Settings',
        style: MyFonts.w500,
        ),
      ),
      body:  Column(
        children: [
          NotifToggle(text: NotificationCategories.announcement),
          NotifToggle(text: NotificationCategories.cabSharing),
          NotifToggle(text: NotificationCategories.lost),
          NotifToggle(text: NotificationCategories.found),
          NotifToggle(text: NotificationCategories.buy),
          NotifToggle(text: NotificationCategories.sell),
        ],
      ),
    );
  }
}
