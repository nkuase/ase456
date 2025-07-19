import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import '../core/interfaces/database_service.dart';
import '../core/models/student.dart';
import '../core/models/api_response.dart';
import '../core/utils/json_converter.dart';

/// SQLite implementation of the universal database service
class SQLiteService implements DatabaseService {
  Database? _database;
  static const String _tableName = 'students';
  final String? _customDbPath;

  SQLiteService({String? customDbPath}) : _customDbPath = customDbPath;

  @override
  String get databaseType => 'SQLite';

  Database get database {
    if (_database != null) return _database!;
    throw DatabaseException('Database not initialized. Call initialize() first.');
  }

  @override
  Future<void> initialize() async {
    try {
      // Create database file path
      String dbPath = _customDbPath ?? join(Directory.current.path, 'students.db');
      
      // Open database (creates file if it doesn't exist)
      _database = sqlite3.open(dbPath);
      
      // Create table if it doesn't exist
      await _createTable();
      
      print('✅ SQLite database initialized at: $dbPath');
    } catch (e) {
      throw DatabaseException('Failed to initialize SQLite database', details: e.toString());
    }
  }

  @override
  Future<void> close() async {
    try {
      if (_database != null) {
        _database!.dispose();
        _database = null;
        print('🔒 SQLite database connection closed');
      }
    } catch (e) {
      throw DatabaseException('Failed to close SQLite database', details: e.toString());
    }
  }

