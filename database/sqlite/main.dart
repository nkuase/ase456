import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';

/// Simple Student model to demonstrate CRUD operations
class Student {
  int? id;           // Primary key (auto-increment)
  String name;       // Student name
  int age;           // Student age
  String major;      // Student's major

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.major,
  });

  /// Convert Student object to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'major': major,
    };
  }

  /// Create Student object from database Row
  factory Student.fromRow(Row row) {
    return Student(
      id: row['id'] as int,
      name: row['name'] as String,
      age: row['age'] as int,
      major: row['major'] as String,
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, age: $age, major: $major}';
  }
}

/// Database helper class to manage SQLite operations
class DatabaseHelper {
  Database? _database;
  static const String _databaseName = 'students.db';
  static const String _tableName = 'students';
  final String? _customDbPath;  // Allow custom database path for testing

  /// Constructor that optionally accepts a custom database path
  DatabaseHelper({String? customDbPath}) : _customDbPath = customDbPath;

  /// Get database instance (Singleton pattern)
  Database get database {
    if (_database != null) return _database!;
    _database = _initDatabase();
    return _database!;
  }

  /// Initialize database and create table
  Database _initDatabase() {
    // Create database file path (use custom path for testing if provided)
    String dbPath = _customDbPath ?? join(Directory.current.path, _databaseName);
    
    // Open database (creates file if it doesn't exist)
    Database db = sqlite3.open(dbPath);
    
    // Create table if it doesn't exist
    _createTable(db);
    
    print('✅ Database initialized at: $dbPath');
    return db;
  }

