import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:aad_oauth/aad_oauth.dart';
// import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class LoginStore {
  Map<String, String> userData = <String, String>{};
  final cookieManager = WebviewCookieManager();
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
    if (user.containsKey("name")) {
      saveToUserData(user);
      return true;
    }
    return false;
  }

  void saveToPreferences(SharedPreferences instance, dynamic data) {
    instance.setString("name", data["displayName"]);
    instance.setString("email", data["mail"]);
    instance.setString("rollno", data["surname"]);
    instance.setString("id", data["id"]);
  }

  void saveToUserData(SharedPreferences instance) {
    userData["name"] = instance.getString("name") ?? " ";
    userData["email"] = instance.getString("email") ?? " ";
    userData["rollno"] = instance.getString("rollno") ?? " ";
    userData["id"] = instance.getString("id") ?? " ";
  }

  void logOut(BuildContext context) async {
    await cookieManager.clearCookies();
    SharedPreferences user = await SharedPreferences.getInstance();
    user.clear();
    userData.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}
