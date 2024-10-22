import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/get_restaurant_distance.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/functions/utility/open_map.dart';
import 'package:onestop_dev/functions/utility/open_outlet_menu.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/pages/food/restaurant_page.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

import 'call_map_button.dart';

class RestaurantTile extends StatefulWidget {
  const RestaurantTile({super.key, required this.restaurantModel});

  final RestaurantModel restaurantModel;

  @override
  State<RestaurantTile> createState() => _RestaurantTileState();
}

class _RestaurantTileState extends State<RestaurantTile> {
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
                      imageUrl: widget.restaurantModel.imageURL,
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
                      Row(
                        children: [
                          Text(
                            widget.restaurantModel.outletName,
                            textAlign: TextAlign.left,
                            style: MyFonts.w600.size(16).setColor(kWhite),
                          ),
                            Expanded(child: Container()),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 100),
                            child: Text(
                                getRestaurantDistance(
                                    context, widget.restaurantModel),
                                textAlign: TextAlign.center,
                                style: MyFonts.w500.size(11).setColor(kWhite)),
                          ),
                        ],
                      ),
                      Text(
                        widget.restaurantModel.caption,
                        style: MyFonts.w400.size(14).setColor(kFontGrey),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Closes at ${widget.restaurantModel.closingTime}',
                        style: MyFonts.w500.size(11).setColor(lRed2),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        
                       
                        children: [
                          CallMapButton(
                            callMap: '',
                            icon: FluentIcons.call_20_regular,
                            callback: () {
                              launchPhoneURL(widget.restaurantModel.phoneNumber);
                            },
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          CallMapButton(
                            callMap: '',
                            icon: FluentIcons.location_48_regular,
                            callback: () {
                              openMap(
                                  widget.restaurantModel.latitude,
                                  widget.restaurantModel.longitude,
                                  context,
                                  widget.restaurantModel.outletName);
                            },
                          ),
                           const SizedBox(
                            width: 4,
                          ),
                          CallMapButton(
                            callMap: 'Menu',
                            icon: FluentIcons.food_16_filled,
                            callback: () {
                              context
                                  .read<RestaurantStore>()
                                  .setSelectedRestaurant(
                                      widget.restaurantModel);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RestaurantPage(),
                                ),
                              );
                            },
                          ),

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
