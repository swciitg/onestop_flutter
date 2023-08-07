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
  // bool lost = LoginStore.userData['notifPref'][NotificationCategories.lost]!;
  // bool found = LoginStore.userData['notifPref'][NotificationCategories.found]!;
  // bool cabSharing= LoginStore.userData['notifPref'][NotificationCategories.cabSharing]!;
  // bool announcement = LoginStore.userData['notifPref'][NotificationCategories.announcement]!;
  @override
  Widget build(BuildContext context) {
    print(LoginStore.userData['notifPref']);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        title:  Text('Notification Settings',
        style: MyFonts.w500,
        ),
      ),
      body:  ListView(
        children: [
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
