import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/home/date_course.dart';
import 'package:onestop_dev/widgets/home/date_exam.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/widgets/home/home_auto_scroll_tile.dart';
import 'package:onestop_dev/widgets/home/home_food_tile.dart';
import 'package:onestop_dev/widgets/home/home_gatelog_tile.dart';
import 'package:onestop_dev/widgets/home/home_suggestion_tile.dart';
import 'package:onestop_dev/widgets/home/home_services.dart';
import 'package:onestop_dev/widgets/home/home_quick_links.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
// import 'package:onestop_dev/widgets/mapbox/map_box.dart';
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
    final imageWidth = MediaQuery.of(context).size.width - 16;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(OCornerRadius.l),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Search bar
              // _buildSearchBar(),
              // const SizedBox(height: 16),
              _imageCarousel(imageWidth),
              _buildTimeTableWidgets(),
              // Food and Gatelog tiles
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 220,
                  child: Row(
                    children: [
                      Expanded(
                        child: HomeAutoScrollTile(
                          duration: const Duration(seconds: 3),
                          children: [
                            HomeFoodTile(moveToFoodMenu: widget.moveToFoodMenuSection),
                            const HomeSuggestionTile(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: HomeGateLogTile()),
                    ],
                  ),
                ),
              ),
              HomeServices(),
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

  Widget _buildTimeTableWidgets() {
    if (LoginStore.isGuest) {
      return const SizedBox();
    }
    return Observer(
      builder: (context) {
        var store = context.read<TimetableStore>();
        // ExamMode mode = ExamMode.during;
        ExamMode mode = store.examMode;

        List<Widget> widgets = [];
        if (mode == ExamMode.upcoming) {
          widgets.add(DateExam(moveToTimeTableView: widget.moveToTimeTableView));
          widgets.add(const SizedBox(height: 8));
          widgets.add(DateCourse(moveToTimeTableView: widget.moveToTimeTableView));
        } else if (mode == ExamMode.during) {
          widgets.add(DateExam(moveToTimeTableView: widget.moveToTimeTableView));
        } else {
          widgets.add(DateCourse(moveToTimeTableView: widget.moveToTimeTableView));
        }

        return Column(mainAxisSize: MainAxisSize.min, children: widgets);
      },
    );
  }

  Widget _imageCarousel(double imageWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FutureBuilder<List<HomeImageModel>>(
        future: DataService.getHomeImageLinks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(OCornerRadius.l),
                child: Container(
                  height: imageWidth,
                  color: OColor.gray200,
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
            return const SizedBox.shrink();
            // return const Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: MapBox());
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
                                  color: OColor.gray200,
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
                    decorator: DotsDecorator(
                      activeColor: OColor.green600,
                      color: OColor.gray300,
                      spacing: EdgeInsets.symmetric(horizontal: 3),
                      size: Size(5, 5),
                      activeSize: Size(5, 5),
                    ),
                    dotsCount: snapshot.data!.length,
                  ),
            ],
          );
        },
      ),
    );
  }

  // Widget _buildSearchBar() {
  //   return GestureDetector(
  //     onTap: () {
  //       // TODO: Navigate to search screen
  //       print('Search bar tapped!');
  //     },
  //     child: Container(
  //       height: 48,
  //       decoration: BoxDecoration(
  //         color: OColor.white,
  //         borderRadius: BorderRadius.circular(16),
  //         border: Border.all(color: OColor.gray200),
  //         boxShadow: [
  //           BoxShadow(
  //             color: OColor.gray300.withValues(alpha: 0.1),
  //             blurRadius: 8,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16),
  //         child: Row(
  //           children: [
  //             OText(text: 'Search', style: OTextStyle.bodyMedium.copyWith(color: OColor.gray500)),
  //             const Spacer(),
  //             Icon(FluentIcons.search_24_regular, color: OColor.gray400, size: 20),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
