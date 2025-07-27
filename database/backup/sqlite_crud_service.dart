import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import '../common/database_service.dart';
import '../common/student.dart';

/// SQLite implementation of DatabaseService
/// Perfect for desktop and mobile applications
class SQLiteStudentService implements DatabaseService {
  static Database? _database;
  static const String _databaseName = 'students.db';
  static const String _tableName = 'students';

  /// Get database instance (singleton pattern)
  static Database get database {
    if (_database != null) return _database!;
    throw StateError('Database not initialized. Call initialize() first.');
  }

  @override
  Future<void> initialize() async {
    try {
      // Create database file path
      String dbPath = join(Directory.current.path, _databaseName);
      
      // Open database (creates file if doesn't exist)
      _database = sqlite3.open(dbPath);
      
      // Create table if it doesn't exist
      _createTable();
      
      print('✅ SQLite initialized at: $dbPath');
    } catch (e) {
      print('❌ SQLite initialization failed: $e');
      rethrow;
    }
  }

  static void _createTable() {
    database.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        major TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    
    // Create indexes for better performance
    database.execute('CREATE INDEX IF NOT EXISTS idx_name ON $_tableName(name)');
    database.execute('CREATE INDEX IF NOT EXISTS idx_major ON $_tableName(major)');
    database.execute('CREATE INDEX IF NOT EXISTS idx_age ON $_tableName(age)');
  }

  @override
  Future<String> createStudent(Student student) async {
    final db = database;
    final stmt = db.prepare('''
      INSERT INTO $_tableName (id, name, age, major, createdAt)
      VALUES (?, ?, ?, ?, ?)
    ''');

    try {
      stmt.execute([
        student.id,
        student.name,
        student.age,
        student.major,
        student.createdAt.toIso8601String(),
      ]);

      print('✅ CREATE: Student inserted with ID: ${student.id}');
      return student.id;
    } catch (e) {
      print('❌ CREATE ERROR: Failed to insert student: $e');
      rethrow;
    } finally {
      stmt.dispose();
    }
  }

  @override
  Future<Student?> readStudent(String id) async {
    final db = database;
    final stmt = db.prepare('SELECT * FROM $_tableName WHERE id = ?');

    try {
      final ResultSet resultSet = stmt.select([id]);

      if (resultSet.isNotEmpty) {
        final row = resultSet.first;
        final student = Student.fromMap({
          'id': row['id'] as String,
          'name': row['name'] as String,
          'age': row['age'] as int,
          'major': row['major'] as String,
          'createdAt': row['createdAt'] as String,
        });
        
        print('✅ READ: Found student with ID $id');
        return student;
      } else {
        print('⚠️ READ: No student found with ID $id');
        return null;
      }
    } catch (e) {
      print('❌ READ ERROR: Failed to get student: $e');
      return null;
    } finally {
      stmt.dispose();
    }
  }

  @override
  Future<List<Student>> readAllStudents() async {
    final db = database;
    
    try {
      final ResultSet resultSet = db.select(
        'SELECT * FROM $_tableName ORDER BY createdAt DESC'
      );

      List<Student> students = resultSet.map((row) {
        return Student.fromMap({
          'id': row['id'] as String,
          'name': row['name'] as String,
          'age': row['age'] as int,
          'major': row['major'] as String,
          'createdAt': row['createdAt'] as String,
        });
      }).toList();

      print('✅ READ ALL: Retrieved ${students.length} students');
      return students;
    } catch (e) {
      print('❌ READ ALL ERROR: Failed to get all students: $e');
      return [];
    }
  }

  @override
  Future<bool> updateStudent(String id, Map<String, dynamic> updates) async {
    final db = database;

    // Build dynamic update query
    List<String> updateFields = [];
    List<dynamic> values = [];

    updates.forEach((key, value) {
      if (key != 'id') { // Don't update ID
        updateFields.add('$key = ?');
        values.add(value);
      }
    });

    if (updateFields.isEmpty) {
      print('⚠️ UPDATE: No fields to update');
      return false;
    }

    values.add(id); // Add ID for WHERE clause

    final updateQuery = '''
      UPDATE $_tableName 
      SET ${updateFields.join(', ')} 
      WHERE id = ?
    ''';

    final stmt = db.prepare(updateQuery);

    try {
      stmt.execute(values);
      print('✅ UPDATE: Student with ID $id updated successfully');
      return true;
    } catch (e) {
      print('❌ UPDATE ERROR: Failed to update student: $e');
      return false;
    } finally {
      stmt.dispose();
    }
  }

