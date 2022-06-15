import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class OutletsFilter extends StatelessWidget {
  const OutletsFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Outlets near you",
                  style: MyFonts.w600.size(14).setColor(kWhite),
                )),
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
      ),
    );
  }
}
