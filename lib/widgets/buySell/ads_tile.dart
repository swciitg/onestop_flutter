import 'dart:ffi';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/buysell/buy_model.dart';
import 'package:http/http.dart' as http;

import 'details_dialog.dart';

class MyAdsTile extends StatefulWidget {
  final BuyModel model;

  MyAdsTile({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<MyAdsTile> createState() => _MyAdsTile();
}

class _MyAdsTile extends State<MyAdsTile> {
  late Widget TileSate;
  bool isOverlay = false;
  @override
  void initState() {
    super.initState();
    TileSate = AdsTileState(context, widget.model, isOverlay);
  }

  Widget AdsTileState(context, model, bool overlay) {
    if (overlay) {
      return Stack(
        children: [
          GestureDetector(
            onTap: () {
              detailsDialogBox(context, model);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
              child: Container(
                height: 115,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  color: kBlueGrey.withAlpha(80),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Icon(
                                        FluentIcons.more_vertical_28_filled,
                                        size: 15,
                                        color: kWhite.withAlpha(80),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      model.title,
                                      style: MyFonts.w600
                                          .size(16)
                                          .setColor(kWhite.withAlpha(80)),
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
                                      style: MyFonts.w500
                                          .size(12)
                                          .setColor(kGrey6.withAlpha(80)),
                                    ),
                                  ),
                                  //TODO::Implemnt the correct design
                                  Expanded(
                                    child: Text(
                                      '\u{20B9}${model.phonenumber}/-',
                                      style: MyFonts.w600
                                          .size(14)
                                          .setColor(lBlue4.withAlpha(80)),
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
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(21),
                            bottomRight: Radius.circular(21)),
                        child: Opacity(
                          opacity: 0.25,
                          child: Image.network(
                            model.imageURL,
                            fit: BoxFit.cover,
                            color: kBlack,
                            colorBlendMode: BlendMode.overlay,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(52.0, 19.0, 15.0, 0.0),
            child: Container(
              height: 33,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: lBlue2,
              ),
              child: TextButton(
                child: Text(
                  "Delete",
                  style: MyFonts.w400.size(14).setColor(kBlack),
                ),
                onPressed: () {
                  // Navigator.of(context).pop();
                  setState(() async {
                    await http.post(
                        Uri.parse("https://swc.iitg.ac.in/onestopapi/myads"),
                        body: {'ID': model.id!.trim()});
                    TileSate = AdsTileState(context, model, false);
                  });
                },
                onFocusChange: (change) {
                  print(!change);
                  setState(() {
                    TileSate = AdsTileState(context, model, !change);
                  });
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return GestureDetector(
        onTap: () {
          detailsDialogBox(context, model);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      TileSate =
                                          AdsTileState(context, model, true);
                                    });
                                  },
                                  child: Icon(
                                    FluentIcons.more_vertical_28_filled,
                                    size: 15,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
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
                                ),
                              ),
                              //TODO::Implemnt the correct design
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
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(21),
                        bottomRight: Radius.circular(21)),
                    child: Image.network(model.imageURL, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TileSate;
  }
}
