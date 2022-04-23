import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/restaurant_model.dart';
import 'package:onestop_dev/pages/food/restaurant_page.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantTile extends StatelessWidget {
  RestaurantTile(
      {Key? key,
      required this.Restaurant_name,
      required this.Cuisine_type,
      required this.Waiting_time,
      required this.Closing_time,
      required this.Phone_Number,
      required this.Distance,
      required this.Latitude,
      required this.Longitude,
      required this.restaurant_model})
      : super(key: key);

  final String Restaurant_name;
  final String Cuisine_type;
  final int Waiting_time;
  final String Closing_time;
  final int Distance;
  final String Phone_Number;
  final double Latitude;
  final double Longitude;
  final RestaurantModel restaurant_model;

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    return TextButton(
      onPressed: () {
        context.read<RestaurantStore>().setSelectedRestaurant(restaurant_model);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RestaurantPage()));
      },
      child: Container(
        // width: 325,
        height: Height * 0.23,
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
                child: new Image.asset(
                  'assets/images/res_foodimg.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // SizedBox(
            //   width: 13,
            // ),
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
                                '$Restaurant_name',
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
                                Cuisine_type,
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
                            'Waiting time: $Waiting_time hrs',
                            style: MyFonts.medium.size(11).setColor(kRed),
                          )),
                          Expanded(
                              child: Text(
                            'Closes at $Closing_time',
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
                                _launchPhoneURL(Phone_Number);
                              },
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Call_MapButton(
                              Call_Map: 'Map',
                              icon: Icons.location_on_outlined,
                              callback: () {
                                _openMap(Latitude, Longitude);
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '$Distance km',
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
    required this.Dish_Name,
    required this.Veg,
    required this.Ingredients,
    required this.Waiting_time,
    required this.Price,
  }) : super(key: key);

  final String Dish_Name;
  final bool Veg;
  final List<String> Ingredients;
  final int Waiting_time;
  final int Price;

  Color IconColor(Veg) {
    if (Veg)
      return Colors.green;
    else
      return Colors.red;
  }

  String IngredientsList(Ingredients) {
    String IngredientsLists = "";
    for (String Ingredient in Ingredients) {
      IngredientsLists = IngredientsLists + Ingredient + ',';
    }
    return IngredientsLists.substring(0, IngredientsLists.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double Height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Width * 0.05, vertical: 5.0),
      child: Container(
        height: Height * 0.18,
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
                              '$Dish_Name',
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
                                  color: IconColor(Veg),
                                  size: 14,
                                ),
                                Icon(Icons.circle,
                                    color: IconColor(Veg), size: 5),
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
                              IngredientsList(Ingredients),
                              style: MyFonts.medium.size(12).setColor(kWhite),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '\u{20B9}$Price/-',
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
                child: new Image.asset(
                  'assets/images/res_foodimg.jpg',
                  fit: BoxFit.fill,
                ),
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
    required this.Restaurant_Name,
    required this.About,
    required this.Address,
    required this.Veg,
    required this.Closing_Time,
    required this.Distance,
    required this.Phone_Number,
    required this.Waiting_Time,
    required this.Latitude,
    required this.Longitude,
  }) : super(key: key);

  final String Restaurant_Name;
  final String Address;
  final String About;
  final bool Veg;
  final int Closing_Time;
  final int Waiting_Time;
  final int Distance;
  final String Phone_Number;
  final double Latitude;
  final double Longitude;
  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Restaurant_Name,
                  style: MyFonts.medium.size(23).setColor(kWhite),
                ),
                Text(
                  About,
                  style: MyFonts.light.size(18).setColor(kWhite),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    Address,
                    style: MyFonts.medium.size(11).setColor(kWhite),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        'Waiting time: $Waiting_Time hrs',
                        style: MyFonts.light.size(12).setColor(kWhite),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Icon(Icons.circle, color: kWhite, size: 5),
                      ),
                      Text(
                        'Closing time: $Waiting_Time hrs',
                        style: MyFonts.light.size(12).setColor(kRed),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: Height * 0.05,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Call_MapButton(
                        Call_Map: 'Call',
                        icon: Icons.call_end_outlined,
                        callback: () {
                          _launchPhoneURL(Phone_Number);
                        },
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Call_MapButton(
                        Call_Map: 'Map',
                        icon: Icons.location_on_outlined,
                        callback: () {
                          _openMap(Latitude, Longitude);
                          ;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 2,
                  color: kBlueGrey,
                ),
                Container(
                  height: Height * 0.05,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      OutletsFilterTile(
                        filterText: "Menu",
                      ),
                      OutletsFilterTile(filterText: "Combos"),
                      OutletsFilterTile(filterText: "Offers"),
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Starters",
                      style: MyFonts.medium.size(18).setColor(kWhite),
                    )),
              ],
            ),
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
