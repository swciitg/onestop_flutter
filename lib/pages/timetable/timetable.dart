import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/timetable/date_slider.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/widgets/ui/guest_restrict.dart';

class TimeTableTab extends StatefulWidget {
  static const String id = 'time';
  const TimeTableTab({Key? key}) : super(key: key);
  @override
  State<TimeTableTab> createState() => _TimeTableTabState();
}

class _TimeTableTabState extends State<TimeTableTab> {
  List<Map<int, List<List<String>>>> data1 = [];
  @override
  Widget build(BuildContext context) {
    return LoginStore.isGuest ? const GuestRestrictAccess() : SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 130,
            child: DateSlider(),
          ),
          const SizedBox(
            height: 10,
          ),
          Observer(builder: (context) {
            if (context.read<TimetableStore>().coursesLoaded) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount:
                      context.read<TimetableStore>().todayTimeTable.length,
                  itemBuilder: (context, index) =>
                      context.read<TimetableStore>().todayTimeTable[index]);
            }
            return ListShimmer();
          }),
        ],
      ),
    );
  }
}
