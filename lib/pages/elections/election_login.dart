import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/elections/register_screen.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ElectionLoginWebView extends StatefulWidget {
  static const String id = "/electionView";
  const ElectionLoginWebView({
    Key? key,
  })  :
        super(key: key);


  @override
  State<ElectionLoginWebView> createState() => _ElectionLoginWebViewState();
}

class _ElectionLoginWebViewState extends State<ElectionLoginWebView> {

  @override
  void dispose() {
    // TODO: implement dispose
    WebviewCookieManager().clearCookies();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: "https://swc.iitg.ac.in/elections_api/auth/accounts/microsoft/login/",
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url) async {
          if(url.startsWith('https://swc.iitg.ac.in/election_portal')){
            List cookies = await WebviewCookieManager().getCookies('https://swc.iitg.ac.in/elections_api/auth/login_success');
            print(cookies);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen(authCookie: cookies.join("; "))));
          }
        },
      ),
    );
  }
}
