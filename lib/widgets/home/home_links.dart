import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';

class HomeLinks extends StatelessWidget {
  final List<HomeTabTile> links;
  final String title;
  const HomeLinks({Key? key, required this.links, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return links.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kHomeTile,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        title,
                        style: MyFonts.w500.size(16).setColor(kWhite),
                      ),
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      shrinkWrap: true,
                      children: links,
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
