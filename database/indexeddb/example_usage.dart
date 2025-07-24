import '../common/database_service.dart';
import '../common/student.dart';
import 'indexeddb_service.dart';

/// Example usage of IndexedDB service
/// This demonstrates how to use the database service for browser applications
Future<void> main() async {
  print('=== IndexedDB Student Management Demo ===\n');
  
  // Create database service instance
  DatabaseService db = IndexedDBStudentService();
  
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
    
    // SEARCH: Find students by name
    print('\n--- Searching by Name ---');
    List<Student> bobStudents = await db.searchStudentsByName('Bob');
    print('  Students with "Bob" in name:');
    for (Student student in bobStudents) {
      print('    ${student.name} (${student.major})');
    }
    
    // DELETE: Remove a student
    print('\n--- Deleting Student ---');
    bool deleted = await db.deleteStudent('S002');
    if (deleted) {
      print('  Student S002 (Bob) deleted successfully');
    }
    
    // Final count
    print('\n--- Final Student Count ---');
    List<Student> finalStudents = await db.readAllStudents();
    print('  Remaining students: ${finalStudents.length}');
    for (Student student in finalStudents) {
      print('    ${student.name} (${student.major})');
    }
    
  } catch (e) {
    print('Error: $e');
  } finally {
    // Close database connection
    await db.close();
    print('\n✅ IndexedDB demo completed!');
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
  await performStudentOperations(IndexedDBStudentService(), 'IndexedDB');
  // await performStudentOperations(SQLiteStudentService(), 'SQLite');
  // await performStudentOperations(FirebaseStudentService(), 'Firebase');
}
