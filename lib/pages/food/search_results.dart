import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/stores/restaurant_store.dart';
import 'package:onestop_dev/widgets/food/food_search_bar.dart';
import 'package:onestop_dev/widgets/food/restaurant/restaurant_tile.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

import '../../widgets/ui/list_shimmer.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  static String id = "/foodSearchResults";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, displayIcon: false),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              FoodSearchBar(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Observer(
                    builder: (_) => Text(
                      context.read<RestaurantStore>().getSearchHeader,
                      style: MyFonts.w500.size(18).setColor(kWhite),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Observer(
                  builder: (_) {
                    ObservableFuture<List<RestaurantModel>> futureList =
                        context.read<RestaurantStore>().searchResults;
                    switch (futureList.status) {
                      case FutureStatus.fulfilled:
                        List<RestaurantModel> results = futureList.result;
                        List<Widget> foodList = results
                            .map((e) => RestaurantTile(restaurantModel: e))
                            .toList();
                        return ListView(
                          children: foodList,
                        );
                      case FutureStatus.rejected:
                        return const Center(
                            child: Text("An error has occurred"));
                      default:
                        return Center(
                          child: ListShimmer(
                            height: 168,
                          ),
                        );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
