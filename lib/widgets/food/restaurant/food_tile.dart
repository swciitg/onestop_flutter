import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/food/dish_model.dart';

class FoodTile extends StatelessWidget {
  const FoodTile({
    Key? key,
    required this.dish,
  }) : super(key: key);

  final DishModel dish;

  Color getIconColor(veg) {
    if (veg) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  String getIngredients(ingredientsList) {
    return ingredientsList.substring(1, ingredientsList.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            color: kBlueGrey,
          ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              dish.name,
                              style: MyFonts.w600.size(16).setColor(kWhite),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.crop_square_sharp,
                                  color: getIconColor(dish.veg),
                                  size: 14,
                                ),
                                Icon(
                                  Icons.circle,
                                  color: getIconColor(dish.veg),
                                  size: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getIngredients(dish.ingredients),
                            style: MyFonts.w400.size(14).setColor(kGrey6),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '\u{20B9} ${dish.price}/-',
                            style: MyFonts.w600.size(14).setColor(lBlue4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(21),
                      bottomRight: Radius.circular(21)),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        maxHeightDiskCache: 200,
                        imageUrl: dish.image,
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        placeholder: cachedImagePlaceholder,
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/res_foodimg.jpg",
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