  @override
  Future<bool> isHealthy() async {
    try {
      if (_database == null) return false;
      
      // Try a simple query to check if database is responsive
      final result = database.select('SELECT 1');
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> _createTable() async {
    database.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        major TEXT NOT NULL,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  @override
  Future<String> createStudent(Student student) async {
    try {
      // Validate student data
      if (!student.isValid()) {
        throw ValidationException(student.getValidationErrors());
      }

      final stmt = database.prepare('''
        INSERT INTO $_tableName (name, age, major, createdAt, updatedAt)
        VALUES (?, ?, ?, ?, ?)
      ''');
      
      final now = DateTime.now().toIso8601String();
      
      stmt.execute([
        JsonConverter.sanitizeString(student.name),
        student.age,
        JsonConverter.sanitizeString(student.major),
        now,
        now,
      ]);
      
      final id = database.lastInsertRowId;
      stmt.dispose();
      
      return id.toString();
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Failed to create student', details: e.toString());
    }
  }

  @override
  Future<BatchResponse> createStudentsBatch(List<Student> students) async {
    final createdIds = <String>[];
    final errors = <BatchError>[];
    
    // Begin transaction for batch operation
    database.execute('BEGIN TRANSACTION');
    
    try {
      final stmt = database.prepare('''
        INSERT INTO $_tableName (name, age, major, createdAt, updatedAt)
        VALUES (?, ?, ?, ?, ?)
      ''');
      
      for (int i = 0; i < students.length; i++) {
        try {
          final student = students[i];
          
          // Validate student
          if (!student.isValid()) {
            errors.add(BatchError(
              index: i,
              error: 'Validation failed',
              details: student.getValidationErrors().join(', '),
            ));
            continue;
          }
          
          final now = DateTime.now().toIso8601String();
          
          stmt.execute([
            JsonConverter.sanitizeString(student.name),
            student.age,
            JsonConverter.sanitizeString(student.major),
            now,
            now,
          ]);
          
          final id = database.lastInsertRowId;
          createdIds.add(id.toString());
        } catch (e) {
          errors.add(BatchError(
            index: i,
            error: 'Failed to create student',
            details: e.toString(),
          ));
        }
      }
      
      stmt.dispose();
      database.execute('COMMIT');
      
      return BatchResponse.partial(createdIds, errors, students.length);
    } catch (e) {
      database.execute('ROLLBACK');
      throw DatabaseException('Batch create failed', details: e.toString());
    }
  }

  @override
  Future<Student?> getStudentById(String id) async {
    try {
      final stmt = database.prepare('SELECT * FROM $_tableName WHERE id = ?');
      final result = stmt.select([int.parse(id)]);
      stmt.dispose();
      
      if (result.isEmpty) return null;
      
      final row = result.first;
      final data = {
        'id': row['id'].toString(),
        'name': row['name'],
        'age': row['age'],
        'major': row['major'],
        'createdAt': row['createdAt'],
        'updatedAt': row['updatedAt'],
      };
      
      return JsonConverter.adaptStudentFromDatabase(data, databaseType);
    } catch (e) {
      throw DatabaseException('Failed to get student by ID', details: e.toString());
    }
  }

  @override
  Future<PaginatedResponse<Student>> getStudents([StudentQuery? query]) async {
    try {
      query ??= const StudentQuery();
      
      // Build WHERE clause
      final whereConditions = <String>[];
      final whereParams = <dynamic>[];
      
      if (query.nameContains != null) {
        whereConditions.add('name LIKE ?');
        whereParams.add('%${query.nameContains}%');
      }
      
      if (query.major != null) {
        whereConditions.add('major = ?');
        whereParams.add(query.major);
      }
      
      if (query.minAge != null) {
        whereConditions.add('age >= ?');
        whereParams.add(query.minAge);
      }
      
      if (query.maxAge != null) {
        whereConditions.add('age <= ?');
        whereParams.add(query.maxAge);
      }
      
      final whereClause = whereConditions.isNotEmpty 
          ? 'WHERE ${whereConditions.join(' AND ')}'
          : '';
      
      // Build ORDER BY clause
      String orderClause = '';
      if (query.sortBy != null) {
        final direction = query.sortDescending ? 'DESC' : 'ASC';
        orderClause = 'ORDER BY ${query.sortBy} $direction';
      }
      
      // Build LIMIT and OFFSET
      String limitClause = '';
      if (query.limit != null) {
        limitClause = 'LIMIT ${query.limit}';
        if (query.offset != null) {
          limitClause += ' OFFSET ${query.offset}';
        }
      }
      
      // Get total count
      final countQuery = 'SELECT COUNT(*) as count FROM $_tableName $whereClause';
      final countStmt = database.prepare(countQuery);
      final countResult = countStmt.select(whereParams);
      final totalItems = countResult.first['count'] as int;
      countStmt.dispose();
      
      // Get items
      final itemsQuery = 'SELECT * FROM $_tableName $whereClause $orderClause $limitClause';
      final itemsStmt = database.prepare(itemsQuery);
      final itemsResult = itemsStmt.select(whereParams);
      itemsStmt.dispose();
      
      final students = itemsResult.map((row) {
        final data = {
          'id': row['id'].toString(),
          'name': row['name'],
          'age': row['age'],
          'major': row['major'],
          'createdAt': row['createdAt'],
          'updatedAt': row['updatedAt'],
        };
        return JsonConverter.adaptStudentFromDatabase(data, databaseType);
      }).toList();
      
      final page = query.offset != null && query.limit != null 
          ? (query.offset! / query.limit!).floor()
          : 0;
      final pageSize = query.limit ?? totalItems;
      
      return PaginatedResponse.fromItems(students, totalItems, page, pageSize);
    } catch (e) {
      throw DatabaseException('Failed to get students', details: e.toString());
    }
  }

  @override
  Future<int> getStudentsCount([StudentQuery? query]) async {
    try {
      query ??= const StudentQuery();
      
      final whereConditions = <String>[];
      final whereParams = <dynamic>[];
      
      if (query.nameContains != null) {
        whereConditions.add('name LIKE ?');
        whereParams.add('%${query.nameContains}%');
      }
      
      if (query.major != null) {
        whereConditions.add('major = ?');
        whereParams.add(query.major);
      }
      
      if (query.minAge != null) {
        whereConditions.add('age >= ?');
        whereParams.add(query.minAge);
      }
      
      if (query.maxAge != null) {
        whereConditions.add('age <= ?');
        whereParams.add(query.maxAge);
      }
      
      final whereClause = whereConditions.isNotEmpty 
          ? 'WHERE ${whereConditions.join(' AND ')}'
          : '';
      
      final countQuery = 'SELECT COUNT(*) as count FROM $_tableName $whereClause';
      final stmt = database.prepare(countQuery);
      final result = stmt.select(whereParams);
      stmt.dispose();
      
      return result.first['count'] as int;
    } catch (e) {
      throw DatabaseException('Failed to get students count', details: e.toString());
    }
  }

  @override
  Future<bool> updateStudent(String id, Student student) async {
    try {
      // Validate student data
      if (!student.isValid()) {
        throw ValidationException(student.getValidationErrors());
      }

      final stmt = database.prepare('''
        UPDATE $_tableName 
        SET name = ?, age = ?, major = ?, updatedAt = ?
        WHERE id = ?
      ''');
      
      stmt.execute([
        JsonConverter.sanitizeString(student.name),
        student.age,
        JsonConverter.sanitizeString(student.major),
        DateTime.now().toIso8601String(),
        int.parse(id),
      ]);
      
      final rowsAffected = database.getUpdatedRows();
      stmt.dispose();
      
      return rowsAffected > 0;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Failed to update student', details: e.toString());
    }
  }

  @override
  Future<bool> updateStudentFields(String id, Map<String, dynamic> fields) async {
    try {
      final allowedFields = ['name', 'age', 'major'];
      final updateFields = <String>[];
      final params = <dynamic>[];
      
      for (final field in allowedFields) {
        if (fields.containsKey(field)) {
          updateFields.add('$field = ?');
          params.add(fields[field]);
        }
      }
      
      if (updateFields.isEmpty) {
        return false; // No valid fields to update
      }
      
      updateFields.add('updatedAt = ?');
      params.add(DateTime.now().toIso8601String());
      
      final stmt = database.prepare('''
        UPDATE $_tableName 
        SET ${updateFields.join(', ')}
        WHERE id = ?
      ''');
      
      params.add(int.parse(id));
      stmt.execute(params);
      
      final rowsAffected = database.getUpdatedRows();
      stmt.dispose();
      
      return rowsAffected > 0;
    } catch (e) {
      throw DatabaseException('Failed to update student fields', details: e.toString());
    }
  }

  @override
  Future<bool> deleteStudent(String id) async {
    try {
      final stmt = database.prepare('DELETE FROM $_tableName WHERE id = ?');
      stmt.execute([int.parse(id)]);
      
      final rowsAffected = database.getUpdatedRows();
      stmt.dispose();
      
      return rowsAffected > 0;
    } catch (e) {
      throw DatabaseException('Failed to delete student', details: e.toString());
    }
  }

  @override
  Future<int> deleteStudentsWhere(StudentQuery query) async {
    try {
      final whereConditions = <String>[];
      final whereParams = <dynamic>[];
      
      if (query.nameContains != null) {
        whereConditions.add('name LIKE ?');
        whereParams.add('%${query.nameContains}%');
      }
      
      if (query.major != null) {
        whereConditions.add('major = ?');
        whereParams.add(query.major);
      }
      
      if (query.minAge != null) {
        whereConditions.add('age >= ?');
        whereParams.add(query.minAge);
      }
      
      if (query.maxAge != null) {
        whereConditions.add('age <= ?');
        whereParams.add(query.maxAge);
      }
      
      if (whereConditions.isEmpty) {
        throw DatabaseException('Delete query requires at least one condition');
      }
      
      final whereClause = 'WHERE ${whereConditions.join(' AND ')}';
      final stmt = database.prepare('DELETE FROM $_tableName $whereClause');
      stmt.execute(whereParams);
      
      final rowsAffected = database.getUpdatedRows();
      stmt.dispose();
      
      return rowsAffected;
    } catch (e) {
      throw DatabaseException('Failed to delete students', details: e.toString());
    }
  }

  @override
  Future<int> deleteAllStudents() async {
    try {
      final stmt = database.prepare('DELETE FROM $_tableName');
      stmt.execute([]);
      
      final rowsAffected = database.getUpdatedRows();
      stmt.dispose();
      
      return rowsAffected;
    } catch (e) {
      throw DatabaseException('Failed to delete all students', details: e.toString());
    }
  }
}