  @override
  Future<bool> deleteStudent(String id) async {
    final db = database;
    final stmt = db.prepare('DELETE FROM $_tableName WHERE id = ?');

    try {
      stmt.execute([id]);
      print('✅ DELETE: Student with ID $id deleted successfully');
      return true;
    } catch (e) {
      print('❌ DELETE ERROR: Failed to delete student: $e');
      return false;
    } finally {
      stmt.dispose();
    }
  }

  @override
  Future<void> clearAllStudents() async {
    final db = database;

    try {
      db.execute('DELETE FROM $_tableName');
      print('✅ DELETE ALL: All students cleared from database');
    } catch (e) {
      print('❌ DELETE ALL ERROR: Failed to clear all students: $e');
    }
  }

  @override
  Future<List<Student>> getStudentsByMajor(String major) async {
    final db = database;
    final stmt = db.prepare('SELECT * FROM $_tableName WHERE major = ? ORDER BY name');

    try {
      final ResultSet resultSet = stmt.select([major]);

      List<Student> students = resultSet.map((row) {
        return Student.fromMap({
          'id': row['id'] as String,
          'name': row['name'] as String,
          'age': row['age'] as int,
          'major': row['major'] as String,
          'createdAt': row['createdAt'] as String,
        });
      }).toList();

      print('✅ QUERY: Found ${students.length} students in $major');
      return students;
    } catch (e) {
      print('❌ QUERY ERROR: Failed to get students by major: $e');
      return [];
    } finally {
      stmt.dispose();
    }
  }

  @override
  Future<List<Student>> searchStudentsByName(String name) async {
    final db = database;
    final stmt = db.prepare('SELECT * FROM $_tableName WHERE name LIKE ? ORDER BY name');

    try {
      final ResultSet resultSet = stmt.select(['%$name%']);

      List<Student> students = resultSet.map((row) {
        return Student.fromMap({
          'id': row['id'] as String,
          'name': row['name'] as String,
          'age': row['age'] as int,
          'major': row['major'] as String,
          'createdAt': row['createdAt'] as String,
        });
      }).toList();

      print('✅ SEARCH: Found ${students.length} students matching "$name"');
      return students;
    } catch (e) {
      print('❌ SEARCH ERROR: Failed to search students by name: $e');
      return [];
    } finally {
      stmt.dispose();
    }
  }

  @override
  Future<void> close() async {
    try {
      _database?.dispose();
      _database = null;
      print('✅ SQLite connection closed');
    } catch (e) {
      print('❌ CLOSE ERROR: Failed to close SQLite: $e');
    }
  }

  /// Additional SQLite-specific methods for advanced operations
  
  /// Perform database maintenance
  static void optimizeDatabase() {
    final db = database;
    
    try {
      // Update table statistics for better query planning
      db.execute('ANALYZE');
      
      // Reclaim unused space
      db.execute('VACUUM');
      
      // Check database integrity
      final result = db.select('PRAGMA integrity_check');
      if (result.first['integrity_check'] == 'ok') {
        print('✅ Database integrity check passed');
      }
      
      print('✅ Database optimization completed');
    } catch (e) {
      print('❌ Database optimization failed: $e');
    }
  }

  /// Perform batch insert for better performance
  static void performBatchInsert(List<Student> students) {
    final db = database;
    
    // Begin transaction
    db.execute('BEGIN TRANSACTION');
    
    try {
      final stmt = db.prepare('''
        INSERT INTO $_tableName (id, name, age, major, createdAt)
        VALUES (?, ?, ?, ?, ?)
      ''');
      
      // Insert all students in single transaction
      for (Student student in students) {
        stmt.execute([
          student.id,
          student.name,
          student.age,
          student.major,
          student.createdAt.toIso8601String(),
        ]);
      }
      
      // Commit transaction
      db.execute('COMMIT');
      print('✅ Batch insert completed successfully');
    } catch (e) {
      // Rollback on error
      db.execute('ROLLBACK');
      print('❌ Batch insert failed: $e');
      rethrow;
    }
  }
}
