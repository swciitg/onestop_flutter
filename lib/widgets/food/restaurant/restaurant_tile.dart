import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/dish_model.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/pages/food/restaurant_page.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: kBlueGrey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21),
                    bottomLeft: Radius.circular(21)),
                child: Image.network(restaurant_model.image,
                    fit: BoxFit.fitHeight),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                restaurant_model.name,
                                style: MyFonts.bold.size(16).setColor(kWhite),
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
                                style:
                                    MyFonts.regular.size(14).setColor(kTabText),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          // flex: 2,
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                            'Waiting time: ${restaurant_model.waiting_time} hrs',
                            style: MyFonts.medium.size(11).setColor(kRed),
                          )),
                          Expanded(
                              child: Text(
                            'Closes at ${restaurant_model.closing_time}',
                            style: MyFonts.medium.size(11).setColor(kTabText),
                          )),
                        ],
                      )),
                      Expanded(
                        // flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Call_MapButton(
                              Call_Map: 'Call',
                              icon: Icons.call_end_outlined,
                              callback: () {
                                _launchPhoneURL(restaurant_model.phone_number);
                              },
                            ),
                            Call_MapButton(
                              Call_Map: 'Map',
                              icon: Icons.location_on_outlined,
                              callback: () {
                                _openMap(restaurant_model.latitude,
                                    restaurant_model.longitude);
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10.0),
                                child: Text(
                                  '2 km',
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
                color: lGrey,
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
                          style: MyFonts.medium.setColor(kWhite),
                        )),
                  ],
                )),
              )),
        ),
      ),
    );
  }
}

class FoodTile extends StatelessWidget {
  FoodTile({
    Key? key,
    required this.dish,
  }) : super(key: key);

  final DishModel dish;

  Color IconColor(Veg) {
    if (Veg)
      return Colors.green;
    else
      return Colors.red;
  }

  String IngredientsList(Ingredients) {
    return Ingredients.substring(1, Ingredients.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: kBlueGrey,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 2.0, 3.0, 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              dish.name,
                              style: MyFonts.medium.size(18).setColor(kWhite),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.crop_square_sharp,
                                  color: IconColor(dish.veg),
                                  size: 14,
                                ),
                                Icon(Icons.circle,
                                    color: IconColor(dish.veg), size: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              dish.ingredients
                                  .substring(1, dish.ingredients.length - 1),
                              style: MyFonts.medium.size(12).setColor(kWhite),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '\u{20B9}${dish.price}/-',
                              style: MyFonts.medium.size(16).setColor(kTabText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(21),
                    bottomRight: Radius.circular(21)),
                child: Image.network(dish.image, fit: BoxFit.fitHeight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                style: MyFonts.medium.size(24).setColor(kWhite),
              ),
              Text(
                restaurant.caption,
                style: MyFonts.light.size(18).setColor(kWhite),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: RichText(
                  text: TextSpan(
                    text: restaurant.address,
                    style: MyFonts.medium.size(13).setColor(kGrey),
                    children: [
                      TextSpan(
                        text: ' \u{2022} ',
                        style: MyFonts.bold.size(12).setColor(kWhite),
                      ),
                      TextSpan(
                        text: '2 kms',
                        style: MyFonts.medium.size(13).setColor(kWhite),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 60, 2),
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
                          style: MyFonts.light.size(12).setColor(kWhite),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Icon(Icons.circle, color: kWhite, size: 5),
                        ),
                        Text(
                          'Closing time: ${restaurant.closing_time}',
                          style: MyFonts.light.size(12).setColor(kRed),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: Container(
                  height: 36,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Call_MapButton(
                        Call_Map: 'Call',
                        icon: Icons.call_end_outlined,
                        callback: () {
                          _launchPhoneURL(restaurant.phone_number);
                        },
                      ),
                      Call_MapButton(
                        Call_Map: 'Map',
                        icon: Icons.location_on_outlined,
                        callback: () {
                          _openMap(restaurant.latitude, restaurant.longitude);
                          ;
                        },
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: SizedBox(),
                // child: Container(
                //   height: 36,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: [
                //       OutletsFilterTile(
                //         filterText: "Menu",
                //       ),
                //       OutletsFilterTile(filterText: "Combos"),
                //       OutletsFilterTile(filterText: "Offers"),
                //     ],
                //   ),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Starters",
                      style: MyFonts.medium.size(18).setColor(kWhite),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OutletsFilterTile extends StatelessWidget {
  const OutletsFilterTile({
    Key? key,
    required this.filterText,
    this.selected = false,
  }) : super(key: key);

  final String filterText;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: selected ? lBlue2 : kGrey2,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FittedBox(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 20),
                child: Text(
                  filterText,
                  style: selected
                      ? MyFonts.medium.size(23).setColor(kBlueGrey)
                      : MyFonts.medium.size(23).setColor(lBlue),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )),
    );
  }
}

_launchPhoneURL(String phoneNumber) async {
  String url = 'tel:' + phoneNumber;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_openMap(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}
