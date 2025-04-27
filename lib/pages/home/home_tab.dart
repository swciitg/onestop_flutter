import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/home/date_course.dart';
import 'package:onestop_dev/widgets/home/home_links.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:onestop_dev/widgets/home/service_links.dart';
import 'package:onestop_dev/widgets/mapbox/map_box.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import '../../functions/food/rest_frame_builder.dart';
import '../../models/home/home_image.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int activePageIndex = 0;
  String sel = '';
  Future<RegisteredCourses>? timetable;

  void callSetState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (!LoginStore.isGuest) {
      context.read<TimetableStore>().initialiseTT();
    }
  }

  @override
  Widget build(BuildContext context) {
    var mapStore = context.read<MapBoxStore>();
    mapStore.checkTravelPage(false);
    final imageWidth = 0.92 * MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          FutureBuilder<List<HomeImageModel>>(
              future: DataService.getHomeImageLinks(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: imageWidth,
                        color: kTimetableDisabled,
                        child: Center(
                          child: ErrorReloadButton(
                            reloadCallback: callSetState,
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasData == false) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: cachedImagePlaceholder(context, '')),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: MapBox(),
                  );
                }
                return Column(
                  children: [
                    CarouselSlider(
                      items: snapshot.data!.map((image) {
                        return GestureDetector(
                          onTap: () async {
                            final homeImageUrl = image.redirectUrl;
                            if (homeImageUrl.isNotEmpty) {
                              await launchUrl(Uri.parse(homeImageUrl),
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              width: imageWidth,
                              imageUrl: image.imageUrl,
                              placeholder: cachedImagePlaceholder,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                color: kTimetableDisabled,
                                child: Center(
                                  child: ErrorReloadButton(
                                    reloadCallback: callSetState,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: imageWidth,
                        viewportFraction: 1,
                        animateToClosest: false,
                        enableInfiniteScroll: false,
                        padEnds: false,
                        aspectRatio: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            activePageIndex = index;
                          });
                        },
                        autoPlayInterval: const Duration(seconds: 3),
                      ),
                    ),
                    SizedBox(height: snapshot.data!.length > 1 ? 10 : 0),
                    snapshot.data!.length <= 1
                        ? const SizedBox.shrink()
                        : DotsIndicator(
                            position: activePageIndex.toDouble(),
                            decorator: const DotsDecorator(
                              activeColor: OneStopColors.kWhite,
                              color: OneStopColors.cardColor,
                              spacing: EdgeInsets.symmetric(horizontal: 3),
                              size: Size(5, 5),
                              activeSize: Size(5, 5),
                            ),
                            dotsCount: snapshot.data!.length,
                          ),
                  ],
                );
              }),
          const SizedBox(height: 10),
          LoginStore.isGuest
              ? Container()
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DateCourse(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: HomeLinks(
              title: 'Services',
              links: serviceLinks,
              rows: 2,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: FutureBuilder<List<HomeTabTile>>(
                future: DataService.getQuickLinks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomeLinks(
                      links: snapshot.data!,
                      title: 'Quick Links',
                      rows: 2,
                    );
                  }
                  return ListShimmer(
                    count: 1,
                    height: 80,
                  );
                }),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
