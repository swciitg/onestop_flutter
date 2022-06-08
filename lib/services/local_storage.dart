import 'dart:async';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' ;

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
