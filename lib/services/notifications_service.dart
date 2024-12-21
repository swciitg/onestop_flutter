import 'dart:async';
import 'dart:convert';

import "package:firebase_messaging/firebase_messaging.dart";
import 'package:flutter/material.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  debugPrint("Received message in background!");
  debugPrint("Message data: ${message.data}");
}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.high,
    playSound: true,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  Future<void> foregroundMessageHandler(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        importance: Importance.high,
        channelDescription: _androidChannel.description,
        icon: '@drawable/notification_icon',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
      payload: jsonEncode(message.toMap()),
    );
  }

  Future<void> _initLocalNotifications() async {
    const iOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const android = AndroidInitializationSettings('@drawable/notification_icon');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(settings);

    final platform = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> _initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final initialMsg = await _firebaseMessaging.getInitialMessage();
    handleMessage(initialMsg);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    FirebaseMessaging.onMessage.listen(foregroundMessageHandler);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    try {
      await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint("Error getting FirebaseMessaging Token: $e");
    }

    await _initPushNotifications();
    await _initLocalNotifications();

    // Resave list of notifications in case it's initialized to null
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    List<String> notifications = preferences.getStringList('notifications') ?? [];
    preferences.setStringList('notifications', notifications);
  }
}
