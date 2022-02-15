import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';
import 'package:onestop_dev/widgets/foodResTile.dart';


class FoodTab extends StatelessWidget {
  const FoodTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        FoodSearchBar(),
        SizedBox(
          height: 10,
        ),
        MessMenu(),
        SizedBox(height: 50),
        restaurant(),
      ],
    );
  }
}

class FoodSearchBar extends StatelessWidget {
  const FoodSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          filled: true,
          prefixIcon: Icon(Icons.search,color: kWhite,),
          hintStyle: MyFonts.medium.setColor(kGrey2),
          hintText: "Search dish or restaurant",
          fillColor: kBlueGrey),
    );
  }
}

class MessMenu extends StatelessWidget {
  const MessMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kBlueGrey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MessMeal(mealName: "Breakfast"),
                    MessMeal(mealName: "Lunch"),
                    MessMeal(
                      mealName: "Dinner",
                      selected: true,
                    ),
                  ],
                )),
            SizedBox(
              width: 16,
            ),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                        child: Text(
                      "8:00 pm - 10:15 pm",
                      style: MyFonts.medium.setColor(kTabText),
                    )),
                    Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                            child: Text(
                                "Dal Makhani, Rasam, Green Peas, Cauliflower, Rice, Roti, Salad",
                                style:
                                    MyFonts.medium.size(18).setColor(kWhite)))),
                    Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                                child: PopupMenuButton<String>(
                              onSelected: (value) => print(value),
                              itemBuilder: (context) {
                                return ["Sun", "Mon", "Tue"]
                                    .map(
                                      (value) => PopupMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ),
                                    )
                                    .toList();
                              },
                              offset: Offset(1, 40),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: kGrey2,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text('Mon',
                                          style:
                                              MyFonts.medium.setColor(lBlue)),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: lBlue,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: PopupMenuButton<String>(
                              onSelected: (value) => print(value),
                              itemBuilder: (context) {
                                return ["Brahma", "Lohit", "Kameng"]
                                    .map(
                                      (value) => PopupMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      ),
                                    )
                                    .toList();
                              },
                              offset: Offset(1, 40),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: lBlue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text('Lohit',
                                          style:
                                              MyFonts.medium.setColor(lBlue)),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: lBlue,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ))
                  ],
                ))
          ]),
        ));
  }
}

class restaurant extends StatelessWidget {
  const restaurant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 186,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kBackground,
      ),
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10,),
            FoodResTile(Restaurant_name: "Florentine Restaurant",
            Cuisine_type: 'Multicuisine, dine-in,\nnorth-Indian',
            Wating_time: 2, 
            Closing_time: '10:00pm',
            distance: 2,
            )
          ],
        )
      ),
    );
  }
}

class MessMeal extends StatelessWidget {
  const MessMeal({
    Key? key,
    required this.mealName,
    this.selected = false,
  }) : super(key: key);

  final String mealName;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: selected ? lBlue2 : lGrey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FittedBox(
                child: Text(
                  mealName,
                  style: selected
                      ? MyFonts.medium.size(23).setColor(kBlueGrey)
                      : MyFonts.medium.size(23).setColor(lBlue),
                ),
              ),
            )),
      ),
    );
  }
}



class FavoriteDishes extends StatelessWidget {
  const FavoriteDishes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kHomeTile,
      ),
      child: Container(
        //height: 160,
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 15, 0),
                  child: Text(
                    'Your Favourite Dishes',
                    style: MyFonts.medium.size(20).setColor(kWhite),
                  ),
                ),
              ),
            ),
            SizedBox(height:5),
            Expanded(
              
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  
                  favouriteFoodDetails(foodName: "Noodlesss", img: Image.asset('assets/images/food.jpeg'),),
                  favouriteFoodDetails(foodName: "Fried Rice", img: Image.asset('assets/images/food2.jpeg'),),
                  favouriteFoodDetails(foodName: "Noodlesss", img: Image.asset('assets/images/food.jpeg'),),
                  favouriteFoodDetails(foodName: "Noodlesss", img: Image.asset('assets/images/food.jpeg'),),
                ],
              ),
            ),
            SizedBox(height:1),
            Expanded(
              
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  
                  favouriteFoodDetails(foodName: "Noodlesss", img: Image.asset('assets/images/food.jpeg'),),
                  favouriteFoodDetails(foodName: "Noodlesss", img: Image.asset('assets/images/food.jpeg'),),
                  favouriteFoodDetails(foodName: "Fried Rice", img: Image.asset('assets/images/food2.jpeg'),),
                  favouriteFoodDetails(foodName: "Fried Rice", img: Image.asset('assets/images/food2.jpeg'),), 
                  
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class favouriteFoodDetails extends StatelessWidget{
  const favouriteFoodDetails({
    Key? key,
    required this.foodName,
    required this.img ,
  }) : super(key: key);

  final String foodName;
  final Image img;
  @override
  Widget build(BuildContext context) {
    return Column(
                    children: [
                      SizedBox(
                        height: 70,
                        width: 67,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),

                          child: img,
                          )
                        ),
                      SizedBox(height:2),
                      Text(foodName,
                          style: MyFonts.medium.size(12).setColor(lBlue),
                          textAlign: TextAlign.center),
                      
                    ],
                   
                  );
  }
}