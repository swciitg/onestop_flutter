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
  final int rows; // Number of rows as an argument

  const HomeLinks({
    Key? key,
    required this.links,
    required this.title,
    this.rows = 2, // Default number of rows set to 2
  }) : super(key: key);

  @override
  State<HomeLinks> createState() => _HomeLinksState();
}

class _HomeLinksState extends State<HomeLinks> {
  int activePageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Calculate the number of items per page (rows * columns)
    int itemsPerSlide = widget.rows * 4;

    return widget.links.isEmpty
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: kHomeTile,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    widget.title,
                    style: MyFonts.w500.size(16).setColor(kWhite),
                  ),
                ),
                CarouselSlider(
                  items: [
                    for (int i = 0; i < widget.links.length; i += itemsPerSlide)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: GridView.count(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          shrinkWrap: true,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          // Display a slice of the links based on current page
                          children: widget.links.sublist(
                            i,
                            (i + itemsPerSlide) > widget.links.length
                                ? widget.links.length
                                : (i + itemsPerSlide),
                          ),
                        ),
                      ),
                  ],
                  options: CarouselOptions(
                    viewportFraction: 1,
                    pageSnapping: true,
                    aspectRatio: (4 / widget.rows),
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
                if (widget.links.length > itemsPerSlide)
                  DotsIndicator(
                    position: activePageIndex,
                    decorator: const DotsDecorator(
                      activeColor: OneStopColors.kWhite,
                      color: OneStopColors.cardColor,
                      spacing: EdgeInsets.symmetric(horizontal: 3),
                      size: Size(5, 5),
                      activeSize: Size(5, 5),
                    ),
                    dotsCount: (widget.links.length / itemsPerSlide).ceil(),
                  ),
              ],
            ),
          );
  }
}
