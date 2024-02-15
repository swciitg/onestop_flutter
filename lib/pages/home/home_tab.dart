import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/home/date_course.dart';
import 'package:onestop_dev/widgets/home/home_links.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:onestop_dev/widgets/home/service_links.dart';
import 'package:onestop_dev/widgets/mapbox/map_box.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../functions/food/rest_frame_builder.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedIndex = 0;
  String sel = '';
  Future<RegisteredCourses>? timetable;

  @override
  void initState() {
    super.initState();
    if (!LoginStore.isGuest) {
      context.read<TimetableStore>().initialiseTT();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    print("here");
                    String homeImageUrl = await DataProvider.getHomeImageLink();
                    if (homeImageUrl.isNotEmpty) {
                      await launchUrl(Uri.parse(homeImageUrl),
                          mode: LaunchMode.externalApplication);
                    } else {
                      print("error");
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: Endpoints.baseUrl + Endpoints.homeImage,
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      placeholder: cachedImagePlaceholder,
                      errorWidget: (context, url, error) => const MapBox(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          LoginStore.isGuest
              ? Container()
              : const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DateCourse(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
          HomeLinks(title: 'Services', links: serviceLinks),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<List<HomeTabTile>>(
              future: DataProvider.getQuickLinks(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return HomeLinks(
                    links: snapshot.data!,
                    title: 'Quick Links',
                  );
                }
                return ListShimmer(
                  count: 1,
                  height: 80,
                );
              }),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
