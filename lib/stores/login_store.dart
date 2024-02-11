import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/enums.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginStore {
  static Map<String, dynamic> userData = {};
  final cookieManager = WebviewCookieManager();
  static bool isGuest = false;
  static bool isProfileComplete = false;

  Future<SplashResponse> isAlreadyAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    Map userInfo = {};
    if (user.containsKey("userInfo")) {
      try {
        userInfo = await APIService().getUserProfile();
      } catch (e) {
        if ((e as DioException).response == null) {
          return SplashResponse.authenticated;
        }
        if ((e).response!.statusCode == 418) {
          return SplashResponse.blocked;
        } else {
          return SplashResponse.authenticated;
        }
      }
      await user.setString('userInfo', jsonEncode(userInfo));
      if (user.containsKey("isProfileComplete")) {
        isProfileComplete = true;
      } else {}
      await saveToUserInfo(user);
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
    final response = await APIService().guestUserLogin();

    await Future.wait([
      saveToPreferences(sharedPrefs, response.data),
      saveToUserInfo(sharedPrefs),
      sharedPrefs.setBool("isProfileComplete", true)
    ]);
  }

  Future<void> saveToPreferences(
      SharedPreferences instance, dynamic data) async {
    await Future.wait([
      instance.setString(
          BackendHelper.accesstoken, data[BackendHelper.accesstoken]),
      instance.setString(
          BackendHelper.refreshtoken, data[BackendHelper.refreshtoken]),
    ]);
    Map userInfo = await APIService().getUserProfile();
    await Future.wait([
      instance.setBool("isGuest", isGuest),
      instance.setString("userInfo", jsonEncode(userInfo)),
    ]);
  }

  Future<void> saveToUserInfo(SharedPreferences instance) async {
    // only called after saving jwt tokens in local storage
    userData = jsonDecode(instance.getString("userInfo")!);
    var fcmToken = await FirebaseMessaging.instance.getToken();
    if (instance.getBool("isGuest") == false) {
      String? deviceToken = instance.getString("deviceToken");
      if (deviceToken == null) {
        instance.setString(
            "deviceToken", fcmToken!); // set the returned fcToken
        await APIService().postUserDeviceToken(fcmToken);
      } else if (deviceToken != fcmToken) {
        // already some token was stored
        await APIService().updateUserDeviceToken({
          "oldToken": deviceToken, // stored token
          "newToken": fcmToken
        });
      }
    } else {
      isGuest = true;
    }
  }

  void logOut(Function navigationPopCallBack) async {
    print("INSIDE LOGOUT");
    await cookieManager.clearCookies();
    SharedPreferences user = await SharedPreferences.getInstance();
    await user.clear();
    userData.clear();
    isGuest = false;
    isProfileComplete = false;
    await LocalStorage.instance.deleteRecordsLogOut();
    navigationPopCallBack();
  }
}
