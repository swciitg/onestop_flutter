String get_day(){
  DateTime now = DateTime.now();
  if(now.weekday == 2)
  {
    return "Tuesday";
  }
  else if(now.weekday == 3)
  {
    return "Wednesday";
  }
  else if(now.weekday == 4)
  {
    return "Thrusday";
  }
  else if(now.weekday == 5)
  {
    return "Friday";
  }
  else if(now.weekday == 6)
  {
    return "Saturday";
  }
  else if(now.weekday == 7)
  {
    return "Sunday";
  }
  return "Monday";
}

