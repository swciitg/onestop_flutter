import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/endpoints.dart';
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
          print(userTokensString);
          if (userTokensString!="ERROR OCCURED") {
            SharedPreferences user = await SharedPreferences.getInstance();
            if (!mounted) return;
            context.read<LoginStore>().saveToPreferences(user, jsonDecode(userTokensString));
            context.read<LoginStore>().saveToUserInfo(user);
            await WebviewCookieManager().clearCookies();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        }
      },
    );
  }
}
