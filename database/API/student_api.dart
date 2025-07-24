import 'simple_database.dart';
import 'student.dart';
import 'memory_database.dart';
import 'file_database.dart';

/// The main Student API that freshmen will use
/// This is the "magic" interface that makes database switching easy!
/// 
/// Key idea: Students use simple methods like addStudent()
/// Behind the scenes, we can switch between different databases
class StudentAPI {
  
  // This holds our current database
  SimpleDatabase _database;
  
  // Constructor - starts with memory database by default
  StudentAPI({SimpleDatabase? database}) 
    : _database = database ?? MemoryDatabase();
  
  /// Initialize the API (must call this first!)
  Future<void> initialize() async {
    print('🚀 Initializing Student API with ${_database.databaseType}');
    
    // If it's a file database, we need to load existing data
    if (_database is FileDatabase) {
      await (_database as FileDatabase).initialize();
    }
    
    print('✅ Student API ready!');
  }
  
  /// Switch to a different database
  /// This is the MAGIC of our API - same interface, different storage!
  Future<void> switchDatabase(SimpleDatabase newDatabase) async {
    print('\n🔄 Switching from ${_database.databaseType} to ${newDatabase.databaseType}');
    
    // Get all students from current database
    List<Student> allStudents = await _database.getAllStudents();
    
    // Close old database
    await _database.close();
    
    // Switch to new database
    _database = newDatabase;
    
    // If it's a file database, initialize it
    if (_database is FileDatabase) {
      await (_database as FileDatabase).initialize();
    }
    
    // Move all students to new database
    for (Student student in allStudents) {
      await _database.addStudent(student);
    }
    
    print('✅ Successfully switched to ${_database.databaseType}');
    print('📦 Transferred ${allStudents.length} students');
  }
  
  /// Add a new student (easy method for freshmen)
  Future<bool> addStudent({
    required String name,
    required int age,
    required String major,
  }) async {
    Student student = Student(name: name, age: age, major: major);
    return await _database.addStudent(student);
  }
  
  /// Get all students
  Future<List<Student>> getAllStudents() async {
    return await _database.getAllStudents();
  }
  
  /// Find students by what they study
  Future<List<Student>> findByMajor(String major) async {
    return await _database.findByMajor(major);
  }
  
  /// Find a specific student by name
  Future<Student?> findByName(String name) async {
    return await _database.findByName(name);
  }
  
  /// Update a student's age (maybe they had a birthday!)
  Future<bool> updateAge(String name, int newAge) async {
    return await _database.updateAge(name, newAge);
  }
  
  /// Remove a student (maybe they graduated!)
  Future<bool> removeStudent(String name) async {
    return await _database.deleteStudent(name);
  }
  
  /// Remove all students (start fresh)
  Future<void> clearAll() async {
    await _database.clearAll();
  }
  
  /// Get info about current database
  String getCurrentDatabaseType() {
    return _database.databaseType;
  }
  
  /// Close the API and save everything
  Future<void> close() async {
    await _database.close();
    print('👋 Student API closed');
  }
  
  /// Show a summary of all students (helpful for demos)
  Future<void> showSummary() async {
    List<Student> allStudents = await getAllStudents();
    
    print('\n📊 STUDENT SUMMARY');
    print('==================');
    print('Database: ${_database.databaseType}');
    print('Total Students: ${allStudents.length}');
    
    if (allStudents.isEmpty) {
      print('No students found.');
      return;
    }
    
    // Group by major
    Map<String, int> majorCounts = {};
    for (Student student in allStudents) {
      majorCounts[student.major] = (majorCounts[student.major] ?? 0) + 1;
    }
    
    print('\nBy Major:');
    majorCounts.forEach((major, count) {
      print('  $major: $count students');
    });
    
    print('\nAll Students:');
    for (Student student in allStudents) {
      print('  ${student.name} (age ${student.age}) - ${student.major}');
    }
    print('==================\n');
  }
}
