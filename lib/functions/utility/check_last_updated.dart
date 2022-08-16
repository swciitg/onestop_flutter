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
  print("checkUpdated called");
  Map<String, dynamic>? lastUpdated = await DataProvider.getLastUpdated();
  print(lastUpdated);
  Map<String,dynamic> last = await APIService.getLastUpdated();
  print(last);
  if(lastUpdated == null)
    {
      await LocalStorage.instance.deleteAllRecord();
      await LocalStorage.instance.storeData([last], 'LastUpdated');
      return true;
    }
  for(var key in lastUpdated.keys)
    {
      if(lastUpdated[key] != last[key])
        {
          print('Key mismatch $key');
           recordNames[key]?.forEach((element) async { await LocalStorage.instance.deleteRecord(element);});
        }
    }
    await LocalStorage.instance.storeData([last], 'LastUpdated');
    lastUpdated = await DataProvider.getLastUpdated();
    print(lastUpdated);

  return true;
}

