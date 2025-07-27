import 'dart:html';
import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

// Database config
const dbName = 'my_db';
const storeName = 'my_store';

// Open database and create object store if necessary
Future<Database> openDb() async {
  var dbFactory = idbFactoryBrowser;
  return await dbFactory.open(dbName, version: 1, onUpgradeNeeded: (e) {
    var db = e.database;
    if (!db.objectStoreNames.contains(storeName)) {
      db.createObjectStore(storeName, autoIncrement: true);
    }
  });
}

// CREATE
Future<int> addItem(Database db, Map<String, dynamic> item) async {
  var txn = db.transaction(storeName, idbModeReadWrite);
  var store = txn.objectStore(storeName);
  var key = await store.add(item);
  await txn.completed;
  return key as int;
}

// READ
Future<List<Map<String, dynamic>>> getAllItems(Database db) async {
  var txn = db.transaction(storeName, idbModeReadOnly);
  var store = txn.objectStore(storeName);
  var items = await store.getAll();
  await txn.completed;
  return List<Map<String, dynamic>>.from(items);
}

// UPDATE
Future<void> updateItem(Database db, int key, Map<String, dynamic> updated) async {
  var txn = db.transaction(storeName, idbModeReadWrite);
  var store = txn.objectStore(storeName);
  await store.put(updated, key);
  await txn.completed;
}

// DELETE
Future<void> deleteItem(Database db, int key) async {
  var txn = db.transaction(storeName, idbModeReadWrite);
  var store = txn.objectStore(storeName);
  await store.delete(key);
  await txn.completed;
}
void showOutput(String message) {
  final pre = document.createElement('pre');
  pre.text = message;
  document.body?.append(pre);
}

void main() async {
  var db = await openDb();

  // CREATE
  int key = await addItem(db, {"foo": "Alice", "bar": 42});
  showOutput('Item added with key: $key');

  // READ
  var items = await getAllItems(db);
  showOutput('All items: $items');

  // UPDATE
  await updateItem(db, key, {"foo": "Alice Updated", "bar": 99});
  showOutput('Item updated.');

  // DELETE
  await deleteItem(db, key);
  showOutput('Item deleted.');
}

