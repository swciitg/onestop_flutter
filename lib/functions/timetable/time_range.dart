String findTimeRange() {
  DateTime now1 = DateTime.now();
  if (now1.hour < 10 && now1.minute < 56) {
    return "09:00 - 09:55 AM";
  } else if (now1.hour >= 10 && now1.hour < 11 && now1.minute < 56) {
    return "10:00 - 10:55 AM";
  } else if (now1.hour >= 11 && now1.hour < 12 && now1.minute < 56) {
    return "11:00 - 11:55 AM";
  } else if (now1.hour >= 12 && now1.hour < 13 && now1.minute < 56) {
    return "12:00 - 12:55 PM";
  } else if (now1.hour >= 13 && now1.hour < 15 && now1.minute < 56) {
    return "02:00 - 02:55 PM";
  } else if (now1.hour >= 15 && now1.hour < 16 && now1.minute < 56) {
    return "03:00 - 03:55 PM";
  } else if (now1.hour >= 16 && now1.hour < 17 && now1.minute < 56) {
    return "04:00 - 04:55 PM";
  } else if (now1.hour >= 17 && now1.hour < 18 && now1.minute < 56) {
    return "05:00 - 05:55 PM";
  }
  return "";
}
