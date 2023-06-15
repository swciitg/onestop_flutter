import 'dart:async';
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/pages/login/welcome.dart';
import 'package:onestop_dev/widgets/login/login_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class LoginPage extends StatefulWidget {
  static String id = "/login";

  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: loading
            ? AppBar(
                backgroundColor: kBackground,
                iconTheme: const IconThemeData(color: kAppBarGrey),
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: kAppBarGrey,
                      child: IconButton(
                        icon: const Icon(
                          FluentIcons.arrow_left_24_regular,
                          color: lBlue2,
                        ),
                        onPressed: () {
                               Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                        },
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        WidgetSpan(
                          child: Row(
                            children: [
                              Text(
                                "One",
                                textAlign: TextAlign.center,
                                style: MyFonts.w600
                                    .size(23)
                                    .letterSpace(1.0)
                                    .setColor(lBlue2),
                              ),
                              Text(
                                ".",
                                textAlign: TextAlign.center,
                                style: MyFonts.w500.size(23).setColor(kYellow),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                     Opacity(
                      opacity: 0,
                       child: CircleAvatar(
                        backgroundColor: kAppBarGrey,
                        child: IconButton(
                          icon: const Icon(
                            FluentIcons.arrow_left_24_regular,
                            color: lBlue2,
                          ),
                          onPressed: () {
                            // setState(() {
                            //   loading=false;
                            // });
                          },
                        ),
                                         ),
                     ),

                  ],
                ),
                elevation: 0.0,
              )
            : null,
        body: loading
            ? SafeArea(child: LoginWebView(controller: _controller))
            : WelcomePage(setLoading: () {
                setState(() {
                  loading = true;
                });
              }));
  }
}
