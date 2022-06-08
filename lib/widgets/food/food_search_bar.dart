import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/food/search_results.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:provider/provider.dart';

class FoodSearchBar extends StatelessWidget {
  FoodSearchBar({
    Key? key,
  }) : super(key: key);

  TextEditingController searchStringController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchStringController,
      onSubmitted: (s) {
        context
            .read<RestaurantStore>()
            .setSearchHeader("Showing results for $s");
        context.read<RestaurantStore>().setSearchString(s);
        if (ModalRoute.of(context)?.settings.name != SearchPage.id) {
          Navigator.pushNamed(context, SearchPage.id);
        }
        searchStringController.clear();
      },
      onChanged: (s) {
        context
            .read<RestaurantStore>()
            .setSearchHeader("Showing results for $s");
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
