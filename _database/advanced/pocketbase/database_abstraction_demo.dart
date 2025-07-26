import '../../pocketbase/students/lib/models/student.dart';
import '../../pocketbase/students/lib/services/database_crud.dart';
import '../../pocketbase/students/lib/services/pocketbase_database_adapter.dart';

/// Database Abstraction Demo Functions
/// Shows how to use the same code with different database backends
/// This demonstrates the power of interface-based programming

/// Demo using database abstraction - works with any DatabaseService implementation
Future<void> runDatabaseDemo(DatabaseCrudService db, String dbName) async {
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
      await db.updateStudent(
          createdIds.first, {'age': 21, 'major': 'Data Science'});
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
  } catch (e, stackTrace) {
    print('❌ Database demo with $dbName failed: $e');
    print('📍 Stack trace: $stackTrace');
  }
}

/// Show how to easily switch between database implementations
Future<void> demonstrateDatabaseSwitching() async {
  print('\n🔄 === Database Switching Demo ===');
  print('This demo shows how the same code works with different databases');

  // Example 1: Using Mock database for testing
  print('\n🧪 Testing with Mock database...');
  DatabaseCrudService mockDb = createMockDatabase();
  await runDatabaseDemo(mockDb, 'Mock');

  // Example 2: Using PocketBase
  print('\n📦 Testing with PocketBase adapter...');
  try {
    DatabaseCrudService pocketbaseDb = PocketBaseDatabaseAdapter();
    await runDatabaseDemo(pocketbaseDb, 'PocketBase');
  } catch (e) {
    print('⚠️ PocketBase not configured or unavailable: $e');
    print('💡 This is normal if PocketBase server is not running');
  }

  // Example 3: Explain other potential implementations
  print('\n📊 Other database implementations would work the same way...');
  print('DatabaseService firebaseDb = FirebaseDatabaseAdapter();');
  print('await runDatabaseDemo(firebaseDb, "Firebase");');
  print('DatabaseService sqliteDb = SQLiteDatabaseAdapter();');
  print('await runDatabaseDemo(sqliteDb, "SQLite");');

  print('\n🎯 Key Benefits of Database Abstraction:');
  print('   ✅ Same code works with different databases');
  print('   ✅ Easy to switch implementations');
  print('   ✅ Testable with mock implementations');
  print('   ✅ Vendor-independent application logic');
  print('   ✅ Follows SOLID principles (Dependency Inversion)');
}

/// Example of a business logic function that is database-agnostic
Future<void> demonstrateBusinessLogic(DatabaseCrudService db) async {
  print('\n💼 === Business Logic Example ===');
  print('This function works with ANY database implementation');

  try {
    // This business logic function doesn't care about the underlying database
    await promoteTopStudents(db);
    await generateStudentReport(db);
  } catch (e, stackTrace) {
    print('❌ Business logic failed: $e');
    print('📍 Stack trace: $stackTrace');
  }
}

/// Business logic: Promote top students to advanced courses
Future<void> promoteTopStudents(DatabaseCrudService db) async {
  print('\n🎓 Promoting top students...');

  try {
    // Get students in Computer Science
    List<Student> csStudents = await db.getStudentsByMajor('Computer Science');

    // Find older students (age >= 22) - they get promoted
    List<Student> topStudents = csStudents.where((s) => s.age >= 22).toList();

    for (Student student in topStudents) {
      await db
          .updateStudent(student.id, {'major': 'Advanced Computer Science'});
      print('   🎯 Promoted ${student.name} to Advanced Computer Science');
    }

    print('   ✅ Promoted ${topStudents.length} students');
  } catch (e) {
    print('   ❌ Error promoting students: $e');
    rethrow;
  }
}

