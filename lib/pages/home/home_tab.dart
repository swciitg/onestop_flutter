import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/home/date_course.dart';
import 'package:onestop_dev/widgets/home/home_links.dart';
import 'package:onestop_dev/widgets/home/quick_links.dart';
import 'package:onestop_dev/widgets/home/service_links.dart';
import 'package:onestop_dev/widgets/mapbox/map_box.dart';
import 'package:provider/provider.dart';
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
                child: CachedNetworkImage(
                  maxHeightDiskCache: 300,
                  imageUrl: Endpoints.baseUrl + Endpoints.homeImage,
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  placeholder: cachedImagePlaceholder,
                  errorWidget: (context, url, error) => const MapBox(),
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
          HomeLinks(
            links: quickLinks,
            title: 'Quick Links',
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
