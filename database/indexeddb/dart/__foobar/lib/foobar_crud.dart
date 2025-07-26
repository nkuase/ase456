import 'dart:async';
import 'dart:indexed_db';
import 'dart:html' as html;
import 'dart:convert';
import 'dart:js' as js;
import 'foobar.dart';

/// Convert JavaScript object to Dart Map using circular-reference-safe helpers
Map<String, dynamic> _jsObjectToDartMap(dynamic jsObject) {
  if (jsObject == null) return {};
  
  print('🔍 Converting JS object: ${jsObject.runtimeType}');
  
  try {
    // Method 1: Use the JavaScript helper for safe property extraction
    // First, let's debug what we're dealing with
    js.context['indexedDBHelpers'].callMethod('debugObject', [jsObject]);
    
    final extracted = js.context['indexedDBHelpers'].callMethod('extractProperties', [jsObject]);
    if (extracted != null) {
      final map = {
        'id': extracted['id']?.toString(),
        'foo': extracted['foo']?.toString() ?? '',
        'bar': extracted['bar'] is num ? (extracted['bar'] as num).toInt() : 0,
      };
      print('✅ JavaScript helper property extraction successful: $map');
      return map;
    }
  } catch (e) {
    print('❌ JavaScript helper property extraction failed: $e');
  }
  
  try {
    // Method 2: Use the clean object helper
    final cleaned = js.context['indexedDBHelpers'].callMethod('cleanObject', [jsObject]);
    if (cleaned != null) {
      final map = {
        'id': cleaned['id']?.toString(),
        'foo': cleaned['foo']?.toString() ?? '',
        'bar': cleaned['bar'] is num ? (cleaned['bar'] as num).toInt() : 0,
      };
      print('✅ JavaScript helper clean object successful: $map');
      return map;
    }
  } catch (e) {
    print('❌ JavaScript helper clean object failed: $e');
  }
  
  try {
    // Method 3: Direct dart:js property access (avoid conversion)
    final jsObj = js.JsObject.fromBrowserObject(jsObject);
    final map = <String, dynamic>{
      'id': jsObj['id']?.toString(),
      'foo': jsObj['foo']?.toString() ?? '',
      'bar': jsObj['bar'] is num ? (jsObj['bar'] as num).toInt() : 0,
    };
    
    print('✅ dart:js direct access successful: $map');
    return map;
  } catch (e) {
    print('❌ dart:js direct access failed: $e');
  }
  
  // Fallback
  print('❌ All conversion methods failed');
  return {
    'id': 'error_${DateTime.now().millisecondsSinceEpoch}',
    'foo': 'Conversion Error',
    'bar': -1,
  };
}

/// CRUD Service for FooBar collection using IndexedDB
/// This class provides simple Create, Read, Update, Delete operations
/// IndexedDB is a client-side database that runs in web browsers
class FooBarCrudService {
  static const String _databaseName = 'FooBarDB';
  static const String _storeName = 'foobar';
  static const int _version = 1;
  
  Database? _db;

  /// Constructor: Initialize IndexedDB connection
  FooBarCrudService();

  /// Initialize the IndexedDB database
  /// This must be called before using any CRUD operations
  Future<void> initialize() async {
    try {
      print('Initializing IndexedDB...');
      
      // Open or create the database
      _db = await html.window.indexedDB!.open(
        _databaseName,
        version: _version,
        onUpgradeNeeded: (VersionChangeEvent event) {
          final Database db = event.target.result as Database;
          
          // Create object store if it doesn't exist
          if (!db.objectStoreNames!.contains(_storeName)) {
            print('Creating object store: $_storeName');
            final store = db.createObjectStore(
              _storeName,
              keyPath: 'id',  // Use 'id' field as the primary key
              autoIncrement: false,  // We'll generate our own IDs
            );
            
            // Create indexes for searching
            store.createIndex('foo_index', 'foo', unique: false);
            store.createIndex('bar_index', 'bar', unique: false);
            
            print('Object store created successfully');
          }
        },
      );
      
      print('IndexedDB initialized successfully');
    } catch (e) {
      throw Exception('Failed to initialize IndexedDB: $e');
    }
  }

