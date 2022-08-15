import 'package:add_2_calendar/add_2_calendar.dart';

Event buildEvent({required String title}) {
  return Event(
    title: title,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(hours: 1)),
  );
}

