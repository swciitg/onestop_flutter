import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/get_restaurant_distance.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/functions/utility/open_map.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';

import 'call_map_button.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({super.key, required this.restaurantModel});

  final RestaurantModel restaurantModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: kBlueGrey,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        double imageWidth = constraints.maxWidth * 0.35; //For 35/(35+65) flex
        return IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    bottomLeft: Radius.circular(23)),
                child: SizedBox(
                  width: imageWidth,
                  height: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      maxHeightDiskCache: 200,
                      imageUrl: restaurantModel.imageURL,
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      placeholder: cachedImagePlaceholder,
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/res_foodimg.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurantModel.outletName,
                        textAlign: TextAlign.left,
                        style: MyFonts.w600.size(16).setColor(kWhite),
                      ),
                      Text(
                        restaurantModel.caption,
                        style: MyFonts.w400.size(14).setColor(kFontGrey),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Closes at ${restaurantModel.closingTime}',
                        style: MyFonts.w500.size(11).setColor(lRed2),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          CallMapButton(
                            callMap: 'Call',
                            icon: FluentIcons.call_20_regular,
                            callback: () {
                              launchPhoneURL(restaurantModel.phoneNumber);
                            },
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          CallMapButton(
                            callMap: 'Map',
                            icon: FluentIcons.location_24_regular,
                            callback: () {
                              openMap(
                                  restaurantModel.latitude,
                                  restaurantModel.longitude,
                                  context,
                                  restaurantModel.outletName);
                            },
                          ),
                          Expanded(child: Container()),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 55),
                            child: Text(
                                getRestaurantDistance(context, restaurantModel),
                                textAlign: TextAlign.center,
                                style: MyFonts.w500.size(11).setColor(kWhite)),
                          ),
                          Expanded(child: Container()),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
