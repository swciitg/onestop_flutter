import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/login/welcome.dart';
import 'package:onestop_dev/widgets/login/login_webview.dart';
import 'package:onestop_dev/widgets/login/external_browser_login.dart';
import 'package:onestop_kit/onestop_kit.dart';

class LoginPage extends StatefulWidget {
  static String id = "/login";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  bool useExternalBrowserLogin = Platform.isAndroid;

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body:
          loading
              ? SafeArea(
                child:
                    useExternalBrowserLogin ? const ExternalBrowserLogin() : const LoginWebView(),
              )
              : WelcomePage(
                setLoading: () {
                  setState(() {
                    loading = true;
                  });
                },
              ),
    );
  }
}
