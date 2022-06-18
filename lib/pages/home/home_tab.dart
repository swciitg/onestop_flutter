import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/home/date_course.dart';
import 'package:onestop_dev/widgets/home/quick_links.dart';
import 'package:onestop_dev/widgets/mapBox.dart';
import 'package:onestop_dev/models/timetable.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

double lat = userlat;
double long = userlong;

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

  void rebuildParent(int newSelectedIndex) {
    print('Reloaded');
    setState(() {
      selectedIndex = newSelectedIndex;
    });
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
          MapBox(
            lat: (lat != 0) ? lat : null,
            long: (long != 0) ? long : null,
            selectedIndex: selectedIndex,
            rebuildParent: rebuildParent,
            istravel: true,
          ),
          SizedBox(
            height: 10,
          ),
          DateCourse(), // <-Put all UI and Observer within DateCourse()
          SizedBox(
            height: 10,
          ),
          QuickLinks(),
          SizedBox(
            height: 10,
          ),
          // Services(),
          // SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}
