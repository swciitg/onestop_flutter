import 'package:intl/intl.dart';

bool hasLeft(String inputTime) {
  var currentTime = DateTime.now();
  List<String> currentHour =
      DateFormat.j().format(currentTime).toString().split(' ');
  List<String> inputHour = inputTime.split(' ');

  //Checking if both AM or both PM
  if (inputHour[1] == currentHour[1]) {
    List<String> hm = inputHour[0].split(':');
    int a = int.parse(hm[0]);
    int b = int.parse(currentHour[0]);

    if (a == 12) {
      a = 0;
    }
    if (b == 12) {
      b = 0;
    }

    //Checking if both have same hour
    if (a > b) {
      return false;
    } else if (a < b) {
      return true;
    } else {
      //Checking if both have same minute
      a = int.parse(hm[1]);
      b = int.parse(DateFormat.m().format(currentTime));
      if (a > b) {
        return false;
      } else {
        return true;
      }
    }
  } else {
    if (inputHour[1] == 'AM') {
      return true;
    } else {
      return false;
    }
  }
}
