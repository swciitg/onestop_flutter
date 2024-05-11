import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/profile/profile_model.dart';
import 'package:onestop_dev/pages/profile/edit_profile.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebView extends StatefulWidget {
  const LoginWebView({super.key});

  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  late WebViewController controller;

  Future<String> getElementById(
      WebViewController controller, String elementId) async {
    var element = await controller.runJavaScriptReturningResult(
        "document.querySelector('#$elementId').innerText");
    String newString = element.toString();
    if (element.toString().startsWith('"')) {
      newString =
          element.toString().substring(1, element.toString().length - 1);
    }
    return newString.replaceAll('\\', '');
  }

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) async {
          final nav = Navigator.of(context);
          if (url.startsWith(
              "${Endpoints.baseUrl}/auth/microsoft/redirect?code")) {
            final userTokensString =
                (await getElementById(controller, 'userTokens'))
                    .replaceAll("\\", '"');
            if (userTokensString != "ERROR OCCURED") {
              SharedPreferences user = await SharedPreferences.getInstance();
              if (!mounted) return;
              Map userTokens = {
                BackendHelper.accesstoken: userTokensString.split('/')[0],
                BackendHelper.refreshtoken: userTokensString.split('/')[1]
              };
              await LoginStore().saveToPreferences(user, userTokens);
              await LoginStore().saveToUserInfo(user);
              await WebviewCookieManager().clearCookies();
              nav.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => EditProfile(
                      profileModel: ProfileModel.fromJson(LoginStore.userData),
                    ),
                  ),
                  (route) => false);
            }
          }
        },
      ))
      ..loadRequest(Uri.parse('${Endpoints.baseUrl}/auth/microsoft'));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: controller,
    );
  }
}
