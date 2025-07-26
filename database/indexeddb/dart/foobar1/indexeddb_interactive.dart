
import 'dart:indexed_db';
import 'dart:html';

const String dbName = "myDB";
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

void showOutput(String msg) {
  final div = querySelector('#output')!;
  div.appendHtml('<p>${msg}</p>');
}

void main() {
  final createBtn = querySelector('#create')!;
  final readBtn = querySelector('#read')!;
  final updateBtn = querySelector('#update')!;
  final deleteBtn = querySelector('#delete')!;
  final inputKey = querySelector('#key') as InputElement;
  final inputFoo = querySelector('#foo') as InputElement;
  final inputBar = querySelector('#bar') as InputElement;

  createBtn.onClick.listen((_) async {
    final data = {'foo': inputFoo.value ?? '', 'bar': int.tryParse(inputBar.value ?? '') ?? 0};
    final key = await create(data);
    inputKey.value = key.toString();
    showOutput('Created with key $key: $data');
  });

  readBtn.onClick.listen((_) async {
    final key = int.tryParse(inputKey.value ?? '');
    if (key == null) return showOutput('Invalid key');
    final result = await read(key);
    showOutput('Read from key $key: $result');
  });

  updateBtn.onClick.listen((_) async {
    final key = int.tryParse(inputKey.value ?? '');
    if (key == null) return showOutput('Invalid key');
    final data = {'foo': inputFoo.value ?? '', 'bar': int.tryParse(inputBar.value ?? '') ?? 0};
    await update(key, data);
    showOutput('Updated key $key with $data');
  });

  deleteBtn.onClick.listen((_) async {
    final key = int.tryParse(inputKey.value ?? '');
    if (key == null) return showOutput('Invalid key');
    await deleteRecord(key);
    showOutput('Deleted key $key');
  });
}
