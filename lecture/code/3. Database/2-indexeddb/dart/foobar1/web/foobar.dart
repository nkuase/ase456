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

void showOutput(String msg) {
  final outputDiv = document.querySelector('#output');
  if (outputDiv != null) {
    final p = HTMLParagraphElement();
    p.textContent = msg;
    outputDiv.appendChild(p);
  }
}

void main() {
  final createBtn = document.querySelector('#create') as HTMLButtonElement?;
  final readBtn = document.querySelector('#read') as HTMLButtonElement?;
  final updateBtn = document.querySelector('#update') as HTMLButtonElement?;
  final deleteBtn = document.querySelector('#delete') as HTMLButtonElement?;

  final inputKey = document.querySelector('#key') as HTMLInputElement?;
  final inputFoo = document.querySelector('#foo') as HTMLInputElement?;
  final inputBar = document.querySelector('#bar') as HTMLInputElement?;

  int? parseKey(String? value) => int.tryParse(value ?? '');

  // Event handlers with no parameters:
  void handleCreate() async {
    if (inputFoo == null || inputBar == null || inputKey == null) return;

    final data = {
      'foo': inputFoo.value,
      'bar': int.tryParse(inputBar.value) ?? 0,
    };
    final key = await create(data);
    inputKey.value = key.toString();
    showOutput('Created with key $key: $data');
  }

  void handleRead() async {
    if (inputKey == null) return;

    final key = parseKey(inputKey.value);
    if (key == null) {
      showOutput('Invalid key');
      return;
    }
    final result = await read(key);
    showOutput('Read from key $key: $result');
  }

  void handleUpdate() async {
    if (inputKey == null || inputFoo == null || inputBar == null) return;

    final key = parseKey(inputKey.value);
    if (key == null) {
      showOutput('Invalid key');
      return;
    }

    final data = {
      'foo': inputFoo.value,
      'bar': int.tryParse(inputBar.value) ?? 0,
    };
    await update(key, data);
    showOutput('Updated key $key with $data');
  }

  void handleDelete() async {
    if (inputKey == null) return;

    final key = parseKey(inputKey.value);
    if (key == null) {
      showOutput('Invalid key');
      return;
    }
    await deleteRecord(key);
    showOutput('Deleted key $key');
  }

  createBtn?.onclick = handleCreate.toJS;
  readBtn?.onclick = handleRead.toJS;
  updateBtn?.onclick = handleUpdate.toJS;
  deleteBtn?.onclick = handleDelete.toJS;
}
