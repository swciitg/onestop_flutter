import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/home/date_course.dart';
import 'package:onestop_dev/widgets/home/home_food_tile.dart';
import 'package:onestop_dev/widgets/home/home_gatelog_tile.dart';
import 'package:onestop_dev/widgets/home/home_links.dart';
import 'package:onestop_dev/widgets/home/home_quick_links.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:onestop_dev/widgets/home/service_links.dart';
import 'package:onestop_dev/widgets/mapbox/map_box.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import '../../functions/food/rest_frame_builder.dart';
import '../../models/home/home_image.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback moveToTimeTableView;
  final VoidCallback moveToFoodMenuSection;
  const HomeTab({
    super.key,
    required this.moveToTimeTableView,
    required this.moveToFoodMenuSection,
  });

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Search bar
              _buildSearchBar(),
              const SizedBox(height: 16),

              _imageCarousel(imageWidth),
              const SizedBox(height: 10),
              LoginStore.isGuest
                  ? const SizedBox()
                  : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [DateCourse(moveToTimeTableView: widget.moveToTimeTableView)],
                  ),
              // Food and Gatelog tiles
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(child: HomeFoodTile(moveToFoodMenu: widget.moveToFoodMenuSection)),
                      const SizedBox(width: 12),
                      Expanded(child: HomeGateLogTile()),
                    ],
                  ),
                ),
              ),
              HomeQuickAccess(links: serviceLinks),
              const SizedBox(height: 10),
              FutureBuilder<List<HomeServiceTile>>(
                future: DataService.getQuickLinks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomeQuickLinks(links: snapshot.data!);
                  }
                  return ListShimmer(count: 1, height: 80);
                },
              ),
              const SizedBox(height: 160),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<HomeImageModel>> _imageCarousel(double imageWidth) {
    return FutureBuilder<List<HomeImageModel>>(
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
                child: Center(child: ErrorReloadButton(reloadCallback: callSetState)),
              ),
            ),
          );
        } else if (snapshot.hasData == false) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: cachedImagePlaceholder(context, ''),
            ),
          );
        } else if (snapshot.data!.isEmpty) {
          return const Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: MapBox());
        }
        return Column(
          children: [
            CarouselSlider(
              items:
                  snapshot.data!.map((image) {
                    return GestureDetector(
                      onTap: () async {
                        final homeImageUrl = image.redirectUrl;
                        if (homeImageUrl.isNotEmpty) {
                          await launchUrl(
                            Uri.parse(homeImageUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          width: imageWidth,
                          imageUrl: image.imageUrl,
                          placeholder: cachedImagePlaceholder,
                          fit: BoxFit.cover,
                          errorWidget:
                              (context, url, error) => Container(
                                color: kTimetableDisabled,
                                child: Center(
                                  child: ErrorReloadButton(reloadCallback: callSetState),
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
      },
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to search screen
        print('Search bar tapped!');
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: OColor.gray200),
          boxShadow: [
            BoxShadow(
              color: OColor.gray300.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              OText(text: 'Search', style: OTextStyle.bodyMedium.copyWith(color: OColor.gray500)),
              const Spacer(),
              Icon(FluentIcons.search_24_regular, color: OColor.gray400, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
