import 'package:intl/intl.dart';

String durationLeft(String time)
{
  DateFormat dateFormat = DateFormat("hh:mm a");
  DateTime inputTime = dateFormat.parse(time);
  DateTime nowTime = dateFormat.parse(dateFormat.format(DateTime.now()));
  Duration diff = inputTime.add(const Duration(days:1)).difference(nowTime);
  int ans = diff.inHours;
  if(ans >= 24)
  {
    ans -= 24;
  }

  if(ans >= 1)
  {

    return '$ans hrs';
  }
  else
  {
    ans = diff.inMinutes;
    if(ans > 1440)
    {
      ans -= 1440;
    }

    return '${ans}min';
  }
}