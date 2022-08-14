bool checkWeekday()
{
  DateTime date = DateTime.now();
  print(date); //2022-04-10 20:48:56.354 and sunday
  if(date.weekday == 6 || date.weekday == 7)
    {
      return false;
    }
  return true;
}
