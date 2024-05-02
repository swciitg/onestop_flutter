import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';

class SocialLink extends StatelessWidget {
  const SocialLink({
    super.key,
    required this.url,
    required this.imagePath,
  });

  final String url;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    Future<void> launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw "Can not launch url";
      }
    }

    return GestureDetector(
      onTap: () async {
        try {
          await launchURL(url);
        } catch (e) {
          showSnackBar(e.toString());
        }
      },
      child: Image.asset(imagePath),
    );
  }
}
