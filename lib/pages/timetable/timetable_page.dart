import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/timetable/timetable.dart';
import 'package:onestop_ui/index.dart';

/// Standalone routable page that wraps [TimeTableTab] with its own Scaffold.
/// Used when navigating to timetable from places outside the bottom nav
/// (e.g. the DateCourse chevron on the home tab).
class TimetablePage extends StatelessWidget {
  static const String id = '/timetable_page';

  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        surfaceTintColor: OColor.white,
        elevation: 0,
        iconTheme: IconThemeData(color: OColor.gray800),
        centerTitle: true,
        title: Text('Timetable', style: OTextStyle.headingMedium.copyWith(color: OColor.gray800)),
      ),
      body: const SafeArea(child: TimeTableTab()),
    );
  }
}