/// Business logic: Generate a student report
Future<void> generateStudentReport(DatabaseCrudService db) async {
  print('\n📊 Generating student report...');

  try {
    // Get all students
    List<Student> allStudents = await db.getAllStudents();

    if (allStudents.isEmpty) {
      print('   📋 No students found');
      return;
    }

    // Group by major
    Map<String, List<Student>> studentsByMajor = {};
    for (Student student in allStudents) {
      studentsByMajor.putIfAbsent(student.major, () => []).add(student);
    }

    // Print report
    print('   📈 Student Report:');
    studentsByMajor.forEach((major, students) {
      double avgAge =
          students.map((s) => s.age).reduce((a, b) => a + b) / students.length;
      print(
          '     • $major: ${students.length} students, avg age: ${avgAge.toStringAsFixed(1)}');
    });
  } catch (e) {
    print('   ❌ Error generating report: $e');
    rethrow;
  }
}

/// Demo showing advanced database operations
Future<void> demonstrateAdvancedOperations(DatabaseCrudService db) async {
  print('\n🚀 === Advanced Operations Demo ===');

  try {
    // Test age range queries
    print('🔍 Finding students aged 20-25...');
    List<Student> youngAdults = await db.getStudentsByAgeRange(20, 25);
    print('   Found ${youngAdults.length} students in age range 20-25');

    // Test search functionality
    print('🔍 Searching for students with "Alice" in name...');
    List<Student> searchResults = await db.searchStudentsByName('Alice');
    print('   Found ${searchResults.length} students matching "Alice"');

    // Test bulk operations
    print('📦 Testing bulk operations...');
    List<Student> bulkStudents = [
      Student(
        id: '',
        name: 'Charlie Brown',
        age: 19,
        major: 'Mathematics',
        createdAt: DateTime.now(),
      ),
      Student(
        id: '',
        name: 'Diana Prince',
        age: 23,
        major: 'Physics',
        createdAt: DateTime.now(),
      ),
    ];

    await db.createMultipleStudents(bulkStudents);
    print('   ✅ Created ${bulkStudents.length} students in bulk');

    // Test counting and deletion
    int mathStudents = (await db.getStudentsByMajor('Mathematics')).length;
    print('📊 Mathematics students before deletion: $mathStudents');

    int deletedCount = await db.deleteStudentsByMajor('Mathematics');
    print('🗑️ Deleted $deletedCount Mathematics students');
  } catch (e, stackTrace) {
    print('❌ Advanced operations failed: $e');
    print('📍 Stack trace: $stackTrace');
  }
}

/// Create mock database service for testing
DatabaseCrudService createMockDatabase() {
  return MockDatabaseService();
}

/// Comprehensive demo runner that showcases all database abstraction features
Future<void> runComprehensiveDemo() async {
  print('🚀 Starting Comprehensive Database Abstraction Demo');
  print('===================================================\n');

  try {
    // Demo 1: Basic database switching
    await demonstrateDatabaseSwitching();

    // Demo 2: Business logic that works with any database
    print('\n' + '=' * 50);
    DatabaseCrudService mockDb = createMockDatabase();
    await demonstrateBusinessLogic(mockDb);

    // Demo 3: Advanced operations
    print('\n' + '=' * 50);
    await demonstrateAdvancedOperations(mockDb);

    print('\n🎉 All demos completed successfully!');
    print('\n📚 Educational Takeaways:');
    print('   • Interface-based programming enables flexibility');
    print('   • Mock implementations are great for testing');
    print('   • Business logic stays database-independent');
    print('   • Easy to switch between different database providers');
    print('   • SOLID principles in action (Dependency Inversion)');
  } catch (e, stackTrace) {
    print('\n❌ Demo failed with error: $e');
    print('📍 Stack trace: $stackTrace');
  }
}

