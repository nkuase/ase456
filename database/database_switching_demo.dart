import 'common/database_service.dart';
import 'common/student.dart';
import 'sqlite/sqlite_service.dart';
import 'indexeddb/indexeddb_service.dart';

/// Comprehensive Database Switching Demo
/// 
/// This demo shows how the same business logic can work with different 
/// database implementations (SQLite, IndexedDB, Firebase, etc.)
/// 
/// Key Learning Points:
/// 1. Interface-based programming allows database switching
/// 2. Business logic remains unchanged
/// 3. Only the database adapter changes
/// 4. Same API works across different storage technologies

/// Business logic that works with ANY database implementation
class StudentManager {
  final DatabaseService _db;
  
  StudentManager(this._db);
  
  /// Initialize the student management system
  Future<void> initialize() async {
    await _db.initialize();
    print('📚 Student Management System initialized');
  }
  
  /// Enroll a new student
  Future<void> enrollStudent({
    required String id,
    required String name,
    required int age,
    required String major,
  }) async {
    final student = Student(
      id: id,
      name: name,
      age: age,
      major: major,
      createdAt: DateTime.now(),
    );
    
    await _db.createStudent(student);
    print('✅ Enrolled: $name ($major)');
  }
  
  /// Get class roster by major
  Future<List<Student>> getClassRoster(String major) async {
    final students = await _db.getStudentsByMajor(major);
    print('📋 $major class roster: ${students.length} students');
    return students;
  }
  
  /// Update student information
  Future<void> updateStudentRecord(String id, Map<String, dynamic> updates) async {
    final success = await _db.updateStudent(id, updates);
    if (success) {
      print('📝 Updated student record: $id');
    } else {
      print('❌ Failed to update student: $id');
    }
  }
  
  /// Find students by name search
  Future<List<Student>> searchStudents(String searchTerm) async {
    final results = await _db.searchStudentsByName(searchTerm);
    print('🔍 Search "$searchTerm": ${results.length} matches');
    return results;
  }
  
  /// Generate semester report
  Future<Map<String, int>> generateSemesterReport() async {
    final allStudents = await _db.readAllStudents();
    final majorCounts = <String, int>{};
    
    for (final student in allStudents) {
      majorCounts[student.major] = (majorCounts[student.major] ?? 0) + 1;
    }
    
    print('\n📊 Semester Report:');
    print('   Total Students: ${allStudents.length}');
    majorCounts.forEach((major, count) {
      print('   $major: $count students');
    });
    
    return majorCounts;
  }
  
  /// Graduate a student (remove from system)
  Future<void> graduateStudent(String id) async {
    final student = await _db.readStudent(id);
    if (student != null) {
      await _db.deleteStudent(id);
      print('🎓 Graduated: ${student.name}');
    }
  }
  
  /// Close the system
  Future<void> close() async {
    await _db.close();
    print('🔒 Student Management System closed');
  }
}

/// Demo function that works with ANY database
Future<void> runStudentManagementDemo(DatabaseService db, String dbType) async {
  print('\n' + '=' * 60);
  print('🎯 Running Student Management Demo with $dbType');
  print('=' * 60);
  
  final manager = StudentManager(db);
  
  try {
    // Initialize the system
    await manager.initialize();
    
    // Clear existing data for clean demo
    await db.clearAllStudents();
    
    // Enroll some students
    print('\n--- 📝 Enrolling Students ---');
    await manager.enrollStudent(
      id: 'CS001',
      name: 'Alice Johnson',
      age: 20,
      major: 'Computer Science',
    );
    
    await manager.enrollStudent(
      id: 'CS002',
      name: 'Bob Smith',
      age: 22,
      major: 'Computer Science',
    );
    
    await manager.enrollStudent(
      id: 'MA001',
      name: 'Carol Chen',
      age: 19,
      major: 'Mathematics',
    );
    
    await manager.enrollStudent(
      id: 'PH001',
      name: 'David Davis',
      age: 21,
      major: 'Physics',
    );
    
    await manager.enrollStudent(
      id: 'CS003',
      name: 'Eve Evans',
      age: 23,
      major: 'Computer Science',
    );
    
    // Generate initial report
    await manager.generateSemesterReport();
    
    // Get class rosters
    print('\n--- 📋 Class Rosters ---');
    final csStudents = await manager.getClassRoster('Computer Science');
    for (final student in csStudents) {
      print('   ${student.name} (Age: ${student.age})');
    }
    
    // Search for students
    print('\n--- 🔍 Student Search ---');
    final searchResults = await manager.searchStudents('o');
    for (final student in searchResults) {
      print('   ${student.name} (${student.major})');
    }
    
    // Update student record
    print('\n--- 📝 Updating Records ---');
    await manager.updateStudentRecord('CS001', {
      'age': 21,
      'major': 'Data Science'
    });
    
    // Graduate a student
    print('\n--- 🎓 Graduation ---');
    await manager.graduateStudent('PH001');
    
    // Final report
    print('\n--- 📊 Final Report ---');
    await manager.generateSemesterReport();
    
    print('\n✅ Demo completed successfully with $dbType!');
    
  } catch (e) {
    print('\n❌ Demo failed with $dbType: $e');
  } finally {
    await manager.close();
  }
}

