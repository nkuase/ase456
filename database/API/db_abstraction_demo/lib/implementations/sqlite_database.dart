import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:db_abstraction_demo/interfaces/database_interface.dart';
import 'package:db_abstraction_demo/models/student.dart';
import 'package:uuid/uuid.dart';

/// SQLite implementation of the database interface
///
/// SQLite is a local, file-based SQL database that's perfect for mobile apps
/// Key learning points for students:
/// 1. How to implement an interface/abstract class
/// 2. SQL database operations (CREATE, INSERT, SELECT, UPDATE, DELETE)
/// 3. Database schema design and migrations
/// 4. Error handling in database operations
class SQLiteDatabase implements DatabaseInterface {
  static const String _tableName = 'students';
  static const int _databaseVersion = 1;

  // Use a unique database name for each instance in tests
  final String _databaseName;
  Database? _database;
  bool _isInitialized = false;

  SQLiteDatabase({String? databaseName})
      : _databaseName = databaseName ?? 'students_${const Uuid().v4()}.db';

  @override
  String get databaseName => 'SQLite';

  @override
  bool get isConnected => _database != null && _database!.isOpen;

  @override
  Future<bool> initialize() async {
    try {
      // Get the database path
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, _databaseName);

      // Open the database and create table if needed
      _database = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _createTable,
        onUpgrade: _upgradeTable,
      );

      _isInitialized = true;
      print('SQLite database initialized successfully at: $path');
      return true;
    } catch (e) {
      print('Failed to initialize SQLite database: $e');
      return false;
    }
  }

  /// Create the students table
  /// This method defines our database schema
  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        age INTEGER NOT NULL,
        major TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    print('Students table created successfully');
  }

  /// Handle database version upgrades
  /// This is where you would add migration logic for schema changes
  Future<void> _upgradeTable(
      Database db, int oldVersion, int newVersion) async {
    // For now, we just recreate the table
    // In production, you'd write proper migration scripts
    print('Upgrading database from version $oldVersion to $newVersion');
    await db.execute('DROP TABLE IF EXISTS $_tableName');
    await _createTable(db, newVersion);
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

  @override
  Future<Student> create(Student student) async {
    _ensureInitialized();

    try {
      await _database!.insert(
        _tableName,
        student.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

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
      final List<Map<String, dynamic>> maps = await _database!.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Student.fromMap(maps.first);
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
      final count = await _database!.update(
        _tableName,
        student.toMap(),
        where: 'id = ?',
        whereArgs: [student.id],
      );

      if (count == 0) {
        throw DBAbstractionException(
          'Student with ID ${student.id} not found',
          operation: 'update',
        );
      }

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
      final count = await _database!.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      final success = count > 0;
      if (success) {
        print('Student deleted: $id');
      } else {
        print('Student not found for deletion: $id');
      }
      return success;
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
      List<Map<String, dynamic>> maps;

      if (majorFilter != null) {
        maps = await _database!.query(
          _tableName,
          where: 'major = ?',
          whereArgs: [majorFilter],
          orderBy: 'name ASC',
        );
      } else {
        maps = await _database!.query(
          _tableName,
          orderBy: 'name ASC',
        );
      }

      return maps.map((map) => Student.fromMap(map)).toList();
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
      final List<Map<String, dynamic>> maps = await _database!.query(
        _tableName,
        where: 'name LIKE ?',
        whereArgs: ['%$namePattern%'],
        orderBy: 'name ASC',
      );

      return maps.map((map) => Student.fromMap(map)).toList();
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
      final result =
          await _database!.rawQuery('SELECT COUNT(*) FROM $_tableName');
      return Sqflite.firstIntValue(result) ?? 0;
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
      await _database!.delete(_tableName);
      print('All students cleared from SQLite database');
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
      await _database!.close();
      _database = null;
      _isInitialized = false;
      print('SQLite database connection closed');
    }
  }
}
