import 'package:onestop_dev/functions/travel/has_left.dart';

String nextTime(List<String> timings, {String firstTime = ''}) {
  String answer = "Nothing";
  print(timings);
  for (String time in timings) {
    if (!hasLeft(time)) {
      answer = time;
      break;
    }
  }
  if (answer == "Nothing") {
    if (firstTime == '') {
      answer = timings[0];
    } else {
      answer = firstTime;
    }
  }
  return answer;
}

int parseTime(String time) {
  var components = time.split(RegExp('[: ]'));
  if (components.length != 3) {
    throw FormatException('Time not in the expected format: $time');
  }
  var hours = int.parse(components[0]);
  var minutes = int.parse(components[1]);
  var period = components[2].toUpperCase();

  if (hours < 1 || hours > 12 || minutes < 0 || minutes > 59) {
    throw FormatException('Time not in the expected format: $time');
  }

  if (hours == 12) {
    hours = 0;
  }

  if (period == 'PM') {
    hours += 12;
  }

  return hours * 100 + minutes;
}
