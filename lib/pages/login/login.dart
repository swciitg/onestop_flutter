import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/widgets/login/login_webview.dart';
import 'package:onestop_dev/pages/login/welcome.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  static String id = "/login";

  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: loading
            ? SafeArea(child: LoginWebView(controller: _controller))
            : WelcomePage(setLoading: () {
                setState(() {
                  loading = true;
                });
              }));
  }
}
