import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/food/search_results.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:provider/provider.dart';

class FavouriteFoodDetails extends StatelessWidget {
  const FavouriteFoodDetails({
    Key? key,
    required this.foodName,
    required this.img,
  }) : super(key: key);

  final String foodName;
  final Image img;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<RestaurantStore>().setSearchString(foodName);
        context.read<RestaurantStore>().setSearchHeader(foodName);
        Navigator.pushNamed(context, SearchPage.id);
      },
      child: Column(
        children: [
          SizedBox(
              height: 65,
              width: 65,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FittedBox(
                  child: img,
                  fit: BoxFit.cover,
                ),
              )),
          SizedBox(height: 10),
          Text(foodName,
              style: MyFonts.w500.size(11).setColor(lBlue),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
