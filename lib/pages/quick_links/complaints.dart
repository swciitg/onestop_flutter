import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Complaints extends StatefulWidget {
  static String id = "/complaints";
  const Complaints({Key? key}) : super(key: key);

  final String url = "https://intranet.iitg.ac.in/ipm/complaint/";

  @override
  State<Complaints> createState() => _Complaints();
}

class _Complaints extends State<Complaints> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog();
    });
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBlueGrey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: Text(
            'Important',
            style: MyFonts.w600.size(24).setColor(kWhite),
          ),
          content: Text(
            'To access this website, you must have intranet access.',
            style: MyFonts.w500.size(15).setColor(kWhite),
          ),
          actions: [
            TextButton(
              child: Text(
                "OK",
                style: MyFonts.w400.size(15).setColor(kWhite),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        ),
      ),
    );
  }
}
