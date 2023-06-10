import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:shared_preferences/shared_preferences.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          playSound: true,
          icon: 'notification_icon');
  DarwinNotificationDetails iosNotificationDetails =
      const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
  );
  RemoteNotification? notification = message.notification;

  print("Notification : $notification");
  if (checkNotificationCategory(message.data['category'])) {
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['header'],
      message.data['body'],
      notificationDetails,
    );
  }
  saveNotification(message);
}

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    print('notification payload: $payload');
  }
  // await Navigator.pushNamed(context, HomePage.id);
}

bool checkNotificationCategory(String type) {
  switch (type.toLowerCase()) {
    case "lost":
    case "found":
    case "buy":
    case "sell":
    case "travel":
      return true;
  }
  return false;
}

Future<bool> checkForNotifications() async {
  await FirebaseMessaging.instance.subscribeToTopic('all');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    // onDidReceiveBackgroundNotificationResponse:
    //     onDidReceiveNotificationResponse,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("Here me");
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            playSound: true,
            icon: 'notification_icon');
    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    print("Message is ${message.data}");
    if (checkNotificationCategory(message.data['category'])) {
      await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.data['header'],
        message.data['body'],
        notificationDetails,
      );
    }
    saveNotification(message);
  });

  // Resave list of notifications in case it's initialized to null
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  List<String> notifications = preferences.getStringList('notifications') ?? [];
  preferences.setStringList('notifications', notifications);
  return true;
}

void saveNotification(RemoteMessage message) async {
  Map<String, dynamic> notificationData = message.data;
  DateTime sentTime = message.sentTime ?? DateTime.now();
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  notificationData['time'] = sentTime?.toString() ?? DateTime.now().toString();
  notificationData['read'] = false;
  notificationData['messageId'] = message.messageId;
  String notifJson = jsonEncode(notificationData);
  print("data = $notificationData");
  List<String> notifications = preferences.getStringList('notifications') ?? [];
  if (notifications.length > 15) {
    notifications.removeAt(0);
  }
  notifications.add(notifJson);
  preferences.setStringList('notifications', notifications);
}
