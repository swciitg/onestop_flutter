import 'package:cab_sharing/cab_sharing.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:provider/provider.dart';

class HomeLinks extends StatelessWidget {
  final List<HomeTabTile> links;
  final String title;
  const HomeLinks({Key? key, required this.links, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widgetHeight = (links.length > 4) ? 230 : 140;
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
            ),
            if (links.length > 4) ...[
              Expanded(
                flex: 2,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    links[4],
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(child: Container()),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(child: Container()),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(child: Container()),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
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
