import '../models/student.dart';
import '../services/database_service.dart';
import '../services/firebase_database_adapter.dart';

/// Database Abstraction Demo
/// Shows how to use the same code with different database backends
/// This demonstrates the power of interface-based programming
class DatabaseAbstractionDemo {
  
  /// Demo using database abstraction - works with any DatabaseService implementation
  static Future<void> runDatabaseDemo(DatabaseService db, String dbName) async {
    print('\n🔀 === Database Abstraction Demo with $dbName ===');
    
    try {
      // Initialize the database service
      print('1️⃣ Initializing $dbName service...');
      await db.initialize();
      
      // Create some students using the abstract interface
      print('2️⃣ Creating students...');
      
      List<Student> studentsToCreate = [
        Student(
          id: '',
          name: 'Alice Cooper',
          age: 20,
          major: 'Computer Science',
          createdAt: DateTime.now(),
        ),
        Student(
          id: '',
          name: 'Bob Dylan',
          age: 22,
          major: 'Music Theory',
          createdAt: DateTime.now(),
        ),
      ];
      
      // Create students one by one
      List<String> createdIds = [];
      for (Student student in studentsToCreate) {
        String id = await db.createStudent(student);
        createdIds.add(id);
        print('   ✅ Created: ${student.name} (ID: $id)');
      }
      
      // Read all students
      print('3️⃣ Reading all students...');
      List<Student> allStudents = await db.getAllStudents();
      print('   📖 Found ${allStudents.length} students total');
      
      // Query students by major
      print('4️⃣ Querying students by major...');
      List<Student> csStudents = await db.getStudentsByMajor('Computer Science');
      print('   🔍 Found ${csStudents.length} Computer Science students');
      
      // Update a student
      if (createdIds.isNotEmpty) {
        print('5️⃣ Updating student...');
        await db.updateStudent(createdIds.first, {
          'age': 21,
          'major': 'Data Science'
        });
        print('   ✏️ Updated student ${createdIds.first}');
      }
      
      // Count students
      int totalCount = await db.getStudentCount();
      print('6️⃣ Total students in database: $totalCount');
      
      // Clean up - delete the students we created
      print('7️⃣ Cleaning up...');
      for (String id in createdIds) {
        await db.deleteStudent(id);
        print('   🗑️ Deleted student $id');
      }
      
      print('✅ Database demo with $dbName completed successfully!');
      
    } catch (e) {
      print('❌ Database demo with $dbName failed: $e');
    }
  }
  
  /// Show how to easily switch between database implementations
  static Future<void> switchingDatabases() async {
    print('\n🔄 === Database Switching Demo ===');
    print('This demo shows how the same code works with different databases');
    
    // Example 1: Using Firebase
    print('\n📊 Testing with Firebase adapter...');
    DatabaseService firebaseDb = FirebaseDatabaseAdapter();
    await runDatabaseDemo(firebaseDb, 'Firebase');
    
    // Example 2: Using PocketBase (would need to import the adapter)
    print('\n📦 Testing with PocketBase would work the same way...');
    print('DatabaseService pocketbaseDb = PocketBaseDatabaseAdapter();');
    print('await runDatabaseDemo(pocketbaseDb, "PocketBase");');
    
    print('\n🎯 Key Benefits of Database Abstraction:');
    print('   ✅ Same code works with different databases');
    print('   ✅ Easy to switch implementations');
    print('   ✅ Testable with mock implementations');
    print('   ✅ Vendor-independent application logic');
    print('   ✅ Follows SOLID principles');
  }
  
  /// Example of a business logic function that is database-agnostic
  static Future<void> businessLogicExample(DatabaseService db) async {
    print('\n💼 === Business Logic Example ===');
    print('This function works with ANY database implementation');
    
    try {
      // This business logic function doesn't care about the underlying database
      await promoteTopStudents(db);
      await generateStudentReport(db);
      
    } catch (e) {
      print('❌ Business logic failed: $e');
    }
  }
  
