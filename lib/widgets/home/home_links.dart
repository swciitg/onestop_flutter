import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:onestop_kit/onestop_kit.dart';

class HomeLinks extends StatefulWidget {
  final List<HomeTabTile> links;
  final String title;

  const HomeLinks({Key? key, required this.links, required this.title})
      : super(key: key);

  @override
  State<HomeLinks> createState() => _HomeLinksState();
}

class _HomeLinksState extends State<HomeLinks> {
  int activePageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.links.isEmpty
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: kHomeTile,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      widget.title,
                      style: MyFonts.w500.size(16).setColor(kWhite),
                    ),
                  ),
                  CarouselSlider(
                    items: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GridView.count(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          shrinkWrap: true,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          children: widget.links.length <= 8
                              ? widget.links
                              : widget.links.sublist(0, 8),
                        ),
                      ),
                      if (widget.links.length > 8)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GridView.count(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            shrinkWrap: true,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            physics: const NeverScrollableScrollPhysics(),
                            children: widget.links.sublist(8),
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                      viewportFraction: 1,
                      pageSnapping: true,
                      aspectRatio: 2,
                      autoPlay: false,
                      animateToClosest: false,
                      enableInfiniteScroll: false,
                      padEnds: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          activePageIndex = index;
                        });
                      },
                    ),
                  ),
                  if (widget.links.length > 8)
                    DotsIndicator(
                      position: activePageIndex,
                      decorator: const DotsDecorator(
                        activeColor: OneStopColors.kWhite,
                        color: OneStopColors.cardColor,
                        spacing: EdgeInsets.symmetric(horizontal: 3),
                        size: Size(5, 5),
                        activeSize: Size(5, 5),
                      ),
                      dotsCount: (widget.links.length / 8).ceil(),
                    )
                ],
              ),
            ),
          );
  }
}
