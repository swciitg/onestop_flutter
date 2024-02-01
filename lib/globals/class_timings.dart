bool isMorning(String timeString) {
  // Split the time string into start and end times
  List<String> parts = timeString.split(' - ');

  // Parse start time
  List<String> startTimeParts = parts[0].split(':');
  int startHour = int.parse(startTimeParts[0]);

  // Parse end time
  List<String> endTimeParts = parts[1].split(':');
  bool isAM = endTimeParts[1].split(' ')[1] == 'AM';

  if(startHour == 12 && !isAM)
    {
      return true;
    }
  else if(isAM)
    {
      return true;
    }

  return false;

}