  /// Business logic: Promote top students to advanced courses
  static Future<void> promoteTopStudents(DatabaseService db) async {
    print('\n🎓 Promoting top students...');
    
    // Get students in Computer Science
    List<Student> csStudents = await db.getStudentsByMajor('Computer Science');
    
    // Find older students (age >= 22) - they get promoted
    List<Student> topStudents = csStudents.where((s) => s.age >= 22).toList();
    
    for (Student student in topStudents) {
      await db.updateStudent(student.id, {
        'major': 'Advanced Computer Science'
      });
      print('   🎯 Promoted ${student.name} to Advanced Computer Science');
    }
    
    print('   ✅ Promoted ${topStudents.length} students');
  }
  
  /// Business logic: Generate a student report
  static Future<void> generateStudentReport(DatabaseService db) async {
    print('\n📊 Generating student report...');
    
    // Get all students
    List<Student> allStudents = await db.getAllStudents();
    
    // Group by major
    Map<String, List<Student>> studentsByMajor = {};
    for (Student student in allStudents) {
      studentsByMajor.putIfAbsent(student.major, () => []).add(student);
    }
    
    // Print report
    print('   📈 Student Report:');
    studentsByMajor.forEach((major, students) {
      double avgAge = students.map((s) => s.age).reduce((a, b) => a + b) / students.length;
      print('     • $major: ${students.length} students, avg age: ${avgAge.toStringAsFixed(1)}');
    });
  }
  
  /// Mock database service for testing
  static DatabaseService createMockDatabase() {
    return MockDatabaseService();
  }
}

/// Mock database service for testing and demos
class MockDatabaseService implements DatabaseService {
  final List<Student> _students = [];
  int _idCounter = 1;
  
  @override
  Future<void> initialize() async {
    print('✅ Mock database initialized');
  }
  
  @override
  String generateId() => 'mock-${_idCounter++}';
  
  @override
  Future<String> createStudent(Student student) async {
    String id = generateId();
    Student newStudent = student.copyWith(id: id);
    _students.add(newStudent);
    return id;
  }
  
  @override
  Future<void> createStudentWithId(Student student) async {
    _students.add(student);
  }
  
  @override
  Future<void> createMultipleStudents(List<Student> students) async {
    for (Student student in students) {
      await createStudent(student);
    }
  }
  
  @override
  Future<List<Student>> getAllStudents() async => List.from(_students);
  
  @override
  Future<Student?> getStudentById(String id) async {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<Student>> getStudentsByMajor(String major) async {
    return _students.where((s) => s.major == major).toList();
  }
  
  @override
  Future<List<Student>> getStudentsByAgeRange(int minAge, int maxAge) async {
    return _students.where((s) => s.age >= minAge && s.age <= maxAge).toList();
  }
  
  @override
  Future<List<Student>> searchStudentsByName(String nameQuery) async {
    return _students.where((s) => s.name.toLowerCase().contains(nameQuery.toLowerCase())).toList();
  }
  
  @override
  Stream<List<Student>> getStudentsStream() async* {
    while (true) {
      yield List.from(_students);
      await Future.delayed(Duration(seconds: 1));
    }
  }
  
  @override
  Future<int> getStudentCount() async => _students.length;
  
  @override
  Future<void> updateStudent(String id, Map<String, dynamic> updates) async {
    int index = _students.indexWhere((s) => s.id == id);
    if (index != -1) {
      Student student = _students[index];
      Student updated = student.copyWith(
        name: updates['name'] ?? student.name,
        age: updates['age'] ?? student.age,
        major: updates['major'] ?? student.major,
      );
      _students[index] = updated;
    }
  }
  
  @override
  Future<void> updateEntireStudent(Student student) async {
    int index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _students[index] = student;
    }
  }
  
  @override
  Future<void> incrementStudentAge(String id) async {
    await updateStudent(id, {'age': (_students.firstWhere((s) => s.id == id).age + 1)});
  }
  
  @override
  Future<void> transferStudentMajor(String studentId, String newMajor) async {
    await updateStudent(studentId, {'major': newMajor});
  }
  
  @override
  Future<void> deleteStudent(String id) async {
    _students.removeWhere((s) => s.id == id);
  }
  
  @override
  Future<void> deleteAllStudents() async {
    _students.clear();
  }
  
  @override
  Future<int> deleteStudentsByMajor(String major) async {
    int initialCount = _students.length;
    _students.removeWhere((s) => s.major == major);
    return initialCount - _students.length;
  }
}
