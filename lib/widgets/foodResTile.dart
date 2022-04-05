import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';

class FoodResTile extends StatelessWidget {
  FoodResTile({
    Key? key,
    required this.Restaurant_name,
    required this.Cuisine_type,
    required this.Wating_time,
    required this.Closing_time,
    required this.distance,
  }) : super(key: key);

  final String Restaurant_name;
  final String Cuisine_type;
  final int Wating_time;
  final String Closing_time;
  final int distance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        // width: 325,
        height: 168,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: kBlueGrey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '$Restaurant_name',
                          style: MyFonts.bold.size(16).setColor(kWhite),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                            Cuisine_type,
                            style: MyFonts.regular.size(14).setColor(kTabText),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                'Waiting time: $Wating_time hrs',
                                style: MyFonts.medium.size(11).setColor(kRed),
                              )),
                              Expanded(
                                  child: Text(
                                'Closes at $Closing_time',
                                style: MyFonts.medium.size(11).setColor(kTabText),
                              )),
                            ],
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                          flex: 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Call_MapButton(
                                  Call_Map: 'Call',
                                  icon: Icons.call_end_outlined),
                              SizedBox(
                                width: 5.0,
                              ),
                              Call_MapButton(
                                Call_Map: 'Map',
                                icon: Icons.location_on_outlined,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '$distance km',
                                  style: MyFonts.medium.size(11).setColor(kWhite),
                                ),
                              ))
                            ],
                          )),
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
  }) : super(key: key);

  final String Call_Map;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    String n = Ingredients.toString();
    for (String Ingredient in Ingredients) {
      IngredientsLists = IngredientsLists + Ingredient + ',';
    }
    return n;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: kGrey2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 2, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text(
                          '$Dish_Name',
                          style: MyFonts.medium.size(18).setColor(kWhite),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
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
                    flex: 2,
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
                            'Waiting time: $Waiting_time hrs',
                            style: MyFonts.medium.size(11).setColor(kWhite),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '\u{20B9} $Price /-',
                            style: MyFonts.medium.size(14).setColor(kTabText),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    flex: 2,
                    child: Call_MapButton(
                        Call_Map: 'Order Now', icon: Icons.phone),
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
                // fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({
    Key? key,
    required this.Restaurant_Name,
    required this.About,
    required this.Address,
    required this.Veg,
    required this.Closing_Time,
    required this.Distance,
    required this.Mobile_Number,
    required this.Waiting_Time,
  }) : super(key: key);

  final String Restaurant_Name;
  final String Address;
  final String About;
  final bool Veg;
  final int Closing_Time;
  final int Waiting_Time;
  final int Distance;
  final String Mobile_Number;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      Restaurant_Name,
                      style: MyFonts.medium.size(23).setColor(kWhite),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      About,
                      style: MyFonts.light.size(18).setColor(kWhite),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Waiting time: $Waiting_Time hrs',
                            style: MyFonts.medium.size(10).setColor(kWhite),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Icon(Icons.circle, color: kWhite, size: 5),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'Closing time: $Waiting_Time hrs',
                            style: MyFonts.medium.size(10).setColor(kRed),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      Address,
                      style: MyFonts.medium.size(11).setColor(kWhite),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
