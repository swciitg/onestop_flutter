import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/open_map.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'call_map_button.dart';

class RestaurantHeader extends StatelessWidget {
  const RestaurantHeader({
    Key? key,
    required this.restaurant,
  }) : super(key: key);
  final RestaurantModel restaurant;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name,
                style: MyFonts.w500.size(22).setColor(kWhite),
              ),
              Text(
                restaurant.caption,
                style: MyFonts.w400.size(16).setColor(lBlue4),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    text: restaurant.address,
                    style: MyFonts.w500.size(13).setColor(kGrey),
                    children: [
                      TextSpan(
                        text: ' \u{2022} ',
                        style: MyFonts.w700.size(12).setColor(kWhite),
                      ),
                      TextSpan(
                        text: '2 kms',
                        style: MyFonts.w500.size(13).setColor(kWhite),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 60, 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Waiting time: ${restaurant.waiting_time}',
                          style: MyFonts.w300.size(12).setColor(kWhite),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Icon(Icons.circle, color: kWhite, size: 5),
                        ),
                        Text(
                          'Closing time: ${restaurant.closing_time}',
                          style: MyFonts.w300.size(12).setColor(lRed2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Container(
                  height: 36,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Call_MapButton(
                          fontSize: 14,
                          Call_Map: 'Call',
                          icon: Icons.phone_outlined,
                          callback: () {
                            launchPhoneURL(restaurant.phone_number);
                          },
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Call_MapButton(
                          fontSize: 14,
                          Call_Map: 'Map',
                          icon: Icons.location_on_outlined,
                          callback: () {
                            openMap(restaurant.latitude, restaurant.longitude);
                            ;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3.0,
                ),
                child: Container(
                  height: 3,
                  color: kBlueGrey,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     vertical: 5.0,
              //   ),
              //   child: SizedBox(),
              //   // child: Container(
              //   //   height: 36,
              //   //   child: ListView(
              //   //     scrollDirection: Axis.horizontal,
              //   //     children: [
              //   //       OutletsFilterTile(
              //   //         filterText: "Menu",
              //   //       ),
              //   //       OutletsFilterTile(filterText: "Combos"),
              //   //       OutletsFilterTile(filterText: "Offers"),
              //   //     ],
              //   //   ),
              //   // ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Starters",
                      style: MyFonts.w600.size(16).setColor(kWhite),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
