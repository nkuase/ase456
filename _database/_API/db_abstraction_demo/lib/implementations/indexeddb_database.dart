import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:idb_shim/idb_browser.dart';
import '../interfaces/database_interface.dart';
import '../models/student.dart';

/// IndexedDB implementation of the database interface
///
/// IndexedDB is a NoSQL database built into web browsers
/// Key learning points for students:
/// 1. NoSQL vs SQL database concepts
/// 2. Browser-based storage solutions
/// 3. Asynchronous database operations
/// 4. Object stores vs tables
/// 5. Web-specific database constraints
class IndexedDBDatabase implements DatabaseInterface {
  static const String _databaseName = 'StudentsDB';
  static const String _storeName = 'students';
  static const int _databaseVersion = 1;

  Database? _database;
  late IdbFactory _idbFactory;
  bool _isInitialized = false;

  IndexedDBDatabase() {
    // Only available on web platforms
    if (!kIsWeb) {
      throw DBAbstractionException(
        'IndexedDB is only available on web platforms',
        operation: 'initialization',
      );
    }

    // Initialize the IndexedDB factory for browser environment
    _idbFactory = getIdbFactory()!;
  }

  @override
  String get databaseName => 'IndexedDB';

  @override
  bool get isConnected => _database != null;

  @override
  Future<bool> initialize() async {
    try {
      // Open the database, creating it if it doesn't exist
      _database = await _idbFactory.open(
        _databaseName,
        version: _databaseVersion,
        onUpgradeNeeded: _onUpgradeNeeded,
      );

      _isInitialized = true;
      print('IndexedDB database initialized successfully');
      return true;
    } catch (e) {
      print('Failed to initialize IndexedDB database: $e');
      return false;
    }
  }

  /// Handle database upgrade (creation of object stores)
  /// This is similar to table creation in SQL databases
  void _onUpgradeNeeded(VersionChangeEvent event) {
    final db = event.database;

    // Create the students object store if it doesn't exist
    if (!db.objectStoreNames.contains(_storeName)) {
      final store = db.createObjectStore(
        _storeName,
        keyPath: 'id', // Use 'id' field as the primary key
      );

      // Create indexes for efficient querying
      store.createIndex('name', 'name', unique: false);
      store.createIndex('email', 'email', unique: true);
      store.createIndex('major', 'major', unique: false);

      print('Students object store created with indexes');
    }
  }

  /// Ensure database is initialized before operations
  void _ensureInitialized() {
    if (!_isInitialized || _database == null) {
      throw DBAbstractionException(
        'Database not initialized. Call initialize() first.',
        operation: 'validation',
      );
    }
  }

  /// Get a transaction for database operations
  Transaction _getTransaction(String mode) {
    return _database!.transaction(_storeName, mode);
  }

  @override
  Future<Student> create(Student student) async {
    _ensureInitialized();

    try {
      final transaction = _getTransaction('readwrite');
      final store = transaction.objectStore(_storeName);

      // Add the student to the object store
      await store.add(student.toMap());
      await transaction.completed;

      print('Student created: ${student.name} (${student.id})');
      return student;
    } catch (e) {
      throw DBAbstractionException(
        'Failed to create student: ${student.name}',
        operation: 'create',
        originalError: e,
      );
    }
  }

  @override
  Future<Student?> read(String id) async {
    _ensureInitialized();

    try {
      final transaction = _getTransaction('readonly');
      final store = transaction.objectStore(_storeName);

      final result = await store.getObject(id);

      if (result != null) {
        return Student.fromMap(Map<String, dynamic>.from(result as Map));
      }
      return null;
    } catch (e) {
      throw DBAbstractionException(
        'Failed to read student with ID: $id',
        operation: 'read',
        originalError: e,
      );
    }
  }

