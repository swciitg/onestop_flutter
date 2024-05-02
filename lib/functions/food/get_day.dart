import 'package:intl/intl.dart';

String getFormattedDay() {
  DateTime now = DateTime.now();
  return DateFormat("EEE").format(now);
}

String getFormattedDayForMess() {
  DateTime now = DateTime.now();
  return DateFormat("EEEE").format(now);
}
