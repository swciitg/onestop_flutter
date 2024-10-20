import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_kit/onestop_kit.dart';

void openRestaurantPage(
    BuildContext context, List<String> images, void Function() reloadCallback) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: OneStopColors.backgroundColor,
    showDragHandle: true,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: OneStopColors.backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              shrinkWrap: true,
              itemCount: images.isNotEmpty ? images.length : 1,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      placeholder: cachedImagePlaceholder,
                      errorWidget: (context, url, error) => Container(
                            color: kTimetableDisabled,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(
                              child: ErrorReloadButton(
                                reloadCallback: () {},
                              ),
                            ),
                          )),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
