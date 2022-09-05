import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';

class HomeLinks extends StatelessWidget {
  final List<HomeTabTile> links;
  final String title;
  const HomeLinks({Key? key, required this.links, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kHomeTile,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    title,
                    style: MyFonts.w500.size(10).setColor(kWhite),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  links[0],
                  const SizedBox(
                    width: 5,
                  ),
                  links[1],
                  const SizedBox(
                    width: 5,
                  ),
                  links[2],
                  const SizedBox(
                    width: 5,
                  ),
                  links[3],
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
