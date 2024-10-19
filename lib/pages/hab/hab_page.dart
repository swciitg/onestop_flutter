import 'package:flutter/material.dart';
import 'package:onestop_dev/widgets/food/mess/mess_links.dart';
import 'package:onestop_kit/onestop_kit.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class HabPage extends StatelessWidget {
  static const String id = "/hab_page";

  const HabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        iconTheme: const IconThemeData(color: kAppBarGrey),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          "Hostel Affairs Board",
          textAlign: TextAlign.left,
          style: MyFonts.w500.size(20).setColor(kWhite),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.clear,
                color: kWhite,
              ))
        ],
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MessLinks(
                key: key,
              ))),
    );
  }
}
