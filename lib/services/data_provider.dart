import 'dart:async';

import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:path/path.dart' ;


class database {
  final String name;
  database({
    required this.name,
  });

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path,name);
  }

  Future openDatabase() async {
    var dbPath = await _localPath;
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  void storeData(Map<String, dynamic> data) async {
    var store = StoreRef.main();
    var db = await openDatabase();
    await store.add(db, data);
  }

  Future<List<dynamic>> readData() async {
    var store = StoreRef.main();
    var database = await openDatabase();
    final recordSnapshot = await store.find(database);
    var data = recordSnapshot.map((snapshot) {
      final object = snapshot.value;
      return object;
    }).toList();
    return data;
  }

  void delete() async {
    var db = await openDatabase();
    var dbPath = await _localPath;
    db.close();
    await databaseFactoryIo.deleteDatabase(dbPath);
    db = null;
  }
}

class RestaurantData {
  database dataBase = database(name: "Restaurant");
  void StoreData() async {
    var restaurants = await APIService.getRestaurantData();
    for (var restaurant in restaurants) {
      dataBase.storeData(restaurant);
    }
  }

  Future<List<RestaurantModel>> provideData() async {
    var restaurants = await dataBase.readData();
    List<RestaurantModel> restaurantData = [];
    for (var restaurant in restaurants) {
      restaurantData.add(RestaurantModel.fromJson(restaurant));
    }
    return restaurantData;
  }

  void deleteData() {
    dataBase.delete();
  }
}

class LocalStorage {

  LocalStorage._();

  static final LocalStorage _singleton = LocalStorage._();

  static LocalStorage get instance => _singleton;

  Completer<Database> _dbOpenCompleter = Completer();

  bool isOpen = false;

  Future<Database> get database async {
    if (!isOpen) {
      _openDatabase();
      isOpen = true;
    }
    return _dbOpenCompleter.future;
  }


  Future<void> _openDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, "onestop.db");
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter.complete(database);
  }

  Future<void> storeData(List<Map<String,dynamic>> json, String recordName) async {
    var store = StoreRef<String,List<Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    await store.record(recordName).put(localDB, json);
  }

  Future<void> deleteRecord(String recordName) async {
    var store = StoreRef<String,List<Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    await store.record(recordName).delete(localDB);
  }

  Future<List<Object?>?> getRecord(String recordName) async {
    var store = StoreRef<String,List<Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    List<Object?>? value = await store.record(recordName).get(localDB);
    return value;
  }

}

class DataProvider {
  static Future<List<RestaurantModel>> getRestaurants() async {
    // var store = StoreRef<String,List<Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    // await LocalStorage.instance.deleteRecord("Restaurant");
    // await store.record("Restaurant").delete(localDB);
    // var cachedData = await store.record("Restaurant").get(localDB) ;
    var cachedData = await LocalStorage.instance.getRecord("Restaurant");
    if (cachedData == null) {
      print("Restaurant Data not in Cache. Using API...");
      List<Map<String,dynamic>> restaurantData = await APIService.getRestaurantData();
      // await store.record("Restaurant").put(localDB,restaurantData);
      List<RestaurantModel> restaurants = restaurantData.map((e) => RestaurantModel.fromJson(e)).toList();
      await LocalStorage.instance.storeData(restaurantData, "Restaurant");
      return restaurants;
    }
    print("Restaurant Data Exists in Cache");
    return cachedData.map((e) => RestaurantModel.fromJson(e as Map<String,dynamic>)).toList();
  }
}
