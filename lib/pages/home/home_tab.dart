import 'package:flutter/material.dart';
import 'package:onestop_dev/globals.dart';
import 'package:onestop_dev/pages/timetable/ApiCallingTimetable.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/home/date_course.dart';
import 'package:onestop_dev/widgets/home/quick_links.dart';
import 'package:onestop_dev/widgets/mapBox.dart';
import 'package:onestop_dev/models/timetable.dart';
import 'package:provider/provider.dart';

import '../../functions/timetable/Functions.dart';

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
  Future<Time>? timetable;

  void initState() {
    timetable = ApiCalling().getTimeTable(
        roll: context.read<LoginStore>().userData["rollno"] ?? "200101095");
    super.initState();
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
          FutureBuilder<Time>(
            future: timetable,
            builder: (BuildContext context, AsyncSnapshot<Time> snapshot) {
              if (snapshot.hasData) {
                List<Map<int, List<List<String>>>> data =
                    ApiCalling().addWidgets(data: snapshot.data!);
                sel=determiningSel();
                return DateCourse(
                  sel: sel,
                  data: data,
                );
              } else if (snapshot.hasError) {
                Future.delayed(Duration.zero, () => reload(context));
                return SizedBox();
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
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
