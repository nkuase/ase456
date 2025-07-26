import 'dart:indexed_db';
import 'dart:html';

const String dbName = "FooBarDB_Dart";
const String storeName = "myStore";

Future<Database> openDb() async {
  return await window.indexedDB!.open(dbName, version: 1,
      onUpgradeNeeded: (e) {
    final db = (e.target as OpenDBRequest).result as Database;
    if (!db.objectStoreNames!.contains(storeName)) {
      db.createObjectStore(storeName, autoIncrement: true);
    }
  });
}

Future<int> create(Map<String, dynamic> data) async {
  final db = await openDb();
  final tx = db.transaction(storeName, 'readwrite');
  final store = tx.objectStore(storeName);
  final key = await store.add(data);
  await tx.completed;
  return key as int;
}

Future<Map<String, dynamic>?> read(int key) async {
  final db = await openDb();
  final tx = db.transaction(storeName, 'readonly');
  final store = tx.objectStore(storeName);
  final result = await store.getObject(key);
  await tx.completed;
  return result != null ? Map<String, dynamic>.from(result as Map) : null;
}

Future<void> update(int key, Map<String, dynamic> data) async {
  final db = await openDb();
  final tx = db.transaction(storeName, 'readwrite');
  final store = tx.objectStore(storeName);
  await store.put(data, key);
  await tx.completed;
}

Future<void> deleteRecord(int key) async {
  final db = await openDb();
  final tx = db.transaction(storeName, 'readwrite');
  final store = tx.objectStore(storeName);
  await store.delete(key);
  await tx.completed;
}