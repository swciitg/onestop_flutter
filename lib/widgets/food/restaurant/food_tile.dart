import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/dish_model.dart';

class FoodTile extends StatelessWidget {
  FoodTile({
    Key? key,
    required this.dish,
  }) : super(key: key);

  final DishModel dish;

  Color IconColor(Veg) {
    if (Veg)
      return Colors.green;
    else
      return Colors.red;
  }

  String IngredientsList(Ingredients) {
    return Ingredients.substring(1, Ingredients.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: kBlueGrey,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 2.0, 3.0, 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              dish.name,
                              style: MyFonts.w500.size(18).setColor(kWhite),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.crop_square_sharp,
                                  color: IconColor(dish.veg),
                                  size: 14,
                                ),
                                Icon(Icons.circle,
                                    color: IconColor(dish.veg), size: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              dish.ingredients
                                  .substring(1, dish.ingredients.length - 1),
                              style: MyFonts.w500.size(12).setColor(kGrey6),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '\u{20B9}${dish.price}/-',
                              style: MyFonts.w600.size(14).setColor(lBlue4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(21),
                    bottomRight: Radius.circular(21)),
                child: Image.network(dish.image, fit: BoxFit.fitHeight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
