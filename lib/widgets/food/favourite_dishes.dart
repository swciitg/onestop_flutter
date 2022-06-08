import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/food/favourite_food_details.dart';

class FavoriteDishes extends StatelessWidget {
  const FavoriteDishes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
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
            SizedBox(height: 5),
            Expanded(
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FavouriteFoodDetails(
                    foodName: "Noodles",
                    img: Image.asset('assets/images/food.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Fried Rice",
                    img: Image.asset('assets/images/food2.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Biryani",
                    img: Image.asset('assets/images/food.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Chinese",
                    img: Image.asset('assets/images/food.jpeg'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1),
            Expanded(
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FavouriteFoodDetails(
                    foodName: "Chinese",
                    img: Image.asset('assets/images/food.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Cakes",
                    img: Image.asset('assets/images/food.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Sandwich",
                    img: Image.asset('assets/images/food2.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Continental",
                    img: Image.asset('assets/images/food2.jpeg'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
