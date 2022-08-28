import 'package:flutter/foundation.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/services/local_storage.dart';

Map<String, List<String>> recordNames = {
  "food": ["Restaurant"],
  "travel": ["BusTimings", "FerryTimings"],
  "menu": ["MessMenu"],
  "contact": ["Contact"]
};

Future<bool> checkLastUpdated() async {
  Map<String, dynamic>? lastUpdated = await DataProvider.getLastUpdated();

  try {
    Map<String, dynamic> last = await APIService.getLastUpdated();

    if (lastUpdated == null) {
      await LocalStorage.instance.deleteAllRecord();
      await LocalStorage.instance.storeData([last], 'LastUpdated');
      return true;
    }
    for (var key in lastUpdated.keys) {
      if (lastUpdated[key] != last[key]) {
        recordNames[key]?.forEach((element) async {
          await LocalStorage.instance.deleteRecord(element);
        });
      }
    }
    await LocalStorage.instance.storeData([last], 'LastUpdated');
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  return true;
}
