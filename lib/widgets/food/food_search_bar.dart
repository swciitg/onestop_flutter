import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/food/search_results.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';

class FoodSearchBar extends StatelessWidget {
  FoodSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (s) {
        context
            .read<RestaurantStore>()
            .setSearchHeader("Showing results for $s");
        context.read<RestaurantStore>().setSearchString(s);
        Navigator.pushNamed(context, SearchPage.id);
      },
      onChanged: (s) {
        context.read<RestaurantStore>().setSearchHeader("Showing results for $s");
        context.read<RestaurantStore>().setSearchString(s);
      },
      style: MyFonts.medium.setColor(kWhite),
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: kWhite,
          ),
          hintStyle: MyFonts.medium.setColor(kGrey2),
          hintText: "Search dish or restaurant",
          fillColor: kBlueGrey),
    );
  }
}
