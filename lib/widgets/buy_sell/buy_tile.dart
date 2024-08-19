import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_kit/onestop_kit.dart';

import 'details_dialog.dart';

class BuyTile extends StatelessWidget {
  const BuyTile({
    Key? key,
    required this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        detailsDialogBox(context, model);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
        child: Container(
          height: 115,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            color: kBlueGrey,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 6,
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
                                model.title,
                                style: MyFonts.w600.size(16).setColor(kWhite),
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
                                model.description,
                                style: MyFonts.w500.size(12).setColor(kGrey6),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '\u{20B9}${model.price}/-',
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
                flex: 4,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(21),
                      bottomRight: Radius.circular(21)),
                  child: Image.network(
                    model.imageURL,
                    fit: BoxFit.cover,
                    cacheWidth: 100,
                    frameBuilder: restaurantTileFrameBuilder,
                    errorBuilder: (_, __, ___) => Container(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
