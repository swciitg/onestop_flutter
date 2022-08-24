import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/buySell/item_type_bar.dart';

class LostFoundButton extends StatelessWidget {
  const LostFoundButton(
      {Key? key,
        required this.selectedTypeController,
        required this.snapshot,
        required this.label,
        required this.category})
      : super(key: key);

  final StreamController selectedTypeController;
  final AsyncSnapshot snapshot;
  final String label;
  final String category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!snapshot.hasData) {
          return;
        } else {
          selectedTypeController.sink
              .add(snapshot.data! == "Lost" ? "Found" : "Lost");
        }
      },
      child: ItemTypeBar(
        text: label,
        margin: const EdgeInsets.only(left: 16, bottom: 10),
        textStyle: MyFonts.w500.size(14).setColor(snapshot.hasData == false
            ? kBlack
            : (snapshot.data! == category ? kBlack : kWhite)),
        backgroundColor: snapshot.hasData == false
            ? lBlue2
            : (snapshot.data! == category ? lBlue2 : kBlueGrey),
      ),
    );
  }
}