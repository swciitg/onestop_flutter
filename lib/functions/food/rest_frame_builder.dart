import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:shimmer/shimmer.dart';

Widget restaurantTileFrameBuilder(BuildContext context, Widget child,
    int? frame, bool wasSynchronouslyLoaded) {
  if (wasSynchronouslyLoaded) {
    return child;
  }
  if (frame == null) {
    return Shimmer.fromColors(
        period: const Duration(seconds: 1),
        baseColor: kBlueGrey,
        highlightColor: const Color.fromRGBO(68, 86, 120, 1),
        child: Container(color: kBlack, height: 190));
  }
  return child;
}

Widget cachedImagePlaceholder(BuildContext context, String url) {
  return Shimmer.fromColors(
      period: const Duration(seconds: 1),
      baseColor: kBlueGrey,
      highlightColor: const Color.fromRGBO(68, 86, 120, 1),
      child: Container(color: kBlack, height: 190));
}
