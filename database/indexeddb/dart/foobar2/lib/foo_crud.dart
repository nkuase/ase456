import 'package:idb_shim/idb.dart' as idb;
import 'package:idb_shim/idb_browser.dart';
import 'package:web/web.dart';
import 'dart:js_interop';

const String dbName = "myDB";
const String storeName = "myStore";

Future<idb.Database> openDb() async {
  final idbFactory = idbFactoryBrowser;
  return await idbFactory.open(dbName, version: 1,
      onUpgradeNeeded: (idb.VersionChangeEvent e) {
    final db = (e.target as idb.Request).result;
    if (!db.objectStoreNames.contains(storeName)) {
      db.createObjectStore(storeName, autoIncrement: true);
    }
  });
}

Future<int> create(Map<String, dynamic> data) async {
  final db = await openDb();
  final txn = db.transaction(storeName, 'readwrite');
  final store = txn.objectStore(storeName);
  final key = await store.add(data);
  await txn.completed;
  return key as int;
}

Future<Map<String, dynamic>?> read(int key) async {
  final db = await openDb();
  final txn = db.transaction(storeName, 'readonly');
  final store = txn.objectStore(storeName);
  final result = await store.getObject(key);
  await txn.completed;
  if (result != null && result is Map) {
    return Map<String, dynamic>.from(result);
  }
  return null;
}

Future<List<Map<String, dynamic>>?> readAll() async {
  final db = await openDb();
  final txn = db.transaction(storeName, 'readonly');
  var store = txn.objectStore(storeName);
  var result = await store.getAll();
  await txn.completed;
  return List<Map<String, dynamic>>.from(result);
}

Future<void> update(int key, Map<String, dynamic> data) async {
  final db = await openDb();
  final txn = db.transaction(storeName, 'readwrite');
  final store = txn.objectStore(storeName);
  await store.put(data, key);
  await txn.completed;
}

Future<void> deleteRecord(int key) async {
  final db = await openDb();
  final txn = db.transaction(storeName, 'readwrite');
  final store = txn.objectStore(storeName);
  await store.delete(key);
  await txn.completed;
}
