import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:onestop_dev/services/api.dart';

class database {
  final String name;
  database({
    required this.name,
  });

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/${name}.db';
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
  RestaurantService restaurantService = RestaurantService();
  void StoreData() async {
    var restaurants = await restaurantService.getData();
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
