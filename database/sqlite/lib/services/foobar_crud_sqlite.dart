import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import '../models/foobar.dart';

/// CRUD (Create, Read, Update, Delete) operations for FooBar entities using SQLite
/// This class demonstrates fundamental database operations for teaching purposes
class FooBarCrudSQLite {
  Database? _database;
  final String _databaseName = 'foobar.db';
  final String _tableName = 'foobars';
  final String _dataDirectory = 'data';

  /// Gets the database instance, creates it if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Ensure data directory exists
    final dataDir = Directory(_dataDirectory);
    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }

    String dbPath = join(_dataDirectory, _databaseName);
    _database = sqlite3.open(dbPath);
    _createTableIfNotExists();
    return _database!;
  }

  /// Creates the foobars table if it doesn't exist
  void _createTableIfNotExists() {
    final db = _database!;
    db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        foo TEXT NOT NULL,
        bar INTEGER NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  /// CREATE: Insert a new FooBar record
  /// Returns the ID of the created record
  Future<int> create(FooBar foobar) async {
    final db = await database;

    final stmt = db.prepare('''
      INSERT INTO $_tableName (foo, bar) 
      VALUES (?, ?)
    ''');

    stmt.execute([foobar.foo, foobar.bar]);
    stmt.dispose();

    return db.lastInsertRowId;
  }

  /// READ: Get all FooBar records
  /// Returns a list of all FooBar objects
  Future<List<FooBar>> readAll() async {
    final db = await database;

    final ResultSet resultSet =
        db.select('SELECT * FROM $_tableName ORDER BY id');

    return resultSet.map((row) => FooBar.fromRow(row)).toList();
  }

  /// READ: Get a FooBar by ID
  /// Returns null if not found
  Future<FooBar?> read(int id) async {
    final db = await database;

    final stmt = db.prepare('SELECT * FROM $_tableName WHERE id = ?');
    final result = stmt.select([id]);
    stmt.dispose();

    if (result.isEmpty) return null;

    return FooBar.fromRow(result.first);
  }

  /// READ: Find FooBar records by foo field (like a search)
  /// Returns a list of matching FooBar objects
  Future<List<FooBar>> findByFoo(String foo) async {
    final db = await database;

    final stmt =
        db.prepare('SELECT * FROM $_tableName WHERE foo LIKE ? ORDER BY id');
    final result = stmt.select(['%$foo%']);
    stmt.dispose();

    return result.map((row) => FooBar.fromRow(row)).toList();
  }

  /// UPDATE: Update an existing FooBar record
  /// Returns true if successful, false if record not found
  Future<bool> update(int id, FooBar foobar) async {
    final db = await database;

    final stmt = db.prepare('''
      UPDATE $_tableName 
      SET foo = ?, bar = ? 
      WHERE id = ?
    ''');

    stmt.execute([foobar.foo, foobar.bar, id]);
    stmt.dispose();

    return db.updatedRows > 0;
  }

  /// DELETE: Remove a FooBar record by ID
  /// Returns true if successful, false if record not found
  Future<bool> delete(int id) async {
    final db = await database;

    final stmt = db.prepare('DELETE FROM $_tableName WHERE id = ?');
    stmt.execute([id]);
    stmt.dispose();

    return db.updatedRows > 0;
  }

  /// DELETE: Remove all FooBar records (use with caution!)
  /// Returns the number of deleted records
  Future<int> deleteAll() async {
    final db = await database;

    db.execute('DELETE FROM $_tableName');
    return db.updatedRows;
  }

  /// Get count of all records
  /// Useful for statistics and pagination
  Future<int> count() async {
    final db = await database;

    final result = db.select('SELECT COUNT(*) as count FROM $_tableName');
    return result.first['count'] as int;
  }

  /// Close the database connection
  /// Important: Always call this when done to free resources
  Future<void> close() async {
    _database?.dispose();
    _database = null;
  }

  /// Check if a record exists by ID
  /// Returns true if exists, false otherwise
  Future<bool> exists(int id) async {
    final db = await database;

    final stmt = db.prepare('SELECT 1 FROM $_tableName WHERE id = ? LIMIT 1');
    final result = stmt.select([id]);
    stmt.dispose();

    return result.isNotEmpty;
  }
}
