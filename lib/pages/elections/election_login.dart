// import 'package:flutter/material.dart';
// import 'package:onestop_dev/pages/elections/register_screen.dart';
// import 'package:webview_cookie_manager/webview_cookie_manager.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class ElectionLoginWebView extends StatefulWidget {
//   static const String id = "/electionView";
//
//   const ElectionLoginWebView({super.key});
//
//   @override
//   State<ElectionLoginWebView> createState() => _ElectionLoginWebViewState();
// }
//
// class _ElectionLoginWebViewState extends State<ElectionLoginWebView> {
//   late WebViewController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageFinished: (url) async {
//           final nav = Navigator.of(context);
//           if (url.startsWith('https://swc.iitg.ac.in/election_portal')) {
//             List cookies = await WebviewCookieManager().getCookies(
//                 'https://swc.iitg.ac.in/elections_api/auth/login_success');
//             nav.pushReplacement(MaterialPageRoute(
//                 builder: (context) =>
//                     RegisterScreen(authCookie: cookies.join("; "))));
//           }
//         },
//       ))
//       ..loadRequest(Uri.parse(
//           "https://swc.iitg.ac.in/elections_api/auth/accounts/microsoft/login/"));
//   }
//
//   @override
//   void dispose() {
//     WebviewCookieManager().clearCookies();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: WebViewWidget(
//         controller: controller,
//       ),
//     );
//   }
// }
