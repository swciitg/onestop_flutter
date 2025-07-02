import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/components/text.dart';
import 'package:onestop_ui/utils/colors.dart';
import 'package:onestop_ui/utils/styles.dart';

class OutletsFilter extends StatelessWidget {
  const OutletsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            alignment: Alignment.bottomLeft,
            child: OText(
              text: "Food Outlets",
              selectable: false,
              style: OTextStyle.headingMedium.copyWith(
                fontSize: screenWidth < 600 ? 20 : 24,
                color: OColor.gray800,
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 5,
        // ),
        // Expanded(
        //   child: ListView(
        //     scrollDirection: Axis.horizontal,
        //     children: [
        //       OutletsFilterTile(
        //         filterText: "All",
        //         selected: true,
        //       ),
        //       OutletsFilterTile(filterText: "Snacks"),
        //       OutletsFilterTile(filterText: "Cakes"),
        //       OutletsFilterTile(filterText: "South Indian"),
        //       OutletsFilterTile(filterText: "North Indian"),
        //       OutletsFilterTile(filterText: "Non Veg")
        //     ],
        //   ),
        // )
      ],
    );
  }
}
