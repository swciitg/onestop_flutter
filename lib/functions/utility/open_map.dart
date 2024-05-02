import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/main.dart';

void openMap(double latitude, double longitude, BuildContext context,
    String title) async {
  var availableMap = (await MapLauncher.installedMaps).first;
  try {
    await availableMap.showMarker(
      coords: Coords(latitude, longitude),
      title: title,
    );
  } catch (e) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
        content: Text(
      "Could not open map.",
      style: MyFonts.w500,
    )));
  }
}
