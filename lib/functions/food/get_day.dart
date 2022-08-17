import 'package:intl/intl.dart';

String get_day(){
  DateTime now = DateTime.now();
  return DateFormat("EEE").format(now);
}

