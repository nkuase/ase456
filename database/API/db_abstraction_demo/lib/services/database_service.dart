import 'package:db_abstraction_demo/interfaces/database_interface.dart';
import 'package:db_abstraction_demo/implementations/sqlite_database.dart';
import 'package:db_abstraction_demo/implementations/indexeddb_database.dart';
import 'package:db_abstraction_demo/implementations/pocketbase_database.dart';
import 'package:db_abstraction_demo/models/student.dart';

/// Database types available in the application
enum DatabaseType {
  sqlite,
  indexeddb,
  pocketbase,
}

/// Database service that manages different database implementations
///
/// This class demonstrates the Strategy Pattern in action
/// Key learning points for students:
/// 1. Dependency injection and inversion of control
/// 2. Strategy pattern implementation
/// 3. How to switch between different implementations at runtime
/// 4. Service layer pattern in application architecture
class DatabaseService {
  DatabaseInterface? _currentDatabase;
  DatabaseType? _currentType;

  /// Get the currently active database
  DatabaseInterface? get currentDatabase => _currentDatabase;

  /// Get the current database type
  DatabaseType? get currentType => _currentType;

  /// Check if any database is currently connected
  bool get isConnected => _currentDatabase?.isConnected ?? false;

  /// Switch to a different database implementation
  /// This method demonstrates how easy it is to switch implementations
  /// when using interfaces/abstractions
  Future<bool> switchDatabase(DatabaseType type) async {
    try {
      // Close current database if exists
      if (_currentDatabase != null) {
        await _currentDatabase!.close();
      }

      // Create new database instance based on type
      switch (type) {
        case DatabaseType.sqlite:
          _currentDatabase = SQLiteDatabase();
          break;
        case DatabaseType.indexeddb:
          _currentDatabase = IndexedDBDatabase();
          break;
        case DatabaseType.pocketbase:
          _currentDatabase = PocketBaseDatabase();
          break;
      }

      // Initialize the new database
      final success = await _currentDatabase!.initialize();

      if (success) {
        _currentType = type;
        print('Successfully switched to ${_currentDatabase!.databaseName}');
        return true;
      } else {
        print('Failed to initialize ${_getDatabaseName(type)}');
        _currentDatabase = null;
        _currentType = null;
        return false;
      }
    } catch (e) {
      print('Error switching database: $e');
      _currentDatabase = null;
      _currentType = null;
      return false;
    }
  }

  /// Get database name for a given type
  String _getDatabaseName(DatabaseType type) {
    switch (type) {
      case DatabaseType.sqlite:
        return 'SQLite';
      case DatabaseType.indexeddb:
        return 'IndexedDB';
      case DatabaseType.pocketbase:
        return 'PocketBase';
    }
  }

  /// Get all available database types with their availability status
  /// This helps the UI show which databases are actually usable
  Future<Map<DatabaseType, bool>> getAvailableDatabases() async {
    final availability = <DatabaseType, bool>{};

    for (final type in DatabaseType.values) {
      try {
        DatabaseInterface testDb;
        switch (type) {
          case DatabaseType.sqlite:
            testDb = SQLiteDatabase();
            break;
          case DatabaseType.indexeddb:
            testDb = IndexedDBDatabase();
            break;
          case DatabaseType.pocketbase:
            testDb = PocketBaseDatabase();
            break;
        }

        final canInit = await testDb.initialize();
        availability[type] = canInit;
        if (canInit) {
          await testDb.close();
        }
      } catch (e) {
        // If initialization throws an exception (e.g., platform not supported),
        // mark as unavailable
        print('Database ${type.name} not available: $e');
        availability[type] = false;
      }
    }

    return availability;
  }

  /// Wrapper methods that delegate to the current database
  /// These methods show how service layers can provide additional
  /// functionality while still using the underlying interface

  Future<Student> createStudent(Student student) async {
    _ensureConnected();
    return await _currentDatabase!.create(student);
  }

  Future<Student?> getStudent(String id) async {
    _ensureConnected();
    return await _currentDatabase!.read(id);
  }

  Future<Student> updateStudent(Student student) async {
    _ensureConnected();
    return await _currentDatabase!.update(student);
  }

  Future<bool> deleteStudent(String id) async {
    _ensureConnected();
    return await _currentDatabase!.delete(id);
  }

  Future<List<Student>> getAllStudents({String? majorFilter}) async {
    _ensureConnected();
    return await _currentDatabase!.getAll(majorFilter: majorFilter);
  }

  Future<List<Student>> searchStudents(String namePattern) async {
    _ensureConnected();
    return await _currentDatabase!.searchByName(namePattern);
  }

  Future<int> getStudentCount() async {
    _ensureConnected();
    return await _currentDatabase!.count();
  }

  Future<bool> clearAllStudents() async {
    _ensureConnected();
    return await _currentDatabase!.clear();
  }

  /// Additional service-level functionality
  /// These methods show how services can add business logic
  /// on top of the basic database operations

  /// Get students grouped by major
  Future<Map<String, List<Student>>> getStudentsByMajor() async {
    final allStudents = await getAllStudents();
    final groupedStudents = <String, List<Student>>{};

    for (final student in allStudents) {
      if (!groupedStudents.containsKey(student.major)) {
        groupedStudents[student.major] = [];
      }
      groupedStudents[student.major]!.add(student);
    }

    return groupedStudents;
  }

  /// Get statistics about students
  Future<Map<String, dynamic>> getStudentStatistics() async {
    final allStudents = await getAllStudents();

    if (allStudents.isEmpty) {
      return {
        'total': 0,
        'averageAge': 0.0,
        'majorCounts': <String, int>{},
        'oldestStudent': null,
        'youngestStudent': null,
      };
    }

    final majorCounts = <String, int>{};
    int totalAge = 0;
    Student? oldest = allStudents.first;
    Student? youngest = allStudents.first;

    for (final student in allStudents) {
      // Count majors
      majorCounts[student.major] = (majorCounts[student.major] ?? 0) + 1;

      // Sum ages
      totalAge += student.age;

      // Find oldest and youngest
      if (student.age > oldest!.age) oldest = student;
      if (student.age < youngest!.age) youngest = student;
    }

    return {
      'total': allStudents.length,
      'averageAge': totalAge / allStudents.length,
      'majorCounts': majorCounts,
      'oldestStudent': oldest,
      'youngestStudent': youngest,
    };
  }

  /// Validate student data before operations
  String? validateStudent(Student student) {
    if (student.name.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (student.email.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(student.email)) {
      return 'Invalid email format';
    }
    if (student.age < 16 || student.age > 100) {
      return 'Age must be between 16 and 100';
    }
    if (student.major.trim().isEmpty) {
      return 'Major cannot be empty';
    }
    return null; // No validation errors
  }

  /// Ensure database is connected before operations
  void _ensureConnected() {
    if (_currentDatabase == null) {
      throw DBAbstractionException(
        'No database connected. Switch to a database first.',
        operation: 'validation',
      );
    }
  }

  /// Close the current database connection
  Future<void> close() async {
    if (_currentDatabase != null) {
      await _currentDatabase!.close();
      _currentDatabase = null;
      _currentType = null;
    }
  }
}
