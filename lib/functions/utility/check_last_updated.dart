import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/services/local_storage.dart';

Map<String,List<String>> recordNames = {
  "food": ["Restaurant"],
  "travel": ["BusTimings", "FerryTimings"],
  "menu": ["MessMenu"],
  "contact": ["Contact"]
};

Future<bool> checkLastUpdated() async{
  Map<String, dynamic>? lastUpdated = await DataProvider.getLastUpdated();
  Map<String,dynamic> last = await APIService.getLastUpdated();
  if(lastUpdated == null)
    {
      LocalStorage.instance.deleteAllRecord();
      LocalStorage.instance.storeData([last], 'LastUpdated');
      return true;
    }
  for(var key in lastUpdated.keys)
    {
      if(lastUpdated[key] != last[key])
        {
          recordNames[key]?.forEach((element) { LocalStorage.instance.deleteRecord(element);});
        }
    }

  return true;
}

