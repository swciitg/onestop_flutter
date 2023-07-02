import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/notifications/get_notifications.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_dev/widgets/ui/notification_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifsModel {
  String? title;
  String? body;
  String category;
  bool read;
  DateTime time;
  String messageId;

  NotifsModel(
    this.title,
    this.body,
    this.read,
    this.category,
      this.time,
      this.messageId
  );
}

class NotificationPage extends StatefulWidget {
  static String id = "notifications";
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  IconData getIcon(bool readNotif) {
    if (!readNotif) {
      return FluentIcons.circle_24_filled;
    }
    return Icons.brightness_1_outlined;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.reload();
              prefs.remove('notifications');
              setState(() {});
            },
            icon: const Icon(FluentIcons.delete_12_regular),
            label: Text(
              'Clear All',
              style: MyFonts.w300,
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, elevation: 0),
          )
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(FluentIcons.arrow_left_24_regular)),
        title: Text(
          'Notifications',
          style: MyFonts.w500,
        ),
      ),
      body: FutureBuilder<List<NotifsModel>>(
          future: getSavedNotifications(true),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No notifications found',
                    style: MyFonts.w300.setColor(kWhite),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: NotificationTile(
                        notifModel: snapshot.data![index],
                      ),
                    );
                  },
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListShimmer(
                  count: 5,
                )),
              ],
            );
            }
            return Center(
              child: Text(
                'No notifications found',
                style: MyFonts.w300.setColor(kWhite),
              ),
            );
          }),
    );
  }
}
