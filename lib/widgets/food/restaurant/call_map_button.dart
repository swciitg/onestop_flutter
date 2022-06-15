import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Call_MapButton extends StatelessWidget {
  const Call_MapButton({
    Key? key,
    required this.Call_Map,
    required this.icon,
    required this.callback,
  }) : super(key: key);

  final String Call_Map;
  final IconData icon;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: callback,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                color: kGrey9,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                    child: Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 30,
                      color: kWhite,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          Call_Map,
                          style: MyFonts.w500.setColor(kWhite),
                        )),
                  ],
                )),
              )),
        ),
      ),
    );
  }
}

launchPhoneURL(String phoneNumber) async {
  String url = 'tel:' + phoneNumber;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

openMap(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}
