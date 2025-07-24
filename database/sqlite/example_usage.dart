import '../common/database_service.dart';
import '../common/student.dart';
import 'sqlite_service.dart';

/// Example usage of SQLite service
/// This demonstrates how to use the database service for desktop/mobile applications
Future<void> main() async {
  print('=== SQLite Student Management Demo ===\n');
  
  // Create database service instance
  DatabaseService db = SQLiteStudentService();
  
  try {
    // Initialize the database
    await db.initialize();
    
    // Clear any existing data for demo
    await db.clearAllStudents();
    
    // Create some sample students
    final students = [
      Student(
        id: 'S001',
        name: 'Alice Johnson',
        age: 20,
        major: 'Computer Science',
        createdAt: DateTime.now(),
      ),
      Student(
        id: 'S002',
        name: 'Bob Smith',
        age: 22,
        major: 'Mathematics',
        createdAt: DateTime.now(),
      ),
      Student(
        id: 'S003',
        name: 'Charlie Brown',
        age: 19,
        major: 'Computer Science',
        createdAt: DateTime.now(),
      ),
      Student(
        id: 'S004',
        name: 'Diana Prince',
        age: 21,
        major: 'Physics',
        createdAt: DateTime.now(),
      ),
      Student(
        id: 'S005',
        name: 'Edward Norton',
        age: 23,
        major: 'Computer Science',
        createdAt: DateTime.now(),
      ),
    ];
    
    // CREATE: Add students to database
    print('--- Creating Students ---');
    for (Student student in students) {
      await db.createStudent(student);
    }
    
    // READ: Get all students
    print('\n--- Reading All Students ---');
    List<Student> allStudents = await db.readAllStudents();
    for (Student student in allStudents) {
      print('  ${student.name} (${student.major}) - Age: ${student.age}');
    }
    
    // READ: Get specific student
    print('\n--- Reading Specific Student ---');
    Student? alice = await db.readStudent('S001');
    if (alice != null) {
      print('  Found: ${alice.name}');
    }
    
    // UPDATE: Modify student information
    print('\n--- Updating Student ---');
    bool updated = await db.updateStudent('S001', {
      'age': 21,
      'major': 'Data Science'
    });
    if (updated) {
      Student? updatedAlice = await db.readStudent('S001');
      print('  Updated Alice: ${updatedAlice?.name} is now ${updatedAlice?.age} years old, majoring in ${updatedAlice?.major}');
    }
    
    // QUERY: Get students by major
    print('\n--- Querying by Major ---');
    List<Student> csStudents = await db.getStudentsByMajor('Computer Science');
    print('  Computer Science students:');
    for (Student student in csStudents) {
      print('    ${student.name} (Age: ${student.age})');
    }
    
    // SEARCH: Find students by name (SQLite supports LIKE queries)
    print('\n--- Searching by Name ---');
    List<Student> searchResults = await db.searchStudentsByName('o'); // Find names containing 'o'
    print('  Students with "o" in name:');
    for (Student student in searchResults) {
      print('    ${student.name} (${student.major})');
    }
    
    // DELETE: Remove a student
    print('\n--- Deleting Student ---');
    bool deleted = await db.deleteStudent('S002');
    if (deleted) {
      print('  Student S002 (Bob) deleted successfully');
    }
    
    // Demonstrate batch operations (SQLite-specific feature)
    print('\n--- SQLite-Specific: Batch Operations ---');
    final batchStudents = [
      Student(id: 'B001', name: 'Batch Student 1', age: 20, major: 'Engineering', createdAt: DateTime.now()),
      Student(id: 'B002', name: 'Batch Student 2', age: 21, major: 'Engineering', createdAt: DateTime.now()),
      Student(id: 'B003', name: 'Batch Student 3', age: 22, major: 'Engineering', createdAt: DateTime.now()),
    ];
    SQLiteStudentService.performBatchInsert(batchStudents);
    
    // Database optimization (SQLite-specific feature)
    print('\n--- SQLite-Specific: Database Optimization ---');
    SQLiteStudentService.optimizeDatabase();
    
    // Final count
    print('\n--- Final Student Count ---');
    List<Student> finalStudents = await db.readAllStudents();
    print('  Total students: ${finalStudents.length}');
    for (Student student in finalStudents) {
      print('    ${student.name} (${student.major}) - Age: ${student.age}');
    }
    
  } catch (e) {
    print('Error: $e');
  } finally {
    // Close database connection
    await db.close();
    print('\n✅ SQLite demo completed!');
  }
}

/// Example of database switching - same logic, different storage
Future<void> demonstrateDatabaseSwitching() async {
  print('\n=== Database Switching Example ===');
  
  // This function works with ANY database service!
  Future<void> performStudentOperations(DatabaseService db, String dbName) async {
    print('\n--- Using $dbName ---');
    
    await db.initialize();
    await db.clearAllStudents();
    
    // Create a student
    final student = Student(
      id: 'TEST001',
      name: 'Test Student',
      age: 25,
      major: 'Testing',
      createdAt: DateTime.now(),
    );
    
    await db.createStudent(student);
    
    // Read it back
    Student? retrieved = await db.readStudent('TEST001');
    print('  Retrieved: ${retrieved?.name} from $dbName');
    
    await db.close();
  }
  
  // Same function, different databases!
  await performStudentOperations(SQLiteStudentService(), 'SQLite');
  // await performStudentOperations(IndexedDBStudentService(), 'IndexedDB');
  // await performStudentOperations(FirebaseStudentService(), 'Firebase');
}

/// Advanced SQLite example demonstrating SQL-specific features
Future<void> advancedSQLiteDemo() async {
  print('\n=== Advanced SQLite Features Demo ===');
  
  DatabaseService db = SQLiteStudentService();
  
  try {
    await db.initialize();
    await db.clearAllStudents();
    
    // Create students with varied data for complex queries
    final students = [
      Student(id: 'CS001', name: 'Alice Anderson', age: 20, major: 'Computer Science', createdAt: DateTime.now()),
      Student(id: 'CS002', name: 'Bob Baker', age: 22, major: 'Computer Science', createdAt: DateTime.now()),
      Student(id: 'MA001', name: 'Carol Chen', age: 19, major: 'Mathematics', createdAt: DateTime.now()),
      Student(id: 'PH001', name: 'David Davis', age: 21, major: 'Physics', createdAt: DateTime.now()),
      Student(id: 'CS003', name: 'Eve Evans', age: 23, major: 'Computer Science', createdAt: DateTime.now()),
    ];
    
    // Batch insert for efficiency
    SQLiteStudentService.performBatchInsert(students);
    
    // Complex queries by major
    print('\n--- Students by Major ---');
    final csStudents = await db.getStudentsByMajor('Computer Science');
    print('  Computer Science (${csStudents.length} students):');
    for (var student in csStudents) {
      print('    ${student.name} - Age: ${student.age}');
    }
    
    // Name search with partial matching
    print('\n--- Name Search (partial matching) ---');
    final nameSearchResults = await db.searchStudentsByName('a');
    print('  Students with "a" in name (${nameSearchResults.length} found):');
    for (var student in nameSearchResults) {
      print('    ${student.name} (${student.major})');
    }
    
    // Demonstrate database maintenance
    print('\n--- Database Maintenance ---');
    SQLiteStudentService.optimizeDatabase();
    
  } catch (e) {
    print('Error in advanced demo: $e');
  } finally {
    await db.close();
    print('\n✅ Advanced SQLite demo completed!');
  }
}
