import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AcademicSSO extends StatefulWidget {
  static String id = "/academicSSO";
  const AcademicSSO({Key? key}) : super(key: key);

  final String url = "https://academic.iitg.ac.in/sso/";

  @override
  State<AcademicSSO> createState() => _AcademicSSO();
}

class _AcademicSSO extends State<AcademicSSO> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller.complete(controller);
        },
        onWebResourceError: (context) {
        },
      ),
    );
  }
}
