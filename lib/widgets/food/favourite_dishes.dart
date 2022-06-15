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
              TableRow(
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
                    foodName: "Biryani",
                    img: Image.asset('assets/images/food2.jpeg'),
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
          // SizedBox(height: 5),
          // Row(
          //   // crossAxisAlignment: CrossAxisAlignment.stretch,
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     FavouriteFoodDetails(
          //       foodName: "Noodles",
          //       img: Image.asset('assets/images/food.jpeg'),
          //     ),
          //     FavouriteFoodDetails(
          //       foodName: "Fried Rice",
          //       img: Image.asset('assets/images/food2.jpeg'),
          //     ),
          //     FavouriteFoodDetails(
          //       foodName: "Biryani",
          //       img: Image.asset('assets/images/food.jpeg'),
          //     ),
          //     FavouriteFoodDetails(
          //       foodName: "Chinese",
          //       img: Image.asset('assets/images/food.jpeg'),
          //     ),
          //   ],
          // ),
          // // SizedBox(height: 1),
          // Row(
          //   // crossAxisAlignment: CrossAxisAlignment.stretch,
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     FavouriteFoodDetails(
          //       foodName: "Chinese",
          //       img: Image.asset('assets/images/food.jpeg'),
          //     ),
          //     FavouriteFoodDetails(
          //       foodName: "Cakes",
          //       img: Image.asset('assets/images/food.jpeg'),
          //     ),
          //     FavouriteFoodDetails(
          //       foodName: "Sandwich",
          //       img: Image.asset('assets/images/food2.jpeg'),
          //     ),
          //     FavouriteFoodDetails(
          //       foodName: "Continental",
          //       img: Image.asset('assets/images/food2.jpeg'),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
