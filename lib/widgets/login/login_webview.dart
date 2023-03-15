import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';
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
      initialUrl: "https://swc.iitg.ac.in/onestopapi/v2/auth/microsoft",
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        widget._controller.complete(controller);
      },
      onWebResourceError: (context) {},
      onPageFinished: (url) async {
        if (url.startsWith(
            "https://swc.iitg.ac.in/onestopapi/v2/auth/microsoft/redirect?code")) {
          WebViewController controller = await widget._controller.future;

          var userInfoString = await controller.runJavascriptReturningResult("document.querySelector('#userInfo').innerText");
          print('elections');
          var userInfo = {};
          List<String> values = userInfoString.replaceAll('"', '').split("/");
          if (!values[0].toLowerCase().contains("error")) {
            userInfo["displayName"] = values[0];
            userInfo["mail"] = values[1];
            userInfo["surname"] = values[2];
            userInfo["id"] = values[3];
            SharedPreferences user = await SharedPreferences.getInstance();
            if (!mounted) return;
            context.read<LoginStore>().saveToPreferences(user, userInfo);
            context.read<LoginStore>().saveToUserData(user);
            await WebviewCookieManager().clearCookies();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        }
      },
    );
  }
}
