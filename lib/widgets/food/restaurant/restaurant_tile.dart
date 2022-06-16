import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/pages/food/restaurant_page.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:provider/provider.dart';
import 'call_map_button.dart';

class RestaurantTile extends StatelessWidget {
  RestaurantTile({Key? key, required this.restaurant_model}) : super(key: key);

  final RestaurantModel restaurant_model;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<RestaurantStore>().setSelectedRestaurant(restaurant_model);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RestaurantPage()));
      },
      child: Container(
        //height: 170,
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
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(23),
                      bottomLeft: Radius.circular(23)),
                  child: Container(
                    width: imageWidth,
                    height: double.infinity,
                    child: Image.network(restaurant_model.image,
                        fit: BoxFit.fitHeight),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant_model.name,
                          textAlign: TextAlign.left,
                          style: MyFonts.w600.size(16).setColor(kWhite),
                        ),
                        Text(
                          restaurant_model.caption,
                          style: MyFonts.w400.size(14).setColor(kFontGrey),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Waiting time: ${restaurant_model.waiting_time}',
                          style: MyFonts.w500.size(11).setColor(kTabText),
                        ),
                        SizedBox(height: 1,),
                        Text(
                          'Closes at ${restaurant_model.closing_time}',
                          style: MyFonts.w500.size(11).setColor(lRed2),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Call_MapButton(
                              Call_Map: 'Call',
                              icon: Icons.phone_outlined,
                              callback: () {
                                launchPhoneURL(restaurant_model.phone_number);
                              },
                            ),
                            SizedBox(width: 4,),
                            Call_MapButton(
                              Call_Map: 'Map',
                              icon: Icons.location_on_outlined,
                              callback: () {
                                openMap(restaurant_model.latitude,
                                    restaurant_model.longitude);
                              },
                            ),
                            Expanded(child: Container()),
                            Text(
                              '2 kms',
                              style: MyFonts.w500.size(11).setColor(kWhite),
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
      ),
    );
  }
}
