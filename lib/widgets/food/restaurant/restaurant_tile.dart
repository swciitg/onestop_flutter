import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/open_restaurant_page.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_ui/index.dart';

class RestaurantTile extends StatefulWidget {
  const RestaurantTile({super.key, required this.restaurantModel});

  final RestaurantModel restaurantModel;

  @override
  State<RestaurantTile> createState() => _RestaurantTileState();
}

class _RestaurantTileState extends State<RestaurantTile> {
  @override
  Widget build(BuildContext context) {
    return FoodOutletCard(
      imageUrl: widget.restaurantModel.imageURL,
      heading: widget.restaurantModel.outletName,
      subHeading: widget.restaurantModel.caption,
      subLabelText1: widget.restaurantModel.location,
      subLabelText2: 'Closes at ${widget.restaurantModel.closingTime}',
      isEnabled: true,
      onArrowPressed: () {
        final List<String> images =
            widget.restaurantModel.menu
                .map((menuItem) => menuItem.imageURL)
                .where((url) => url.isNotEmpty)
                .toList();
        images.isNotEmpty
            ? openRestaurantPage(
              context,
              widget.restaurantModel.imageURL,
              widget.restaurantModel.outletName,
              widget.restaurantModel.location,
              widget.restaurantModel.closingTime,
              widget.restaurantModel.phoneNumber,
              images,
              widget.restaurantModel.caption,
              widget.restaurantModel.latitude,
              widget.restaurantModel.longitude,
              () {
                setState(() {});
              },
            )
            : showSnackBar('No menu found');
      },
    );
  }
}
