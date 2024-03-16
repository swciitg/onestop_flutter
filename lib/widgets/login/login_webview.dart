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
  const LoginWebView({
    Key? key,
    required Completer<WebViewController> controller,
  })  : _controller = controller,
        super(key: key);

  final Completer<WebViewController> _controller;

  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: "${Endpoints.baseUrl}/auth/microsoft",
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        widget._controller.complete(controller);
      },
      onWebResourceError: (context) {},
      onPageFinished: (url) async {
        if (url.startsWith(
            "${Endpoints.baseUrl}/auth/microsoft/redirect?code")) {
          WebViewController controller = await widget._controller.future;

          var userTokensString = await controller.runJavascriptReturningResult("document.querySelector('#userTokens').innerText");
          print("TOKENS STRING");
          userTokensString=userTokensString.replaceAll('"', '');
          print(userTokensString);
          if (userTokensString!="ERROR OCCURED") {
            SharedPreferences user = await SharedPreferences.getInstance();
            if (!mounted) return;
            Map userTokens = {BackendHelper.accesstoken: userTokensString.split('/')[0],BackendHelper.refreshtoken: userTokensString.split('/')[1]};
            print(userTokens);
            await LoginStore().saveToPreferences(user, userTokens);
            await LoginStore().saveToUserInfo(user);
            await WebviewCookieManager().clearCookies();
            print("its here");
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => EditProfile(profileModel: ProfileModel.fromJson(LoginStore.userData),)), (route) => false);
          }
        }
      },
    );
  }
}
