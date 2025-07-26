// JavaScript interop for IndexedDB
// This file provides Dart bindings to the browser's IndexedDB API

@JS()
library indexeddb_js;

import 'package:js/js.dart';
import 'dart:js_util' as js_util;
import 'dart:async';

/// External JavaScript IndexedDB factory
@JS('window.indexedDB')
external IDBFactory get indexedDB;

/// IDBFactory interface
@JS()
abstract class IDBFactory {
  external IDBOpenDBRequest open(String name, [int version]);
  external IDBOpenDBRequest deleteDatabase(String name);
}

/// IDBOpenDBRequest interface
@JS()
abstract class IDBOpenDBRequest {
  external set onsuccess(Function callback);
  external set onerror(Function callback);
  external set onupgradeneeded(Function callback);
  external IDBDatabase get result;
  external dynamic get error;
}

/// IDBDatabase interface
@JS()
abstract class IDBDatabase {
  external String get name;
  external int get version;
  external List<String> get objectStoreNames;
  external IDBTransaction transaction(dynamic storeNames, [String mode]);
  external IDBObjectStore createObjectStore(String name, [dynamic options]);
  external void close();
}

/// IDBTransaction interface
@JS()
abstract class IDBTransaction {
  external IDBObjectStore objectStore(String name);
  external set oncomplete(Function callback);
  external set onerror(Function callback);
  external dynamic get error;
}

/// IDBObjectStore interface
@JS()
abstract class IDBObjectStore {
  external String get name;
  external dynamic get keyPath;
  external IDBRequest add(dynamic value, [dynamic key]);
  external IDBRequest put(dynamic value, [dynamic key]);
  external IDBRequest get(dynamic key);
  external IDBRequest getAll();
  external IDBRequest delete(dynamic key);
  external IDBRequest clear();
  external IDBRequest count();
  external IDBIndex createIndex(String name, dynamic keyPath, [dynamic options]);
}

/// IDBIndex interface
@JS()
abstract class IDBIndex {
  external String get name;
  external IDBRequest getAll([dynamic query]);
}

/// IDBRequest interface
@JS()
abstract class IDBRequest {
  external set onsuccess(Function callback);
  external set onerror(Function callback);
  external dynamic get result;
  external dynamic get error;
}

/// IDBCursorWithValue interface
@JS()
abstract class IDBCursorWithValue {
  external dynamic get key;
  external dynamic get value;
  external void advance(int count);
  external void continue_([dynamic key]);
}

/// Helper class to work with Promises and callbacks
class IndexedDBHelpers {
  /// Convert JavaScript object to Dart Map
  static Map<String, dynamic> jsObjectToMap(dynamic jsObject) {
    final keys = js_util.objectKeys(jsObject);
    final map = <String, dynamic>{};
    
    for (final key in keys) {
      map[key as String] = js_util.getProperty(jsObject, key);
    }
    
    return map;
  }

  /// Convert Dart Map to JavaScript object
  static dynamic mapToJsObject(Map<String, dynamic> map) {
    final jsObject = js_util.newObject();
    
    map.forEach((key, value) {
      js_util.setProperty(jsObject, key, value);
    });
    
    return jsObject;
  }

  /// Wrap IDBRequest in a Future
  static Future<T> requestToFuture<T>(IDBRequest request) {
    final completer = Completer<T>();
    
    request.onsuccess = js_util.allowInterop((_) {
      completer.complete(request.result as T);
    });
    
    request.onerror = js_util.allowInterop((_) {
      completer.completeError(request.error ?? 'Unknown IndexedDB error');
    });
    
    return completer.future;
  }

  /// Wrap IDBOpenDBRequest in a Future
  static Future<IDBDatabase> openDatabase(String name, int version, 
      {Function(IDBDatabase, int, int)? onUpgrade}) {
    final completer = Completer<IDBDatabase>();
    final request = indexedDB.open(name, version);
    
    request.onsuccess = js_util.allowInterop((_) {
      completer.complete(request.result);
    });
    
    request.onerror = js_util.allowInterop((_) {
      completer.completeError(request.error ?? 'Failed to open database');
    });
    
    if (onUpgrade != null) {
      request.onupgradeneeded = js_util.allowInterop((event) {
        final db = request.result;
        final oldVersion = js_util.getProperty(event, 'oldVersion') as int;
        final newVersion = js_util.getProperty(event, 'newVersion') as int;
        onUpgrade(db, oldVersion, newVersion);
      });
    }
    
    return completer.future;
  }

  /// Wrap transaction completion in a Future
  static Future<void> transactionComplete(IDBTransaction transaction) {
    final completer = Completer<void>();
    
    transaction.oncomplete = js_util.allowInterop((_) {
      completer.complete();
    });
    
    transaction.onerror = js_util.allowInterop((_) {
      completer.completeError(transaction.error ?? 'Transaction failed');
    });
    
    return completer.future;
  }
}