  /// Create students table
  void _createTable(Database db) {
    db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        major TEXT NOT NULL
      )
    ''');
    print('✅ Students table created successfully');
  }

  // ==================== CRUD OPERATIONS ====================

  /// CREATE: Insert a new student into the database
  int insertStudent(Student student) {
    final db = database;
    
    // Prepare the SQL statement
    final stmt = db.prepare('''
      INSERT INTO $_tableName (name, age, major)
      VALUES (?, ?, ?)
    ''');
    
    try {
      // Execute the statement with student data
      stmt.execute([student.name, student.age, student.major]);
      
      // Get the auto-generated ID
      int id = db.lastInsertRowId;
      student.id = id;
      
      print('✅ CREATE: Student inserted with ID: $id');
      return id;
    } finally {
      // Always dispose of prepared statements
      stmt.dispose();
    }
  }

  /// READ: Get all students from the database
  List<Student> getAllStudents() {
    final db = database;
    
    // Execute query and get results
    final ResultSet resultSet = db.select('SELECT * FROM $_tableName ORDER BY id');
    
    // Convert results to Student objects
    List<Student> students = resultSet.map((row) => Student.fromRow(row)).toList();
    
    print('✅ READ: Retrieved ${students.length} students');
    return students;
  }

  /// READ: Get a specific student by ID
  Student? getStudentById(int id) {
    final db = database;
    
    // Prepare the query with parameter
    final stmt = db.prepare('SELECT * FROM $_tableName WHERE id = ?');
    
    try {
      // Execute query with the ID parameter
      final ResultSet resultSet = stmt.select([id]);
      
      if (resultSet.isNotEmpty) {
        Student student = Student.fromRow(resultSet.first);
        print('✅ READ: Found student with ID $id');
        return student;
      } else {
        print('❌ READ: No student found with ID $id');
        return null;
      }
    } finally {
      stmt.dispose();
    }
  }

  /// UPDATE: Modify an existing student's information
  int updateStudent(Student student) {
    final db = database;
    
    // Prepare the update statement
    final stmt = db.prepare('''
      UPDATE $_tableName 
      SET name = ?, age = ?, major = ? 
      WHERE id = ?
    ''');
    
    try {
      // Execute the update
      stmt.execute([student.name, student.age, student.major, student.id]);
      
      // Get number of affected rows
      int rowsAffected = db.getUpdatedRows();
      
      if (rowsAffected > 0) {
        print('✅ UPDATE: Student with ID ${student.id} updated successfully');
      } else {
        print('❌ UPDATE: No student found with ID ${student.id}');
      }
      return rowsAffected;
    } finally {
      stmt.dispose();
    }
  }

  /// DELETE: Remove a student from the database
  int deleteStudent(int id) {
    final db = database;
    
    // Prepare the delete statement
    final stmt = db.prepare('DELETE FROM $_tableName WHERE id = ?');
    
    try {
      // Execute the delete
      stmt.execute([id]);
      
      // Get number of affected rows
      int rowsAffected = db.getUpdatedRows();
      
      if (rowsAffected > 0) {
        print('✅ DELETE: Student with ID $id deleted successfully');
      } else {
        print('❌ DELETE: No student found with ID $id');
      }
      return rowsAffected;
    } finally {
      stmt.dispose();
    }
  }

  /// Close database connection
  void close() {
    if (_database != null) {
      _database!.dispose();
      _database = null;
      print('🔒 Database connection closed');
    }
  }
}

/// Main function demonstrating all CRUD operations
void main() {
  print('🎓 SQLite CRUD Demo - Student Management System');
  print('=' * 50);

  // Initialize database helper
  DatabaseHelper dbHelper = DatabaseHelper();

  try {
    // ==================== CREATE OPERATIONS ====================
    print('\n📝 DEMO: CREATE Operations');
    print('-' * 30);

    // Create some sample students
    Student alice = Student(name: 'Alice Johnson', age: 20, major: 'Computer Science');
    Student bob = Student(name: 'Bob Smith', age: 22, major: 'Mathematics');
    Student charlie = Student(name: 'Charlie Brown', age: 19, major: 'Physics');

    // Insert students into database
    alice.id = dbHelper.insertStudent(alice);
    bob.id = dbHelper.insertStudent(bob);
    charlie.id = dbHelper.insertStudent(charlie);

    // ==================== READ OPERATIONS ====================
    print('\n📖 DEMO: READ Operations');
    print('-' * 30);

    // Read all students
    List<Student> allStudents = dbHelper.getAllStudents();
    print('All students in database:');
    for (Student student in allStudents) {
      print('  $student');
    }

    // Read specific student by ID
    print('\nSearching for student with ID 2:');
    Student? foundStudent = dbHelper.getStudentById(2);
    if (foundStudent != null) {
      print('  Found: $foundStudent');
    }

    // ==================== UPDATE OPERATIONS ====================
    print('\n✏️  DEMO: UPDATE Operations');
    print('-' * 30);

    // Update Alice's age and major
    if (alice.id != null) {
      alice.age = 21;
      alice.major = 'Computer Engineering';
      dbHelper.updateStudent(alice);
      
      // Verify the update
      Student? updatedAlice = dbHelper.getStudentById(alice.id!);
      print('Updated Alice: $updatedAlice');
    }

    // ==================== DELETE OPERATIONS ====================
    print('\n🗑️  DEMO: DELETE Operations');
    print('-' * 30);

    // Delete Charlie
    if (charlie.id != null) {
      dbHelper.deleteStudent(charlie.id!);
    }

    // Show remaining students
    print('\nRemaining students after deletion:');
    List<Student> remainingStudents = dbHelper.getAllStudents();
    for (Student student in remainingStudents) {
      print('  $student');
    }

    // ==================== FINAL DEMONSTRATION ====================
    print('\n🎯 Summary of CRUD Operations:');
    print('-' * 30);
    print('✅ CREATE: Added 3 students to database');
    print('✅ READ: Retrieved all students and searched by ID');
    print('✅ UPDATE: Modified Alice\'s age and major');
    print('✅ DELETE: Removed Charlie from database');
    print('\n🎓 CRUD Demo completed successfully!');

  } catch (error) {
    print('❌ Error occurred: $error');
  } finally {
    // Always close the database connection
    dbHelper.close();
  }
}
