import 'dart:async';

import 'package:onestop_dev/globals/database_strings.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

class LocalStorage {
  LocalStorage._();

  static final LocalStorage _singleton = LocalStorage._();

  static LocalStorage get instance => _singleton;

  final Completer<Database> _dbOpenCompleter = Completer();

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

  Future<void> storeJsonRecord(
      Map<String, dynamic> busTime, String recordName) async {
    var store = StoreRef<String, Map<String, Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    await store.record(recordName).put(localDB, busTime);
  }

  Future<Map<String, Object?>?> getJsonRecord(String recordName) async {
    var store = StoreRef<String, Map<String, Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    Map<String, Object?>? value = await store.record(recordName).get(localDB);
    return value;
  }

  Future<void> storeListRecord(
      List<Map<String, dynamic>> json, String recordName) async {
    var store = StoreRef<String, List<Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    await store.record(recordName).put(localDB, json);
  }

  Future<List<Object?>?> getListRecord(String recordName) async {
    var store = StoreRef<String, List<Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    List<Object?>? value = await store.record(recordName).get(localDB);
    return value;
  }

  Future<void> deleteRecord(String recordName) async {
    var store = StoreRef<String, List<Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    await store.record(recordName).delete(localDB);
  }

  Future<void> deleteAllRecord() async {
    var store = StoreRef<String, List<Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    await store.record(DatabaseRecords.busTimings).delete(localDB);
    await store.record(DatabaseRecords.restaurant).delete(localDB);
    await store.record(DatabaseRecords.contacts).delete(localDB);
    await store.record(DatabaseRecords.messMenu).delete(localDB);
    await store.record(DatabaseRecords.ferryTimings).delete(localDB);
    await store.record(DatabaseRecords.timetable).delete(localDB);
  }

  Future<void> deleteRecordsLogOut() async {
    var store = StoreRef<String, List<Object?>>.main();
    Database localDB = await LocalStorage.instance.database;
    await store.record(DatabaseRecords.timetable).delete(localDB);
  }
}
