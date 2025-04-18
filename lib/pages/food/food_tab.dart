import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/widgets/food/mess/mess_menu.dart';
import 'package:onestop_dev/widgets/food/outlets_filter.dart';
import 'package:onestop_dev/widgets/food/restaurant/restaurant_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';

class FoodTab extends StatelessWidget {
  const FoodTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          // FoodSearchBar(),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MessMenu(),
                  // const MessOpiFormPage(),
                  const SizedBox(height: 16),
                  // const MessLinks(),
                  // const SizedBox(height: 16),
                  // const FavoriteDishes(),
                  const SizedBox(height: 16),
                  const OutletsFilter(),
                  const SizedBox(height: 10),
                  FutureBuilder<List<RestaurantModel>>(
                      future: DataService.getRestaurants(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<RestaurantModel>> snapshot) {
                        if (snapshot.hasData) {
                          List<Widget> foodList = snapshot.data!
                              .map(
                                (e) => RestaurantTile(
                                  restaurantModel: e,
                                ),
                              )
                              .toList();
                          return Column(
                            children: foodList,
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            "An error occurred",
                            style: MyFonts.w500.size(18).setColor(kWhite),
                          ));
                        }
                        return Center(
                          child: ListShimmer(
                            height: 168,
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
