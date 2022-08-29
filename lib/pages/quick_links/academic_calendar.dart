import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AcademicCalendar extends StatefulWidget {
  static String id = "/academicCalendar";
  const AcademicCalendar({Key? key}) : super(key: key);

  final String url = "https://iitg.ac.in/acad/academic_calender.php";

  @override
  State<AcademicCalendar> createState() => _AcademicCalendar();
}

class _AcademicCalendar extends State<AcademicCalendar> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, displayIcon: false),
      body: SafeArea(
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller.complete(controller);
          },
          onWebResourceError: (context) {},
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(widget.url)) {
              // Don't allow user to navigate to other pages
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      ),
    );
  }
}
