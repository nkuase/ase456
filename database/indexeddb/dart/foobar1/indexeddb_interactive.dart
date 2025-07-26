
import 'dart:async';
import 'dart:js_util';
import 'dart:js_interop';
import 'package:web/web.dart';

const String dbName = 'StudentDatabase';
const String storeName = 'dataStore';

Future<IDBDatabase> openDb() {
  final completer = Completer<IDBDatabase>();
  final request = window.indexedDB!.open(dbName, 1);

  request.onsuccess = allowInterop((_) {
    final db = request.result;
    if (db != null) {
      completer.complete(db);
    } else {
      completer.completeError('IndexedDB returned null result');
    }
  });

  request.onerror = allowInterop((_) {
    completer.completeError(request.error ?? 'Unknown error');
  });

  request.onupgradeneeded = allowInterop((_) {
    final db = request.result;
    if (db != null && !db.objectStoreNames.contains(storeName)) {
      db.createObjectStore(
        storeName,
        IDBObjectStoreParameters(keyPath: 'id', autoIncrement: true),
      );
    }
  });

  return completer.future;
}

Future<int> create(Map<String, dynamic> data) async {
  final db = await openDb();
  final tx = db.transaction(storeName, IDBTransactionMode.readwrite);
  final store = tx.objectStore(storeName);
  final request = store.add(jsify(data));

  final completer = Completer<int>();
  request.onsuccess = allowInterop((_) {
    final result = request.result;
    if (result != null) {
      completer.complete(result as int);
    } else {
      completer.completeError('Create returned null');
    }
  });
  request.onerror = allowInterop((_) {
    completer.completeError(request.error ?? 'Create error');
  });

  return completer.future;
}

Future<List<Object?>> readAll() async {
  final db = await openDb();
  final tx = db.transaction(storeName, IDBTransactionMode.readonly);
  final store = tx.objectStore(storeName);
  final request = store.getAll();

  final completer = Completer<List<Object?>>();
  request.onsuccess = allowInterop((_) {
    final result = request.result;
    if (result != null) {
      completer.complete(result);
    } else {
      completer.completeError('ReadAll returned null');
    }
  });
  request.onerror = allowInterop((_) {
    completer.completeError(request.error ?? 'ReadAll error');
  });

  return completer.future;
}

void main() {
  final createBtn = document.getElementById('create') as HTMLButtonElement;
  final readBtn = document.getElementById('readAll') as HTMLButtonElement;
  final output = document.getElementById('output') as HTMLPreElement;

  createBtn.addEventListener('click', allowInterop((_) async {
    final record = {
      'foo': 'bar',
      'bar': DateTime.now().millisecondsSinceEpoch,
    };
    try {
      final id = await create(record);
      output.textContent = 'Created ID: \$id';
    } catch (e) {
      output.textContent = 'Create error: \$e';
    }
  }));

  readBtn.addEventListener('click', allowInterop((_) async {
    try {
      final records = await readAll();
      output.textContent = 'Records:\n' + records.map((e) => e.toString()).join('\n');
    } catch (e) {
      output.textContent = 'Read error: \$e';
    }
  }));
}
