import 'dart:async';
import 'dart:js_util' as js_util;
import 'package:js/js.dart';
import 'foobar.dart';
import 'indexeddb_js.dart';

/// CRUD Service for FooBar collection using IndexedDB
/// This class provides simple Create, Read, Update, Delete operations
class FooBarCrudService {
  static const String _dbName = 'foobar_database';
  static const String _storeName = 'foobar';
  static const int _dbVersion = 1;
  
  IDBDatabase? _database;

  /// Initialize the database connection
  Future<void> init() async {
    _database = await IndexedDBHelpers.openDatabase(
      _dbName,
      _dbVersion,
      onUpgrade: _onUpgradeNeeded,
    );
  }

  /// Database upgrade callback - creates object stores
  void _onUpgradeNeeded(IDBDatabase db, int oldVersion, int newVersion) {
    // Create object store if it doesn't exist
    if (!db.objectStoreNames.contains(_storeName)) {
      // Create object store with auto-incrementing key
      final options = js_util.jsify({
        'keyPath': 'id',
        'autoIncrement': true,
      });
      
      final store = db.createObjectStore(_storeName, options);
      
      // Create index on 'foo' field for searching
      final indexOptions = js_util.jsify({'unique': false});
      store.createIndex('foo_index', 'foo', indexOptions);
    }
  }

  /// Ensure database is initialized
  Future<void> _ensureDatabase() async {
    if (_database == null) {
      await init();
    }
  }

  /// CREATE: Add a new FooBar record to the database
  /// Returns the created FooBar with its generated ID
  Future<FooBar> create(FooBar foobar) async {
    try {
      await _ensureDatabase();
      
      // Start a read-write transaction
      final transaction = _database!.transaction([_storeName], 'readwrite');
      final store = transaction.objectStore(_storeName);
      
      // Convert FooBar to JavaScript object (without ID for auto-generation)
      final jsData = IndexedDBHelpers.mapToJsObject(foobar.toJsonWithoutId());
      
      // Add to store and get the generated key
      final request = store.add(jsData);
      final key = await IndexedDBHelpers.requestToFuture<dynamic>(request);
      
      // Return the FooBar with its generated ID
      return FooBar(
        id: key.toString(),
        foo: foobar.foo,
        bar: foobar.bar,
      );
    } catch (e) {
      throw Exception('Failed to create FooBar: $e');
    }
  }

  /// READ: Get a single FooBar record by ID
  /// Returns the FooBar object if found, throws exception if not found
  Future<FooBar> getById(String id) async {
    try {
      await _ensureDatabase();
      
      // Parse ID to int if needed (IndexedDB auto-increment uses numbers)
      final key = int.tryParse(id) ?? id;
      
      // Start a read-only transaction
      final transaction = _database!.transaction([_storeName], 'readonly');
      final store = transaction.objectStore(_storeName);
      
      // Get the record
      final request = store.get(key);
      final result = await IndexedDBHelpers.requestToFuture<dynamic>(request);
      
      if (result == null) {
        throw Exception('FooBar with ID $id not found');
      }
      
      // Convert JavaScript object to Dart Map
      final map = IndexedDBHelpers.jsObjectToMap(result);
      return FooBar.fromJson(map);
    } catch (e) {
      throw Exception('Failed to get FooBar with ID $id: $e');
    }
  }

