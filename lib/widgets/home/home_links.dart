import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:onestop_kit/onestop_kit.dart';

class HomeLinks extends StatelessWidget {
  final List<HomeTabTile> links;
  final String title;

  const HomeLinks({Key? key, required this.links, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return links.isEmpty
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: kHomeTile,
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      title,
                      style: MyFonts.w500.size(16).setColor(kWhite),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    shrinkWrap: true,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    physics: const NeverScrollableScrollPhysics(),
                    children: links,
                  ),
                ],
              ),
            ),
          );
  }
}
