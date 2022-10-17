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
      icon: '@mipmap/ic_launcher');
  DarwinNotificationDetails iosNotificationDetails= DarwinNotificationDetails(presentAlert: true,presentBadge: true,presentSound: true);
  NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails,iOS: iosNotificationDetails);
  RemoteNotification? notification = message.notification;
  await flutterLocalNotificationsPlugin.show(notification.hashCode,
      "sid", notification!.body,notificationDetails);
  savenotif(notification);
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    print('notification payload: $payload');
  }
  // await Navigator.pushNamed(context, HomePage.id);
}

Future<bool> checkForNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("fcm-token");
  if (token == null) {
    token = await messaging.getToken();
    sharedPreferences.setString("fcm-token", token!);
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestPermission();

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
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse);
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          playSound: true,
          icon: '@mipmap/ic_launcher');
  DarwinNotificationDetails iosNotificationDetails= DarwinNotificationDetails(presentAlert: true,presentBadge: true,presentSound: true);
  NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails,iOS: iosNotificationDetails);

  // FOR IOS
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    print("NOTIFICation : $notification");
    // AndroidNotification android = message.notification!.android!;
    if (notification != null) {
      await flutterLocalNotificationsPlugin.show(notification.hashCode,
          "sid", notification.body, notificationDetails);
    }
    // savenotif(notification);
  });
  return true;
}

void savenotif(RemoteNotification notification) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  String notif = notification.hashCode.toString() +
      notification.title! +
      notification.body!;
  List<String>? notifications =
      preferences.getStringList('notifications') == null
          ? []
          : preferences.getStringList('notifications');
  if (notifications!.length > 14) {
    notifications.removeAt(0);
  }
  notifications.add(notif);
  preferences.setStringList('notifications', notifications);
}
