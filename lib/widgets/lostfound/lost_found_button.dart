import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/widgets/buy_sell/item_type_bar.dart';
import 'package:onestop_kit/onestop_kit.dart';

class LostFoundButton extends StatelessWidget {
  const LostFoundButton(
      {Key? key,
      required this.store,
      required this.label,
      required this.category})
      : super(key: key);

  final CommonStore store;
  final String label;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return GestureDetector(
        onTap: () {
          store.setLnfIndex(category);
        },
        child: ItemTypeBar(
          text: label,
          margin: const EdgeInsets.only(left: 16, bottom: 10),
          textStyle: MyFonts.w500
              .size(14)
              .setColor((store.lnfIndex == category ? kBlack : kWhite)),
          backgroundColor: (store.lnfIndex == category ? lBlue2 : kBlueGrey),
        ),
      );
    });
  }
}
