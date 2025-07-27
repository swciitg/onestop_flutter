import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/widgets/lostfound/claim_call_button.dart';
import 'package:onestop_kit/onestop_kit.dart';

void detailsDialogBox(BuildContext context, dynamic model, [parentContext]) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  parentContext ??= context;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Widget priceOrLocation;
        Widget submitClaimDetails = Container();
        if (model is BuyModel || model is SellModel) {
          priceOrLocation = Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Text(
              "Price:\u{20B9}${model.price}/-",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: MyFonts.w500.size(14).setColor(kGrey6),
            ),
          );
        } else {
          priceOrLocation = Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Text(
                  "${(model is FoundModel) ? "Found" : "Lost"} at: ${model.location}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: MyFonts.w500.size(14).setColor(kGrey6),
                ),
              ),
            ],
          );
        }
        if (model is FoundModel) {
          submitClaimDetails = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: model.claimed == true ? true : false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: screenWidth - 62),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "Claimer: ${model.claimerEmail}",
                        style: MyFonts.w500.size(14).setColor(kGrey6),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Submitted at: ${model.submittedat}",
                  style: MyFonts.w500.size(14).setColor(kGrey6),
                ),
              ),
            ],
          );
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 15),
          backgroundColor: kBlueGrey,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
            child: Container(
              decoration: BoxDecoration(
                  color: kBlueGrey, borderRadius: BorderRadius.circular(21)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(21),
                        topRight: Radius.circular(21)),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: screenHeight * 0.3,
                          maxWidth: screenWidth - 30),
                      child: SingleChildScrollView(
                        child: Image.network(
                          model.imageURL,
                          fit: BoxFit.cover,
                          frameBuilder: restaurantTileFrameBuilder,
                          width: screenWidth - 30,
                          cacheWidth: (screenWidth - 30).round(),
                          errorBuilder: (_, _, _) => Container(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 8, top: 10, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            model.title,
                            style: MyFonts.w600.size(16).setColor(kWhite),
                          ),
                        ),
                        ClaimCallButton(
                          model: model,
                          parentContext: parentContext,
                        ),
                      ],
                    ),
                  ),
                  submitClaimDetails,
                  priceOrLocation,
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.2,
                        maxWidth: screenWidth - 40),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 5),
                        child: Text(
                          "Description: ${model.description}",
                          style: MyFonts.w300.size(14).setColor(kGrey10),
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.2,
                        maxWidth: screenWidth - 40),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 13),
                        child: Text(
                          "Posted By: ${model.email}",
                          style: MyFonts.w300.size(14).setColor(kGrey10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 16, bottom: 16),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${model.date.day}-${model.date.month}-${model.date.year} | ${DateFormat.jm().format(model.date.toLocal())}",
                      style: MyFonts.w300.size(13).setColor(kGrey7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
