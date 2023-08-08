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
  final cookieManager = WebviewCookieManager();
  static bool isGuest = false;
  static bool isProfileComplete=false;

  Future<int> isAlreadyAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    print("inside authentication check");
    Map userInfo;
    if (user.containsKey("userInfo")) {
      try {
        userInfo = await APIService().getUserProfile();
      }
      catch(e)
    {
      return 2;
    }
      await user.setString('userInfo', jsonEncode(userInfo));
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
      return 0;
    }
    return 1;
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
  }

  Future<void> saveToUserInfo(SharedPreferences instance) async { // only called after saving jwt tokens in local storage
    userData = jsonDecode(instance.getString("userInfo")!);
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
