import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/food/restaurant/restaurant_tile.dart';
import 'package:onestop_kit/onestop_kit.dart';

import '../../models/food/restaurant_model.dart';
import '../../services/data_provider.dart';
import '../ui/list_shimmer.dart';

class OutletsFilter extends StatelessWidget {
  static const String id = "/outletsfilter";
  const OutletsFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackground,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13.0, 20.0, 16.0, 8.0),
                  child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Outlets near you",
                        style: MyFonts.w600.size(16).setColor(kWhite),
                      )),
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<RestaurantModel>>(
                  future: DataProvider.getRestaurants(),
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
              // SizedBox(
              //   height: 5,
              // ),
              // Expanded(
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       OutletsFilterTile(
              //         filterText: "All",
              //         selected: true,
              //       ),
              //       OutletsFilterTile(filterText: "Snacks"),
              //       OutletsFilterTile(filterText: "Cakes"),
              //       OutletsFilterTile(filterText: "South Indian"),
              //       OutletsFilterTile(filterText: "North Indian"),
              //       OutletsFilterTile(filterText: "Non Veg")
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
