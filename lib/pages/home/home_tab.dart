import 'package:flutter/material.dart';
import 'package:onestop_dev/models/timetable/registered_courses.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/home/date_course.dart';
import 'package:onestop_dev/widgets/home/home_links.dart';
import 'package:onestop_dev/widgets/home/quick_links.dart';
import 'package:onestop_dev/widgets/home/service_links.dart';
import 'package:onestop_dev/widgets/mapbox/map_box.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedIndex = 0;
  String sel = '';
  Future<RegisteredCourses>? timetable;

  void initState() {
    super.initState();
    print("Init state");
    context.read<TimetableStore>().setTimetable(
        context.read<LoginStore>().userData["rollno"] ?? "190101109");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Builder(builder: (context) {
            context.read<MapBoxStore>().checkTravelPage(false);
            return MapBox();
          }),
          SizedBox(
            height: 10,
          ),
          DateCourse(), // <-Put all UI and Observer within DateCourse()
          SizedBox(
            height: 10,
          ),
          HomeLinks(
            links: serviceLinks,
            title: 'Services',
          ),
          SizedBox(
            height: 10,
          ),
          HomeLinks(
            links: quickLinks,
            title: 'Quick Links',
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
