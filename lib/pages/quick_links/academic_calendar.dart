import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AcademicCalendar extends StatefulWidget {
  static const String id = "/academicCalendar";
  const AcademicCalendar({Key? key}) : super(key: key);

  final String url = "https://iitg.ac.in/acad/academic_calender.php";

  @override
  State<AcademicCalendar> createState() => _AcademicCalendar();
}

class _AcademicCalendar extends State<AcademicCalendar> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  double loadProgress = 0;
  bool error = false;

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
        child: Column(
          children: [
            loadProgress < 1
                ? SizedBox(
                    height: 7,
                    child: LinearProgressIndicator(
                      backgroundColor: lBlue,
                      value: loadProgress,
                    ))
                : const SizedBox(),
            Expanded(
              child: error
                  ? const PaginationText(text: "An error occurred")
                  : WebView(
                      initialUrl: widget.url,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (controller) {
                        _controller.complete(controller);
                      },
                      onWebResourceError: (_) => setState(() {
                        error = true;
                      }),
                      navigationDelegate: (NavigationRequest request) {
                        if (request.url.contains(widget.url)) {
                          // Don't allow user to navigate to other pages
                          return NavigationDecision.navigate;
                        }
                        return NavigationDecision.prevent;
                      },
                      onProgress: (progress) => setState(() {
                        loadProgress = progress / 100;
                      }),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
