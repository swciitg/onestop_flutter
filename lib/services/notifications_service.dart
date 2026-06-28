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
    debugPrint("[NotifService] handleMessage called, message: ${message?.messageId}");
    if (message == null) return;
    debugPrint("[NotifService] handleMessage data: ${message.data}");
    debugPrint("[NotifService] handleMessage notification: ${message.notification?.title} - ${message.notification?.body}");
  }

  Future<void> foregroundMessageHandler(RemoteMessage message) async {
    debugPrint("[NotifService] foregroundMessageHandler called");
    debugPrint("[NotifService] messageId: ${message.messageId}");
    debugPrint("[NotifService] data: ${message.data}");
    final notification = message.notification;
    debugPrint("[NotifService] notification: ${notification?.title} - ${notification?.body}");
    if (notification == null) {
      debugPrint("[NotifService] notification is null, skipping local notification");
      return;
    }
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
    debugPrint("[NotifService] Showing local notification...");
    try {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: jsonEncode(message.toMap()),
      );
      debugPrint("[NotifService] Local notification shown");
    } catch (e) {
      debugPrint("[NotifService] Error showing local notification: $e");
    }
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

    final platform =
        _localNotifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> _initPushNotifications() async {
    debugPrint("[NotifService] Setting foreground presentation options...");
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint("[NotifService] Foreground presentation options set");

    final initialMsg = await _firebaseMessaging.getInitialMessage();
    debugPrint("[NotifService] Initial message: ${initialMsg?.messageId}");
    handleMessage(initialMsg);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("[NotifService] onMessageOpenedApp: ${message.messageId}");
      handleMessage(message);
    });
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("[NotifService] onMessage received: ${message.messageId}");
      foregroundMessageHandler(message);
    });
    debugPrint("[NotifService] Push notification listeners registered");
  }

  Future<void> initNotifications() async {
    debugPrint("[NotifService] initNotifications started");
    final settings = await _firebaseMessaging.requestPermission();
    debugPrint("[NotifService] Permission status: ${settings.authorizationStatus}");

    // On iOS, FCM needs the APNs token first. Log it to verify APNs is working.
    try {
      final apnsToken = await _firebaseMessaging.getAPNSToken();
      debugPrint("[NotifService] APNs token: $apnsToken");
      if (apnsToken == null) {
        debugPrint("[NotifService] WARNING: APNs token is null — FCM won't receive messages on iOS without it");
      }
    } catch (e) {
      debugPrint("[NotifService] Error getting APNs token: $e");
    }

    try {
      final token = await _firebaseMessaging.getToken();
      debugPrint("[NotifService] FirebaseMessaging Token: $token");
    } catch (e) {
      debugPrint("[NotifService] Error getting FirebaseMessaging Token: $e");
    }

    _firebaseMessaging.onTokenRefresh.listen((token) {
      debugPrint("[NotifService] FCM token refreshed: $token");
    });

    await _initPushNotifications();
    await _initLocalNotifications();
    debugPrint("[NotifService] initNotifications complete");

    // Resave list of notifications in case it's initialized to null
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    List<String> notifications = preferences.getStringList('notifications') ?? [];
    preferences.setStringList('notifications', notifications);
  }
}
