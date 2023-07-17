// import 'package:aad_oauth/aad_oauth.dart';
// import 'package:aad_oauth/model/config.dart';
import 'dart:convert';

import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginStore {
  static Map<String, dynamic> userData = {};
  static Map<String, bool> notifData = {};
  final cookieManager = WebviewCookieManager();
  static bool isGuest = false;
  static bool isProfileComplete=false;

  static Future<void> updateNotifPref(String key)
  async {
    notifData[key] = !notifData[key]!;
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString('notifInfo', jsonEncode(notifData));
  }

  Future<bool> isAlreadyAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    print("inside authentication check");
    if (user.containsKey("userInfo")) {
      print("here");
      if(user.containsKey("isProfileComplete")){
        print("PROFILE IS COMPLETE");
        isProfileComplete=true;
      }
      else{
        print("PROFILE IS INCOMPLETE");
      }
      print(await user.containsKey("userInfo"));
      await saveToUserInfo(user);
      return true;
    }
    return false;
  }

  bool get isGuestUser {
    return isGuest;
  }

  Future<void> signInAsGuest() async {
    print("GUEST SIGN IN");
    isGuest = true;
    var sharedPrefs = await SharedPreferences.getInstance();
    print(Endpoints.guestLogin);
    print(Endpoints.getHeader());
    final response = await APIService().guestUserLogin();
    print(response.data);
    await saveToPreferences(sharedPrefs, response.data);
    await saveToUserInfo(sharedPrefs);
    await sharedPrefs.setBool("isProfileComplete", true); // profile is complete for guest
  }

  Future<void> saveToPreferences(
      SharedPreferences instance, dynamic data) async {
    print(data);
    print(data.runtimeType);
    print(data[BackendHelper.accesstoken]);
    await instance.setString(
        BackendHelper.accesstoken, data[BackendHelper.accesstoken]);
    await instance.setString(
        BackendHelper.refreshtoken, data[BackendHelper.refreshtoken]);
    await instance.setBool("isGuest", isGuest); // handle guest or user
    Map userInfo = await APIService().getUserProfile();
    print(userInfo);

    print(jsonEncode(userInfo));
    await instance.setString("userInfo", jsonEncode(userInfo)); // save user profile
    Map<String,bool> notif = {
      "lost": true,
      "found": true,
      "announcement": true,
      "buy": true,
      "sell": true,
      "cab sharing": true
    };
    await instance.setString("notifInfo", jsonEncode(notif)); // save notif preferences
  }

  Future<void> saveToUserInfo(SharedPreferences instance) async { // only called after saving jwt tokens in local storage
    print("here");
    userData = jsonDecode(instance.getString("userInfo")!);
    print("HEHEHEHEHE");
    if(instance.getString("notifInfo") == null)
      {
        Map<String,bool> a = {
          "lost": true,
          "found": true,
          "announcement": true,
          "buy": true,
          "sell": true,
          "cab sharing": true
        };
        await instance.setString("notifInfo", jsonEncode(a));
        notifData = a;
      }
    else
      {
        Map<String,dynamic> temp = jsonDecode(instance.getString("notifInfo")!);
        for(String key in temp.keys)
        {
          notifData[key] = temp[key] as bool;
        }
      }

    print(notifData);
    print(userData);
    var fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcm token: ${fcmToken}");
    print(isGuest);
    if(instance.getBool("isGuest")==false){
      print(instance.getString("deviceToken"));
      if (instance.getString("deviceToken") != null && instance.getString("deviceToken")!=fcmToken) { // already some token was stored
        print("inside if");
        await APIService().updateUserDeviceToken({
          "oldToken": instance.getString("deviceToken"), // stored token
          "newToken": fcmToken
        });
      }
      else if(instance.getString("deviceToken")==null){
        print("inside else");
        instance.setString("deviceToken", fcmToken!); // set the returned fcToken
        await APIService().postUserDeviceToken(fcmToken!);
      }
    }
    else{
      isGuest=true;
    }
  }

  void logOut(Function navigationPopCallBack) async {
    print("INSIDE LOGOUT");
    await cookieManager.clearCookies();
    SharedPreferences user = await SharedPreferences.getInstance();
    // if(!isGuest){
    //   print(user.getString("deviceToken")!);
    //   await APIService().logoutUser(user.getString("deviceToken")!); // remove token on logout if not guest
    // }
    await user.clear();
    userData.clear();
    isGuest = false;
    isProfileComplete=false;
    await LocalStorage.instance.deleteRecordsLogOut();
    navigationPopCallBack();
  }
}
