import 'package:url_launcher/url_launcher.dart';

Future<void> launchPhoneURL(String phoneNumber) async {
  final uri = Uri(scheme: 'tel', path: '+91$phoneNumber');
  if (!await launchUrl(uri)) {
    throw 'Could not launch $uri';
  }
}

Future<void> launchEmailURL(String email) async {
  final uri = Uri(scheme: 'mailto', path: email);
  if (!await launchUrl(uri)) {
    throw 'Could not launch $uri';
  }
}

Future<void> launchURL(String url) async {
  final Uri uri = Uri(scheme: "https", host: url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw "Can not launch url";
  }
}
