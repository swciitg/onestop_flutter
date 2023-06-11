// import 'package:aad_oauth/aad_oauth.dart';
// import 'package:aad_oauth/model/config.dart';
import 'dart:convert';

import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/profile/profile_model.dart';
import 'package:onestop_dev/pages/profile/profile_page.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginStore {
  static Map<String, dynamic> userData = {};
  final cookieManager = WebviewCookieManager();
  static bool isGuest = false;
  // static final Config config = Config(
  //     tenant: '850aa78d-94e1-4bc6-9cf3-8c11b530701c',
  //     clientId: '81f3e9f0-b0fd-48e0-9d36-e6058e5c6d4f',
  //     scope: "user.read openid profile offline_access",
  //     redirectUri: "https://login.live.com/oauth20_desktop.srf");
  //
  // final AadOAuth oauth = AadOAuth(config);

  // Future<void> signInWithMicrosoft(BuildContext context) async {
  //   oauth.setWebViewScreenSize(Rect.fromLTWH(
  //       0,
  //       25,
  //       MediaQuery.of(context).size.width,
  //       MediaQuery.of(context).size.height - 25));
  //   try {
  //     await oauth.login();
  //   } catch (e) {
  //     Navigator.of(context)
  //         .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  //   }
  //   String? accessToken = await oauth.getAccessToken();
  //   if (accessToken != null) {
  //     var response = await http.get(
  //         Uri.parse('https://graph.microsoft.com/v1.0/me'),
  //         headers: {HttpHeaders.authorizationHeader: accessToken});
  //     var data = jsonDecode(response.body);
  //     print(data);
  //     SharedPreferences user = await SharedPreferences.getInstance();
  //     saveToPreferences(user, data);
  //     saveToUserData(user);
  //     Navigator.of(context)
  //         .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  //   }
  // }

  Future<bool> isAlreadyAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    print("inside authentication check");
    if (user.containsKey(BackendHelper.refreshtoken)) {
      print("here");
      await saveToUserInfo(user);
      return true;
    }
    return false;
  }

  bool get isGuestUser {
    return isGuest;
  }

  Future<void> signInAsGuest() async {
    APIService().getBuyPage(1);
    print("GUEST SIGN IN");
    isGuest = true;
    var sharedPrefs = await SharedPreferences.getInstance();
    print(Endpoints.guestLogin);
    print(Endpoints.getHeader());
    final response = await APIService().guestUserLogin();
    print(response.data);
    saveToPreferences(sharedPrefs, response.data);
    saveToUserInfo(sharedPrefs);
    sharedPrefs.setBool("isGuest", true); // guest sign in
  }

  Future<void> saveToPreferences(
      SharedPreferences instance, dynamic data) async {
    print(data);
    print(data.runtimeType);
    print(data[BackendHelper.accesstoken]);
    instance.setString(
        BackendHelper.accesstoken, data[BackendHelper.accesstoken]);
    instance.setString(
        BackendHelper.refreshtoken, data[BackendHelper.refreshtoken]);
    instance.setBool("isGuest", false); // general case
    Map userInfo = await APIService().getUserProfile();
    print(userInfo);
    print(jsonEncode(userInfo));
    instance.setString("userInfo", jsonEncode(userInfo)); // save user profile
  }

  Future<void> saveToUserInfo(SharedPreferences instance) async { // only called after saving jwt tokens in local storage
    print("here");
    userData = jsonDecode(instance.getString("userInfo")!);
    isGuest = instance.getBool("isGuest")!;
    print(userData);
    var fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcm token: ${fcmToken}");
    if (instance.getString("deviceToken") != null) { // already some token was stored
      print("inside if");
      await APIService().updateUserDeviceToken({
        "oldToken": instance.getString("deviceToken"), // stored token
        "newToken": fcmToken
      });
    }
    else{
      print("inside else");
      await APIService().postUserDeviceToken(fcmToken!);
    }
    instance.setString("deviceToken", fcmToken!); // set the returned fcToken
  }

  void logOut(Function navigationPopCallBack) async {
    await cookieManager.clearCookies();
    SharedPreferences user = await SharedPreferences.getInstance();
    print(user.getString("deviceToken")!);
    if(!isGuest) await APIService().logoutUser(user.getString("deviceToken")!); // remove token on logout if not guest
    user.clear();
    userData.clear();
    isGuest = false;
    await LocalStorage.instance.deleteRecordsLogOut();
    navigationPopCallBack();
  }
}
