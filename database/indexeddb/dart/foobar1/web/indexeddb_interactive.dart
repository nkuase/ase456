
import 'dart:async';
import 'package:web/web.dart' as web;

const String dbName = "StudentDatabase";
const String storeName = "dataStore";

Future<web.IDBDatabase> openDb() async {
  final openRequest = web.window.indexedDB!.open1(
    dbName,
    web.IDBOpenDBRequestOptions(version: 1),
  );

  final completer = Completer<web.IDBDatabase>();

  openRequest.onSuccess.listen((_) {
    completer.complete(openRequest.result!);
  });

  openRequest.onError.listen((_) {
    completer.completeError(openRequest.error!);
  });

  openRequest.onUpgradeNeeded.listen((event) {
    final db = openRequest.result!;
    if (!db.objectStoreNames.contains(storeName)) {
      db.createObjectStore(storeName, web.IDBObjectStoreParameters(
        keyPath: 'id',
        autoIncrement: true,
      ));
    }
  });

  return completer.future;
}

Future<int> create(Map<String, dynamic> data) async {
  final db = await openDb();
  final tx = db.transaction(storeName, web.IDBTransactionMode.readwrite);
  final store = tx.objectStore(storeName);
  final request = store.add(data);
  final completer = Completer<int>();

  request.onSuccess.listen((_) => completer.complete(request.result as int));
  request.onError.listen((_) => completer.completeError(request.error!));

  await tx.completed;
  return completer.future;
}

Future<List<Object?>> readAll() async {
  final db = await openDb();
  final tx = db.transaction(storeName, web.IDBTransactionMode.readonly);
  final store = tx.objectStore(storeName);
  final request = store.getAll();
  final completer = Completer<List<Object?>>();

  request.onSuccess.listen((_) => completer.complete(request.result!));
  request.onError.listen((_) => completer.completeError(request.error!));

  await tx.completed;
  return completer.future;
}

void main() {
  final btn = web.document.getElementById('create') as web.HTMLButtonElement;
  final out = web.document.getElementById('output') as web.HTMLDivElement;

  btn.addEventListener('click', (event) async {
    final record = {
      'foo': 'bar',
      'bar': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      final id = await create(record);
      out.textContent = 'Created ID: \$id';
    } catch (e) {
      out.textContent = 'Error: \$e';
    }
  });

  final readBtn = web.document.getElementById('readAll') as web.HTMLButtonElement;

  readBtn.addEventListener('click', (event) async {
    try {
      final records = await readAll();
      out.textContent = 'Records:\n' + records.map((e) => e.toString()).join('\n');
    } catch (e) {
      out.textContent = 'Error reading: \$e';
    }
  });
}
