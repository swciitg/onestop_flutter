import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/food/favourite_food_details.dart';

class FavoriteDishes extends StatelessWidget {
  const FavoriteDishes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: kHomeTile,
      ),
      //padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alternative to fixing the padding at 16 for text element is
          // Wrap text with LayoutBuilder and calculate padding as
          // ((constraints.maxWidth)/4 - 65)/2
          // Since col width is Flex, each cell is maxWidth/4
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 0, 8),
            child: Text(
              'Your Favourite Dishes',
              style: MyFonts.w600.size(14).setColor(kWhite),
            ),
          ),
          Table(
            defaultColumnWidth: FlexColumnWidth(),
            children: [
              TableRow(
                children: [
                  FavouriteFoodDetails(
                    foodName: "Pizza",
                    img: Image.asset('assets/images/food/pizza.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Dosa",
                    img: Image.asset('assets/images/food/dosa.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Biryani",
                    img: Image.asset('assets/images/food/biryani.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Burger",
                    img: Image.asset('assets/images/food/burger.jpeg'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  FavouriteFoodDetails(
                    foodName: "Pasta",
                    img: Image.asset('assets/images/food/pasta.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Ice Cream",
                    img: Image.asset('assets/images/food/icecream.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Oreo Shake",
                    img: Image.asset('assets/images/food/oreo.jpeg'),
                  ),
                  FavouriteFoodDetails(
                    foodName: "Rolls",
                    img: Image.asset('assets/images/food/rolls.jpeg'),
                  ),
                ],
              ),
              TableRow(children: [
                SizedBox(
                  height: 8,
                ),
                SizedBox(),
                SizedBox(),
                SizedBox()
              ])
            ],
          )
        ],
      ),
    );
  }
}
