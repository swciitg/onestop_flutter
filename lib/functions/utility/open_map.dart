import 'package:url_launcher/url_launcher_string.dart';

openMap(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunchUrlString(googleUrl)) {
    await launchUrlString(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}
