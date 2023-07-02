import 'package:onestop_dev/globals/database_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUserHelpers{
  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(BackendHelper.accesstoken) ?? " ";
  }

  static Future<void> setAccessToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(BackendHelper.accesstoken, value);
  }

  static Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(BackendHelper.refreshtoken) ?? " ";
  }

  static Future<void> setRefreshToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(BackendHelper.refreshtoken, value);
  }
}