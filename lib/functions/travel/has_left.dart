bool hasLeft(DateTime s) {
  DateTime now = DateTime.now();
  return now.isAfter(updateDate(s));
}

DateTime updateDate(DateTime input) {
  input = input.toLocal();
  DateTime now = DateTime.now();
  return DateTime(
    now.year,
  now.month,
 now.day,
input.hour,
 input.minute,
 input.second,
  );
}