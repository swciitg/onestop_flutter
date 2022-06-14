import 'package:intl/intl.dart';

bool hasLeft(String input_time)
{
  var current_time = DateTime.now();
  List<String>current_hour = DateFormat.j().format(current_time).toString().split(' ');
  List<String>input_hour = input_time.split(' ');

  //Checking if both AM or both PM
  if(input_hour[1] == current_hour[1])
  {
    List<String>hm = input_hour[0].split(':');
    int a = int.parse(hm[0]);
    int b = int.parse(current_hour[0]);

    if(a == 12) {a = 0;}
    if(b == 12) {b = 0;}

    //Checking if both have same hour
    if(a > b) {return false;}
    else if(a < b) {return true;}
    else
    {
      //Checking if both have same minute
      a = int.parse(hm[1]);
      b = int.parse(DateFormat.m().format(current_time));
      if(a > b){return false;}
      else{return true;}
    }
  }
  else
  {
    if(input_hour[1] ==  'AM') {return true;}
    else {return false;}
  }

}
