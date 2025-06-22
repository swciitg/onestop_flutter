import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/components/text.dart';
import 'package:onestop_ui/utils/colors.dart';
import 'package:onestop_ui/utils/styles.dart';

import 'open_map.dart';

void openRestaurantPage(
  BuildContext context,
  String imageUrl,
  String name,
  String location,
  String closingTime,
  String phoneNumber,
  List<String> menuImages,
  String caption,
  var latitude,
  var longitude,
  void Function() reloadCallback,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: OColor.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.error,
                          color: OColor.red500,
                          size: 80,
                        );
                      },
                      cacheWidth: 240,
                      cacheHeight: 240,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OText(
                                    text: name,
                                    style: OTextStyle.headingLarge.copyWith(
                                      color: OColor.gray800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  OText(
                                    text: caption,
                                    style: OTextStyle.bodySmall.copyWith(
                                      color: OColor.gray600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: OColor.gray100,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: OColor.gray600,
                                  size: 20,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on, color: OColor.gray600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OText(
                      text: location,
                      style: OTextStyle.bodyMedium.copyWith(
                        color: OColor.gray600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: OColor.gray600, size: 20),
                  const SizedBox(width: 8),
                  OText(
                    text: 'Closes at $closingTime',
                    style: OTextStyle.bodyMedium.copyWith(
                      color: OColor.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    constraints: BoxConstraints(minWidth: 150, minHeight: 40),
                    child: SecondaryButton(
                      label: 'Call',
                      onPressed: () {
                        launchPhoneURL(phoneNumber);
                      },
                      leadingIcon: Icons.phone_outlined,
                      opColor: OColor.green600,
                      iconColor: OColor.green600,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(minWidth: 150, minHeight: 40),
                    child: SecondaryButton(
                      label: 'Directions',
                      onPressed: () {
                        openMap(latitude, longitude, context, name);
                      },
                      leadingIcon: Icons.map_outlined,
                      iconColor: OColor.green600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              OText(
                text: 'Menu',
                style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: menuImages.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(menuImages[index], fit: BoxFit.cover),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
