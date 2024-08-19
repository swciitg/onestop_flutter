import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/food/search_results.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class FoodSearchBar extends StatelessWidget {
  FoodSearchBar({
    Key? key,
  }) : super(key: key);

  final TextEditingController searchStringController = TextEditingController();

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
      style: MyFonts.w500.setColor(kWhite),
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          filled: true,
          prefixIcon: const Icon(
            FluentIcons.search_24_regular,
            color: kWhite,
          ),
          hintStyle: MyFonts.w500.size(14).setColor(kGrey2),
          hintText: "Search dish or restaurant",
          fillColor: kBlueGrey),
    );
  }
}
