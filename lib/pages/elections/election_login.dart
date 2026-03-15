import 'package:flutter/material.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/pages/elections/register_screen.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onestop_ui/index.dart';

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
    cookieManager.deleteAllCookies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: OColor.green600),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Election Login',
          style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
        ),
      ),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri.uri(
              Uri.parse("https://swc.iitg.ac.in/elections_api/auth/accounts/microsoft/login/"),
            ),
          ),
          initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
          onWebViewCreated: (InAppWebViewController webViewController) {
            controller = webViewController;
          },
          onLoadStop: (InAppWebViewController controller, Uri? url) async {
            if (url != null &&
                url.toString().startsWith('https://swc.iitg.ac.in/election_portal')) {
              final cookies =
                  (await cookieManager.getCookies(
                    url: WebUri.uri(
                      Uri.parse('https://swc.iitg.ac.in/elections_api/auth/login_success'),
                    ),
                  )).map((e) => "${e.name}=${e.value}").toList();

              if (navigatorKey.currentState != null) {
                navigatorKey.currentState!.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(authCookie: cookies.join('; ')),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