/// Mock database service for testing and demos
/// This implementation stores data in memory and simulates database operations
class MockDatabaseService implements DatabaseCrudService {
  final List<Student> _students = [];
  int _idCounter = 1;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    print('✅ Mock database initialized');
    _isInitialized = true;
  }

  @override
  String generateId() => 'mock-${_idCounter++}';

  /// Helper method to ensure database is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
  }

  @override
  Future<String> createStudent(Student student) async {
    _ensureInitialized();
    String id = generateId();
    Student newStudent = student.copyWith(id: id);
    _students.add(newStudent);
    return id;
  }

  @override
  Future<void> createStudentWithId(Student student) async {
    _ensureInitialized();
    // Check if student with this ID already exists
    bool exists = _students.any((s) => s.id == student.id);
    if (exists) {
      throw ArgumentError('Student with ID ${student.id} already exists');
    }
    _students.add(student);
  }

  @override
  Future<void> createMultipleStudents(List<Student> students) async {
    _ensureInitialized();
    for (Student student in students) {
      await createStudent(student);
    }
  }

  @override
  Future<List<Student>> getAllStudents() async {
    _ensureInitialized();
    return List.from(_students);
  }

  @override
  Future<Student?> getStudentById(String id) async {
    _ensureInitialized();
    try {
      // Use where and first to safely find the student
      final matches = _students.where((s) => s.id == id);
      return matches.isNotEmpty ? matches.first : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Student>> getStudentsByMajor(String major) async {
    _ensureInitialized();
    return _students.where((s) => s.major == major).toList();
  }

  @override
  Future<List<Student>> getStudentsByAgeRange(int minAge, int maxAge) async {
    _ensureInitialized();
    return _students.where((s) => s.age >= minAge && s.age <= maxAge).toList();
  }

  @override
  Future<List<Student>> searchStudentsByName(String nameQuery) async {
    _ensureInitialized();
    return _students
        .where((s) => s.name.toLowerCase().contains(nameQuery.toLowerCase()))
        .toList();
  }

  @override
  Stream<List<Student>> getStudentsStream() async* {
    _ensureInitialized();
    // Yield current data and stop (for testing purposes)
    yield List.from(_students);
  }

  @override
  Future<int> getStudentCount() async {
    _ensureInitialized();
    return _students.length;
  }

  @override
  Future<void> updateStudent(String id, Map<String, dynamic> updates) async {
    _ensureInitialized();
    int index = _students.indexWhere((s) => s.id == id);
    if (index == -1) {
      throw ArgumentError('Student with ID $id not found');
    }

    Student student = _students[index];
    Student updated = student.copyWith(
      name: updates['name'] as String? ?? student.name,
      age: updates['age'] as int? ?? student.age,
      major: updates['major'] as String? ?? student.major,
    );
    _students[index] = updated;
  }

  @override
  Future<void> updateEntireStudent(Student student) async {
    _ensureInitialized();
    int index = _students.indexWhere((s) => s.id == student.id);
    if (index == -1) {
      throw ArgumentError('Student with ID ${student.id} not found');
    }
    _students[index] = student;
  }

  @override
  Future<void> incrementStudentAge(String id) async {
    _ensureInitialized();
    int index = _students.indexWhere((s) => s.id == id);
    if (index == -1) {
      throw ArgumentError('Student with ID $id not found');
    }

    Student student = _students[index];
    await updateStudent(id, {'age': student.age + 1});
  }

  @override
  Future<void> transferStudentMajor(String studentId, String newMajor) async {
    _ensureInitialized();
    await updateStudent(studentId, {'major': newMajor});
  }

  @override
  Future<void> deleteStudent(String id) async {
    _ensureInitialized();
    int initialLength = _students.length;
    _students.removeWhere((s) => s.id == id);
    if (_students.length == initialLength) {
      throw ArgumentError('Student with ID $id not found');
    }
  }

  @override
  Future<void> deleteAllStudents() async {
    _ensureInitialized();
    _students.clear();
  }

  @override
  Future<int> deleteStudentsByMajor(String major) async {
    _ensureInitialized();
    int initialCount = _students.length;
    _students.removeWhere((s) => s.major == major);
    return initialCount - _students.length;
  }
}
