import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/elections/register_screen.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ElectionLoginWebView extends StatefulWidget {
  static const String id = "/electionView";

  const ElectionLoginWebView({super.key});

  @override
  State<ElectionLoginWebView> createState() => _ElectionLoginWebViewState();
}

class _ElectionLoginWebViewState extends State<ElectionLoginWebView> {
  late InAppWebViewController controller;
  final CookieManager cookieManager = CookieManager.instance();

  @override
  void dispose() {
    // Clear cookies when the widget is disposed
    cookieManager.deleteAllCookies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri.uri(
                Uri.parse("https://swc.iitg.ac.in/elections_api/auth/accounts/microsoft/login/")),
          ),
          initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
          onWebViewCreated: (InAppWebViewController webViewController) {
            controller = webViewController;
          },
          onLoadStop: (InAppWebViewController controller, Uri? url) async {
            if (url != null &&
                url.toString().startsWith('https://swc.iitg.ac.in/election_portal')) {
              // Get cookies
              final cookies = (await cookieManager.getCookies(
                      url: WebUri.uri(
                          Uri.parse('https://swc.iitg.ac.in/elections_api/auth/login_success'))))
                  .map((e) => "${e.name}=${e.value}")
                  .toList();

              // Navigate to the RegisterScreen with the cookies
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => RegisterScreen(
                    authCookie: cookies.join('; '),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
