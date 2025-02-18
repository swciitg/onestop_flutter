import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:onestop_dev/functions/utility/connectivity.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/enums.dart';
import 'package:onestop_dev/repository/notification_repository.dart';
import 'package:onestop_dev/repository/user_repository.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginStore {
  static Map<String, dynamic> userData = {};
  final cookieManager = WebViewCookieManager();
  static bool isGuest = false;
  static bool isProfileComplete = false;

  Future<SplashResponse> isAlreadyAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    Map userInfo = {};
    if (user.containsKey("userInfo")) {
      if (await hasInternetConnection()) {
        try {
          userInfo = await UserRepository().getUserProfile();
        } catch (e) {
          if ((e as DioException).response == null) {
            return SplashResponse.authenticated;
          }
          if (e.response!.statusCode == 418) {
            return SplashResponse.blocked;
          } else {
            return SplashResponse.authenticated;
          }
        }
        await user.setString('userInfo', jsonEncode(userInfo));

        await saveToUserInfo(user);
      } else {
        userData = jsonDecode(user.getString('userInfo') ?? "");
      }
      if (user.containsKey("isProfileComplete")) {
        isProfileComplete = true;
      }
      return SplashResponse.authenticated;
    }
    return SplashResponse.notAuthenticated;
  }

  bool get isGuestUser {
    return isGuest;
  }

  Future<void> signInAsGuest() async {
    isGuest = true;
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    final response = await UserRepository().guestUserLogin();

    await Future.wait([
      saveTokensToPrefs(sharedPrefs, response.data),
      saveToUserInfo(sharedPrefs),
      sharedPrefs.setBool("isProfileComplete", true)
    ]);
  }

  Future<void> saveTokensToPrefs(SharedPreferences instance, Map data) async {
    await Future.wait([
      instance.setString(
          BackendHelper.accesstoken, data[BackendHelper.accesstoken]),
      instance.setString(
          BackendHelper.refreshtoken, data[BackendHelper.refreshtoken]),
    ]);
    Map userInfo = await UserRepository().getUserProfile();
    await Future.wait([
      instance.setBool("isGuest", isGuest),
      instance.setString("userInfo", jsonEncode(userInfo)),
    ]);
  }

  Future<void> saveToUserInfo(SharedPreferences instance) async {
    // only called after saving jwt tokens in local storage
    userData = jsonDecode(instance.getString("userInfo")!);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    Logger().i("FCM Token: $fcmToken");
    if (instance.getBool("isGuest") == false) {
      String? deviceToken = instance.getString("deviceToken");
      if (deviceToken == null) {
        instance.setString(
            "deviceToken", fcmToken!); // set the returned fcToken
        await NotificationRepository().postFCMToken(fcmToken);
      } else if (deviceToken != fcmToken) {
        // already some token was stored
        await NotificationRepository().updateFCMToken({
          "oldToken": deviceToken, // stored token
          "newToken": fcmToken
        });
      }
    } else {
      isGuest = true;
    }
  }

  void logOut(Function navigationPopCallBack) async {
    Logger().i("INSIDE LOGOUT");
    await clearAppData();
    navigationPopCallBack();
  }

  Future<void> clearAppData() async {
    await cookieManager.clearCookies();
    SharedPreferences user = await SharedPreferences.getInstance();
    await user.clear();
    userData.clear();
    isGuest = false;
    isProfileComplete = false;
    await LocalStorage.instance.deleteRecordsLogOut();
  }
}
