import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class NotifsModel {
  String? hashcode;
  String? title;
  String? body;
  bool read;

  NotifsModel(
    this.hashcode,
    this.title,
    this.body,
    this.read,
  );
}

class NotificationPage extends StatefulWidget {
  static String id = "notifications";
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Widget _getLoadingIndicator() {
    return Expanded(
      child: Shimmer.fromColors(
          period: const Duration(seconds: 1),
          baseColor: kHomeTile,
          highlightColor: lGrey,
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (_, __) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                          color: kBlack,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    // Divider(
                    //   thickness: 1.5,
                    //   color: kTabBar,
                    // ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  List<NotifsModel> n = [];
  Future<List<NotifsModel>> getDetails() async {
    List<String> newNotifList = [];
    n.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    List<String> result = prefs.getStringList('notifications')!;
    for (String r in result) {
      Map<String, dynamic> notifData = jsonDecode(r);
      print("Notif Data = $notifData");
      n.add(NotifsModel(
          null, notifData['header'], notifData['body'], notifData['read']));
      // Set Read Recipient to True and then save to prefs
      notifData['read'] = true;
      newNotifList.add(jsonEncode(notifData));
    }

    prefs.setStringList('notifications', newNotifList);
    return n.reversed.toList();
  }

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
          future: getDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              getIcon(snapshot.data![index].read),
                              color: kBlue,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              snapshot.data![index].title ?? " ",
                              style: MyFonts.w400.setColor(kWhite),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(children: [
                          Icon(
                            getIcon(snapshot.data![index].read),
                            color: Colors.transparent,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Description',
                            style: MyFonts.w300.setColor(kWhite),
                          )
                        ])
                      ],
                    ),
                  );
                },
              );
            }
            return Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              color: Colors.black.withOpacity(0.8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getLoadingIndicator(),
                ],
              ),
            );
          }),
    );
  }
}