  @override
  Future<Student> update(Student student) async {
    _ensureInitialized();

    try {
      final transaction = _getTransaction('readwrite');
      final store = transaction.objectStore(_storeName);

      // Check if student exists first
      final existing = await store.getObject(student.id);
      if (existing == null) {
        throw DBAbstractionException(
          'Student with ID ${student.id} not found',
          operation: 'update',
        );
      }

      // Update the student
      await store.put(student.toMap());
      await transaction.completed;

      print('Student updated: ${student.name} (${student.id})');
      return student;
    } catch (e) {
      if (e is DBAbstractionException) rethrow;
      throw DBAbstractionException(
        'Failed to update student: ${student.name}',
        operation: 'update',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> delete(String id) async {
    _ensureInitialized();

    try {
      final transaction = _getTransaction('readwrite');
      final store = transaction.objectStore(_storeName);

      // Check if student exists
      final existing = await store.getObject(id);
      if (existing == null) {
        print('Student not found for deletion: $id');
        return false;
      }

      // Delete the student
      await store.delete(id);
      await transaction.completed;

      print('Student deleted: $id');
      return true;
    } catch (e) {
      throw DBAbstractionException(
        'Failed to delete student with ID: $id',
        operation: 'delete',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Student>> getAll({String? majorFilter}) async {
    _ensureInitialized();

    try {
      final transaction = _getTransaction('readonly');
      final store = transaction.objectStore(_storeName);

      final List<Map<String, dynamic>> results = [];

      if (majorFilter != null) {
        // Use the major index for filtered queries
        final index = store.index('major');
        final cursor = index.openCursor(key: majorFilter);

        await for (final cursorWithValue in cursor) {
          results.add(Map<String, dynamic>.from(cursorWithValue.value as Map));
          cursorWithValue.next();
        }
      } else {
        // Get all records
        final cursor = store.openCursor();

        await for (final cursorWithValue in cursor) {
          results.add(Map<String, dynamic>.from(cursorWithValue.value as Map));
          cursorWithValue.next();
        }
      }

      // Sort by name (IndexedDB doesn't have built-in sorting)
      results
          .sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

      return results.map((map) => Student.fromMap(map)).toList();
    } catch (e) {
      throw DBAbstractionException(
        'Failed to get all students',
        operation: 'getAll',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Student>> searchByName(String namePattern) async {
    _ensureInitialized();

    try {
      final transaction = _getTransaction('readonly');
      final store = transaction.objectStore(_storeName);

      final results = <Map<String, dynamic>>[];
      final cursor = store.openCursor();

      await for (final cursorWithValue in cursor) {
        final data = Map<String, dynamic>.from(cursorWithValue.value as Map);
        final name = data['name'] as String;

        // Simple case-insensitive search
        if (name.toLowerCase().contains(namePattern.toLowerCase())) {
          results.add(data);
        }

        cursorWithValue.next();
      }

      // Sort by name
      results
          .sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

      return results.map((map) => Student.fromMap(map)).toList();
    } catch (e) {
      throw DBAbstractionException(
        'Failed to search students by name: $namePattern',
        operation: 'searchByName',
        originalError: e,
      );
    }
  }

  @override
  Future<int> count() async {
    _ensureInitialized();

    try {
      final transaction = _getTransaction('readonly');
      final store = transaction.objectStore(_storeName);

      return await store.count();
    } catch (e) {
      throw DBAbstractionException(
        'Failed to count students',
        operation: 'count',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> clear() async {
    _ensureInitialized();

    try {
      final transaction = _getTransaction('readwrite');
      final store = transaction.objectStore(_storeName);

      await store.clear();
      await transaction.completed;

      print('All students cleared from IndexedDB database');
      return true;
    } catch (e) {
      throw DBAbstractionException(
        'Failed to clear all students',
        operation: 'clear',
        originalError: e,
      );
    }
  }

  @override
  Future<void> close() async {
    if (_database != null) {
      _database!.close();
      _database = null;
      _isInitialized = false;
      print('IndexedDB database connection closed');
    }
  }
}
