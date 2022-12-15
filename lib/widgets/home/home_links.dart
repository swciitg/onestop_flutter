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
    assert(links.length <= 8);
    final double widgetHeight = (links.length > 4) ? 230 : 140;
    // Add dummy expanded for the row
    List<Widget> completeList = List.generate(
        (links.length > 4) ? 8 : 4, (index) => Expanded(child: Container()));
    for (int i = 0; i < links.length; i++) {
      completeList[i] = links[i];
    }
    // Add SizedBox between every widget in a row
    List<Widget> rowChildren = List.generate(
      2 * completeList.length + 1,
      (index) => const SizedBox(width: 5),
    );
    for (int i = 0; i < completeList.length; i++) {
      rowChildren[2 * i + 1] = completeList[i];
    }
    return Container(
      height: widgetHeight,
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
                children: rowChildren.sublist(0, 9),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            if (links.length > 4) ...[
              Expanded(
                flex: 2,
                child: Row(
                  children: rowChildren.sublist(8),
                ),
              ),
              const SizedBox(
                height: 5,
              )
            ]
          ],
        ),
      ),
    );
  }
}