  /// READ: Get all FooBar records from the database
  /// Returns a list of all FooBar objects
  Future<List<FooBar>> getAll() async {
    try {
      await _ensureDatabase();
      
      // Start a read-only transaction
      final transaction = _database!.transaction([_storeName], 'readonly');
      final store = transaction.objectStore(_storeName);
      
      // Get all records
      final request = store.getAll();
      final results = await IndexedDBHelpers.requestToFuture<List<dynamic>>(request);
      
      // Convert each JavaScript object to FooBar
      return results.map((jsObject) {
        final map = IndexedDBHelpers.jsObjectToMap(jsObject);
        return FooBar.fromJson(map);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get all FooBar records: $e');
    }
  }

  /// READ: Get paginated FooBar records from the database
  /// Note: IndexedDB doesn't have built-in pagination, so we simulate it
  Future<List<FooBar>> getRecord([int page = 1, int perPage = 5]) async {
    try {
      // Get all records first
      final allRecords = await getAll();
      
      // Calculate pagination
      final startIndex = (page - 1) * perPage;
      final endIndex = startIndex + perPage;
      
      // Return paginated subset
      if (startIndex >= allRecords.length) {
        return [];
      }
      
      return allRecords.sublist(
        startIndex,
        endIndex > allRecords.length ? allRecords.length : endIndex,
      );
    } catch (e) {
      throw Exception('Failed to get paginated FooBar records: $e');
    }
  }

  /// READ: Search FooBar records with filtering
  /// Uses the 'foo_index' to search for records where foo contains the search term
  Future<List<FooBar>> searchByFoo(String searchTerm) async {
    try {
      await _ensureDatabase();
      
      // For simple contains search, we need to get all and filter
      // IndexedDB doesn't support LIKE queries natively
      final allRecords = await getAll();
      
      // Filter records where foo contains the search term
      return allRecords.where((record) => 
        record.foo.toLowerCase().contains(searchTerm.toLowerCase())
      ).toList();
    } catch (e) {
      throw Exception('Failed to search FooBar records: $e');
    }
  }

  /// UPDATE: Modify an existing FooBar record
  /// Requires the record ID and the updated FooBar data
  Future<FooBar> update(String id, FooBar updatedFoobar) async {
    try {
      await _ensureDatabase();
      
      // Ensure the record exists first
      await getById(id);
      
      // Start a read-write transaction
      final transaction = _database!.transaction([_storeName], 'readwrite');
      final store = transaction.objectStore(_storeName);
      
      // Prepare updated data with the existing ID
      final updatedData = FooBar(
        id: id,
        foo: updatedFoobar.foo,
        bar: updatedFoobar.bar,
      );
      
      // Convert to JavaScript object
      final jsData = IndexedDBHelpers.mapToJsObject(updatedData.toJson());
      
      // Use put to update the record
      final request = store.put(jsData);
      await IndexedDBHelpers.requestToFuture<dynamic>(request);
      
      return updatedData;
    } catch (e) {
      throw Exception('Failed to update FooBar with ID $id: $e');
    }
  }

  /// DELETE: Remove a FooBar record from the database
  /// Returns true if deletion was successful
  Future<bool> delete(String id) async {
    try {
      await _ensureDatabase();
      
      // Parse ID to int if needed
      final key = int.tryParse(id) ?? id;
      
      // Start a read-write transaction
      final transaction = _database!.transaction([_storeName], 'readwrite');
      final store = transaction.objectStore(_storeName);
      
      // Delete the record
      final request = store.delete(key);
      await IndexedDBHelpers.requestToFuture<dynamic>(request);
      
      return true;
    } catch (e) {
      throw Exception('Failed to delete FooBar with ID $id: $e');
    }
  }

  /// DELETE ALL: Remove all FooBar records from the database
  /// WARNING: This is a destructive operation that cannot be undone!
  Future<void> deleteAllRecords() async {
    try {
      await _ensureDatabase();
      
      // Count records first for logging
      final allRecords = await getAll();
      final totalCount = allRecords.length;
      
      // Start a read-write transaction
      final transaction = _database!.transaction([_storeName], 'readwrite');
      final store = transaction.objectStore(_storeName);
      
      // Clear all records
      final request = store.clear();
      await IndexedDBHelpers.requestToFuture<dynamic>(request);
      
      print('Total records deleted: $totalCount');
    } catch (e) {
      throw Exception('Failed to delete all FooBar records: $e');
    }
  }

  /// Close the database connection
  void close() {
    _database?.close();
    _database = null;
  }
}
