import 'package:flutter/material.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/models/buysell/buy_model.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

void detailsDialogBox(context, dynamic model) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Widget priceOrLocation;
        if (model is BuyModel) {
          priceOrLocation = Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Text(
              "Price: " + model.price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: MyFonts.w500.size(14).setColor(kGrey6),
            ),
          );
        } else {
          priceOrLocation = Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Text(
              "Lost at: " + model.location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: MyFonts.w500.size(14).setColor(kGrey6),
            ),
          );
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 15),
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
                  // Container(
                  //   width: screenWidth-30,
                  // ), // to match listtile width
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(21),
                        topRight: Radius.circular(21)),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: screenHeight * 0.3,
                          maxWidth: screenWidth - 30),
                      child: SingleChildScrollView(
                        child: FadeInImage(
                          width: screenWidth - 30,
                          placeholder: AssetImage("assets/images/loading.gif"),
                          image: NetworkImage(model.imageURL),
                          fit: BoxFit.cover,
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
                        GestureDetector(
                          onTap: () async {
                            await launchPhoneURL("tel:+91${model.phonenumber}");
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                  color: kGrey9,
                                  borderRadius: BorderRadius.circular(24)),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 11,
                                    color: lBlue2,
                                  ),
                                  Text(
                                    " Call",
                                    style:
                                        MyFonts.w500.size(11).setColor(lBlue2),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  priceOrLocation,
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.2,
                        maxWidth: screenWidth - 40),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 13),
                        child: Text(
                          "Description: " + model.description,
                          style: MyFonts.w300.size(14).setColor(kGrey10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 16, bottom: 16),
                    alignment: Alignment.centerRight,
                    child: Text(
                      model.date.day.toString() +
                          "-" +
                          model.date.month.toString() +
                          "-" +
                          model.date.year.toString() +
                          " | " +
                          DateFormat.jm()
                              .format(model.date.toLocal())
                              .toString(),
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
