import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/notifications/notif_toggle.dart';

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
        title: Text(
          'Notification Settings',
          style: MyFonts.w500,
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
                  await APIService()
                      .updateUserNotifPref(LoginStore.userData['notifPref']);
                } catch (e) {
                  //print(e);
                }
                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Save'))
        ],
      ),
    );
  }
}
