import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

launchPhoneURL(String phoneNumber) async {
  String url = 'tel:+91$phoneNumber';
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchEmailURL(String email) async {
  String url = 'mailto:$email?subject=&body=';
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchURL(String url) async {
  final Uri uri = Uri(scheme: "https", host: url);
  print(uri);
  if(!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw "Can not launch url";
  }
}



