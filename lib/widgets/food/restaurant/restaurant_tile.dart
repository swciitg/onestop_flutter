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
        height: 168,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: kBlueGrey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 7, //For 35/(35+65) flex
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(23),
                    bottomLeft: Radius.circular(23)),
                child: Image.network(restaurant_model.image,
                    fit: BoxFit.fitHeight),
              ),
            ),
            Expanded(
              flex: 13,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 8.0, 5.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                restaurant_model.name,
                                style: MyFonts.med6.size(16).setColor(kWhite),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                restaurant_model.caption,
                                style: MyFonts.regular
                                    .size(15)
                                    .setColor(kFontGrey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Expanded(
                          // flex: 2,
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Waiting time: ${restaurant_model.waiting_time}',
                            style: MyFonts.medium.size(11).setColor(kTabText),
                          ),
                          Text(
                            'Closes at ${restaurant_model.closing_time}',
                            style: MyFonts.medium.size(11).setColor(lRed2),
                          ),
                        ],
                      )),
                      Expanded(
                        // flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Call_MapButton(
                              Call_Map: 'Call',
                              icon: Icons.phone_outlined,
                              callback: () {
                                launchPhoneURL(restaurant_model.phone_number);
                              },
                            ),
                            Call_MapButton(
                              Call_Map: 'Map',
                              icon: Icons.location_on_outlined,
                              callback: () {
                                openMap(restaurant_model.latitude,
                                    restaurant_model.longitude);
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10.0),
                                child: Text(
                                  '2 kms',
                                  style:
                                      MyFonts.medium.size(11).setColor(kWhite),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
