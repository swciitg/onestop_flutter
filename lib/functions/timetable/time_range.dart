import 'package:intl/intl.dart';

String findTimeRange() {
  DateFormat dateFormat = DateFormat("hh:00 - hh:55 a");
  return dateFormat.format(DateTime.now());
}