/// Main function demonstrating database switching
Future<void> main() async {
  print('🎓 DATABASE SWITCHING DEMONSTRATION');
  print('====================================');
  print('This demo shows how the SAME business logic works with different databases!');
  
  // Demo 1: SQLite (Desktop/Mobile)
  print('\n🗃️ Testing with SQLite (Desktop/Mobile)...');
  await runStudentManagementDemo(SQLiteStudentService(), 'SQLite');
  
  // Demo 2: IndexedDB (Browser) - Commented out since it requires browser environment
  // print('\n🌐 Testing with IndexedDB (Browser)...');
  // await runStudentManagementDemo(IndexedDBStudentService(), 'IndexedDB');
  
  // Demo 3: Firebase (Cloud) - Would work if Firebase service was implemented
  // print('\n☁️ Testing with Firebase (Cloud)...');
  // await runStudentManagementDemo(FirebaseStudentService(), 'Firebase');
  
  print('\n' + '=' * 60);
  print('🎯 KEY TAKEAWAYS:');
  print('=' * 60);
  print('✅ Same business logic works with different databases');
  print('✅ Interface-based design enables easy switching');
  print('✅ Code is database-agnostic and maintainable');
  print('✅ Can adapt to different platform requirements');
  print('\n🚀 This is the power of abstraction and interface design!');
}

/// Advanced demo showing concurrent database operations
Future<void> advancedConcurrencyDemo() async {
  print('\n' + '=' * 60);
  print('⚡ ADVANCED: Concurrent Database Operations');
  print('=' * 60);
  
  final db = SQLiteStudentService();
  await db.initialize();
  await db.clearAllStudents();
  
  // Create multiple students concurrently
  final futures = <Future>[];
  
  for (int i = 1; i <= 10; i++) {
    futures.add(db.createStudent(Student(
      id: 'BATCH$i',
      name: 'Student $i',
      age: 18 + (i % 5),
      major: i % 2 == 0 ? 'Computer Science' : 'Mathematics',
      createdAt: DateTime.now(),
    )));
  }
  
  // Wait for all operations to complete
  await Future.wait(futures);
  
  // Read all students
  final students = await db.readAllStudents();
  print('Created ${students.length} students concurrently');
  
  await db.close();
}

/// Performance comparison demo
Future<void> performanceComparisonDemo() async {
  print('\n' + '=' * 60);
  print('📊 PERFORMANCE: Database Operation Timing');
  print('=' * 60);
  
  Future<void> timeOperation(String operation, Future<void> Function() fn) async {
    final stopwatch = Stopwatch()..start();
    await fn();
    stopwatch.stop();
    print('$operation: ${stopwatch.elapsedMilliseconds}ms');
  }
  
  final db = SQLiteStudentService();
  await db.initialize();
  await db.clearAllStudents();
  
  // Time various operations
  await timeOperation('Database initialization', () async {
    // Already initialized, but shows the concept
  });
  
  await timeOperation('Single student creation', () async {
    await db.createStudent(Student(
      id: 'PERF001',
      name: 'Performance Test',
      age: 20,
      major: 'Testing',
      createdAt: DateTime.now(),
    ));
  });
  
  await timeOperation('Student retrieval', () async {
    await db.readStudent('PERF001');
  });
  
  await timeOperation('All students query', () async {
    await db.readAllStudents();
  });
  
  await timeOperation('Student update', () async {
    await db.updateStudent('PERF001', {'age': 21});
  });
  
  await timeOperation('Student deletion', () async {
    await db.deleteStudent('PERF001');
  });
  
  await db.close();
}