  /// Generate a unique ID for new records
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           '_' + 
           (DateTime.now().microsecond % 1000).toString();
  }

  /// CREATE: Add a new FooBar record to the database
  /// Returns the created FooBar with its generated ID
  Future<FooBar> create(FooBar foobar) async {
    try {
      if (_db == null) {
        throw Exception('Database not initialized. Call initialize() first.');
      }

      // Generate ID if not provided
      final newFoobar = FooBar(
        id: foobar.id ?? _generateId(),
        foo: foobar.foo,
        bar: foobar.bar,
      );

      print('📝 Creating FooBar: ${newFoobar.toString()}');
      final jsonData = newFoobar.toJson();
      print('📄 JSON to store: $jsonData');

      // Create transaction
      final transaction = _db!.transaction(_storeName, 'readwrite');
      final store = transaction.objectStore(_storeName);

      // Add the record
      await store.put(jsonData);
      await transaction.completed;

      print('✅ Created FooBar with ID: ${newFoobar.id}');
      return newFoobar;
    } catch (e) {
      print('❌ Failed to create FooBar: $e');
      throw Exception('Failed to create FooBar: $e');
    }
  }

  /// READ: Get a single FooBar record by ID
  /// Returns the FooBar object if found, throws exception if not found
  Future<FooBar> getById(String id) async {
    try {
      if (_db == null) {
        throw Exception('Database not initialized. Call initialize() first.');
      }

      // Create transaction
      final transaction = _db!.transaction(_storeName, 'readonly');
      final store = transaction.objectStore(_storeName);

      // Get the record
      final result = await store.getObject(id);
      
      if (result == null) {
        throw Exception('FooBar with ID $id not found');
      }

      // Convert JavaScript object to Dart Map
      final dartMap = _jsObjectToDartMap(result);
      return FooBar.fromJson(dartMap);
    } catch (e) {
      throw Exception('Failed to get FooBar with ID $id: $e');
    }
  }

  /// READ: Get all FooBar records from the database
  /// Returns a list of all FooBar objects
  Future<List<FooBar>> getAll() async {
    try {
      if (_db == null) {
        throw Exception('Database not initialized. Call initialize() first.');
      }

      print('Creating transaction for getAll...');
      // Create transaction
      final transaction = _db!.transaction(_storeName, 'readonly');
      final store = transaction.objectStore(_storeName);

      // Get all records using cursor
      final List<FooBar> results = [];
      
      print('Opening cursor to read records...');
      await for (final cursor in store.openCursor(autoAdvance: true)) {
        print('Processing cursor value: ${cursor.value}');
        print('Cursor value type: ${cursor.value.runtimeType}');
        
        try {
          // Convert JavaScript object to Dart Map
          final dartMap = _jsObjectToDartMap(cursor.value);
          print('Converted to Dart map: $dartMap');
          
          final foobar = FooBar.fromJson(dartMap);
          print('Created FooBar: $foobar');
          
          results.add(foobar);
        } catch (e) {
          print('Error processing individual record: $e');
          // Skip this record but continue with others
          continue;
        }
      }

      print('Successfully retrieved ${results.length} FooBar records');
      return results;
    } catch (e) {
      print('Error in getAll: $e');
      throw Exception('Failed to get all FooBar records: $e');
    }
  }

  /// READ: Get paginated FooBar records from the database
  /// Returns a list of FooBar objects
  Future<List<FooBar>> getRecord([int page = 1, int perPage = 5]) async {
    try {
      final allRecords = await getAll();
      
      // Calculate pagination
      final startIndex = (page - 1) * perPage;
      final endIndex = startIndex + perPage;
      
      if (startIndex >= allRecords.length) {
        return [];
      }
      
      final endIdx = endIndex > allRecords.length ? allRecords.length : endIndex;
      return allRecords.sublist(startIndex, endIdx);
    } catch (e) {
      throw Exception('Failed to get paginated FooBar records: $e');
    }
  }

  /// READ: Search FooBar records with filtering
  /// Example usage: searchByFoo("hello") returns all records where foo contains "hello"
  Future<List<FooBar>> searchByFoo(String searchTerm) async {
    try {
      if (_db == null) {
        throw Exception('Database not initialized. Call initialize() first.');
      }

      final allRecords = await getAll();
      
      // Filter records that contain the search term in 'foo' field
      final filteredRecords = allRecords
          .where((foobar) => foobar.foo.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();

      print('Found ${filteredRecords.length} records matching "$searchTerm"');
      return filteredRecords;
    } catch (e) {
      throw Exception('Failed to search FooBar records: $e');
    }
  }

  /// UPDATE: Modify an existing FooBar record
  /// Requires the record ID and the updated FooBar data
  Future<FooBar> update(String id, FooBar updatedFoobar) async {
    try {
      if (_db == null) {
        throw Exception('Database not initialized. Call initialize() first.');
      }

      // Ensure the ID is preserved
      final foobarToUpdate = FooBar(
        id: id,
        foo: updatedFoobar.foo,
        bar: updatedFoobar.bar,
      );

      // Create transaction
      final transaction = _db!.transaction(_storeName, 'readwrite');
      final store = transaction.objectStore(_storeName);

      // Check if record exists (no need to convert here since we just check null)
      final existing = await store.getObject(id);
      if (existing == null) {
        throw Exception('FooBar with ID $id not found');
      }

      // Update the record
      await store.put(foobarToUpdate.toJson());
      await transaction.completed;

      print('Updated FooBar with ID: $id');
      return foobarToUpdate;
    } catch (e) {
      throw Exception('Failed to update FooBar with ID $id: $e');
    }
  }

  /// DELETE: Remove a FooBar record from the database
  /// Returns true if deletion was successful
  Future<bool> delete(String id) async {
    try {
      if (_db == null) {
        throw Exception('Database not initialized. Call initialize() first.');
      }

      // Create transaction
      final transaction = _db!.transaction(_storeName, 'readwrite');
      final store = transaction.objectStore(_storeName);

      // Check if record exists (no need to convert here since we just check null)
      final existing = await store.getObject(id);
      if (existing == null) {
        throw Exception('FooBar with ID $id not found');
      }

      // Delete the record
      await store.delete(id);
      await transaction.completed;

      print('Deleted FooBar with ID: $id');
      return true;
    } catch (e) {
      throw Exception('Failed to delete FooBar with ID $id: $e');
    }
  }

  /// DELETE ALL: Remove all FooBar records from the database
  /// WARNING: This is a destructive operation that cannot be undone!
  Future<void> deleteAllRecords() async {
    try {
      if (_db == null) {
        throw Exception('Database not initialized. Call initialize() first.');
      }

      // Create transaction
      final transaction = _db!.transaction(_storeName, 'readwrite');
      final store = transaction.objectStore(_storeName);

      // Clear all records
      await store.clear();
      await transaction.completed;

      print('All FooBar records deleted successfully');
    } catch (e) {
      throw Exception('Failed to delete all FooBar records: $e');
    }
  }

  /// Get the count of records in the database
  Future<int> count() async {
    try {
      if (_db == null) {
        throw Exception('Database not initialized. Call initialize() first.');
      }

      final transaction = _db!.transaction(_storeName, 'readonly');
      final store = transaction.objectStore(_storeName);

      final count = await store.count();
      return count;
    } catch (e) {
      throw Exception('Failed to count FooBar records: $e');
    }
  }

  /// Close the database connection
  void close() {
    _db?.close();
    _db = null;
    print('Database connection closed');
  }
}
