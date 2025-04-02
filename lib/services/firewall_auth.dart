import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/models/firewall/firewall_credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Disable SSL verification
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class SharedPrefs {
  static Future<void> saveCredentials(Credentials credentials) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('credentials', credentials.toString());
  }

  static Future<Credentials> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return Credentials.fromString(prefs.getString('credentials') ?? "{}");
  }
}

class FirewallAuth {
  static const String _ipFirewall = '192.168.193.1';
  static const String _firewallPort = '1442';
  static const String _loginUrl =
      'https://$_ipFirewall:$_firewallPort/login?a=b';
  static const String _logoutUrl =
      'https://$_ipFirewall:$_firewallPort/logout?030403030f050d06';

  String _keepAliveUrl = '';

  final Dio _dio = Dio(BaseOptions(
    followRedirects: false,
    validateStatus: (status) => status! < 500,
  ));

  FirewallAuth() {
    HttpOverrides.global = MyHttpOverrides();
  }

// Logout function to end the session
  Future<void> logout() async {
    try {
      await _dio.get(_logoutUrl);
      Logger().i("Logged out. URL: $_logoutUrl");
    } catch (e) {
      Logger().e("Logout failed: $e");
    }
  }

// Login function and fetch keep-alive URL
  Future<void> login() async {
    final loginPageResp = await _dio.get(_loginUrl);

    // Extract magic token from HTML response
    RegExp magicTokenRegex = RegExp(r'name="magic" value="([^"]+)"');
    var tokenMatch = magicTokenRegex.firstMatch(loginPageResp.data);
    if (tokenMatch == null) {
      Logger().e("Unable to find magic token in response.");
      return;
    }
    String token = tokenMatch.group(1)!;

    final credentials = await SharedPrefs.getCredentials();

    final data = {
      'magic': token,
      'username': credentials.username,
      'password': credentials.password,
    };

    final headers = {
      'referer': _loginUrl,
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Logger().d("Login data: $data");
    Logger().d("Login headers: $headers");

    final loginResp = await _dio.post(_loginUrl,
        data: data, options: Options(headers: headers));

    Logger().d("Login POST response content: ${loginResp.data}");

    // Extract keep-alive URL from response
    final keepAliveUrlRegex = RegExp(r'window.location\s*=\s*"([^"]+)"');
    final keepAliveMatch = keepAliveUrlRegex.firstMatch(loginResp.data);
    if (keepAliveMatch != null) {
      _keepAliveUrl = keepAliveMatch.group(1)!;
      Logger().i("KeepAlive URL: $_keepAliveUrl");
    } else {
      showSnackBar("Invalid credentials!");
      throw Exception("Unable to find keep-alive URL in response.");
    }
  }

  Future<void> refreshSession() async {
    if (_keepAliveUrl.isNotEmpty) {
      await _dio.get(_keepAliveUrl);

      Logger().d("Sent request to keep-alive URL: $_keepAliveUrl");
    }
  }
}
