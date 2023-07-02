import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, List<String>> recordNames = {
  "foodOutlet": [DatabaseRecords.restaurant],
  "timing": [DatabaseRecords.busTimings, DatabaseRecords.ferryTimings],
  "messMenu": [DatabaseRecords.messMenu],
  "contact": [DatabaseRecords.contacts]
};

Future<bool> checkLastUpdated() async {
  Map<String, dynamic>? lastUpdated = await DataProvider.getLastUpdated();

  try {
    Map<String, dynamic> last = await APIService().getLastUpdated();

    if (lastUpdated == null) {
      await LocalStorage.instance.deleteAllRecord();
      await LocalStorage.instance
          .storeData([last], DatabaseRecords.lastUpdated);
      return true;
    }
    for (var key in lastUpdated.keys) {
      if (lastUpdated[key] != last[key]) {
        recordNames[key]?.forEach((element) async {
          await LocalStorage.instance.deleteRecord(element);
        });
      }
    }
    await LocalStorage.instance.storeData([last], DatabaseRecords.lastUpdated);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  return true;
}
