import 'package:onestop_dev/functions/travel/has_left.dart';

String nextTime(List<String>timings)
{
  String answer = "Nothing";
  for(String time in timings)
    {
      if(!hasLeft(time))
        {
          answer = time;
        }
    }
  if(answer == "Nothing")
    {
      answer = timings[0];
    }

  return "";
}
