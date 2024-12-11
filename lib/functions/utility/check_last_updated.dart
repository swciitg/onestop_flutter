import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:onestop_dev/functions/utility/connectivity.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/repository/api_repository.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/services/local_storage.dart';

Map<String, List<String>> recordNames = {
  "foodOutlet": [DatabaseRecords.restaurant],
  "timing": [DatabaseRecords.busTimings, DatabaseRecords.ferryTimings],
  "messMenu": [DatabaseRecords.messMenu],
  "contact": [DatabaseRecords.contacts],
  "timetable": [DatabaseRecords.timetable],
  "homePage": [DatabaseRecords.homePage]
};

Future<bool> checkLastUpdated() async {
  bool isConnected = await hasInternetConnection();
  if (!isConnected) {
    //skipping check if not connected to the internet
    return true;
  }

  Map<String, dynamic>? lastUpdated = await DataService.getLastUpdated();

  try {
    Map<String, dynamic> last = await APIRepository().getLastUpdated();

    if (lastUpdated == null) {
      await LocalStorage.instance.deleteAllRecord();
      await LocalStorage.instance
          .storeListRecord([last], DatabaseRecords.lastUpdated);
      return true;
    }
    for (var key in lastUpdated.keys) {
      if (lastUpdated[key] != last[key]) {
        if (key == "homePage") {
          await DefaultCacheManager().emptyCache();
        }
        recordNames[key]?.forEach((element) async {
          await LocalStorage.instance.deleteRecord(element);
        });
      }
    }
    await LocalStorage.instance
        .storeListRecord([last], DatabaseRecords.lastUpdated);
  } catch (e) {
    return true;
  }
  return true;
}
