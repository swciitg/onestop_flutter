import 'package:onestop_dev/functions/travel/has_left.dart';

String nextTime(List<String> timings, {String firstTime = ''}) {
  String answer = "Nothing";
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
