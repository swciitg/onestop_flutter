import 'dart:convert';

import 'package:onestop_dev/pages/notifications/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<NotifsModel>> getSavedNotifications(bool changeReadStatus) async {
  List<NotifsModel> n = [];
  List<String> newNotifList = [];
  n.clear();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  List<String> result = prefs.getStringList('notifications')!;
  for (String r in result) {
    Map<String, dynamic> notifData = jsonDecode(r);
    print("Notif Data = $notifData");
    n.add(NotifsModel(notifData['header'], notifData['body'],
        notifData['read'], notifData['category'], DateTime.parse(notifData['time']), notifData['messageId']));
    if (changeReadStatus) {
      // Set Read Recipient to True and then save to prefs
      notifData['read'] = true;
    }
    newNotifList.add(jsonEncode(notifData));
  }

  prefs.setStringList('notifications', newNotifList);
  return n.reversed.toList();
}
