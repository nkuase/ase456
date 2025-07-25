import 'examples/pocketbase_examples.dart';
import 'examples/database_abstraction_demo.dart';
import 'models/student.dart';
import 'services/pocketbase_student_service.dart';

/// Main entry point for PocketBase Student Example
///
/// This example demonstrates:
/// 1. PocketBase initialization
/// 2. CRUD operations with PocketBase
/// 3. Real-time data streaming (simulated)
/// 4. Query operations
/// 5. Advanced PocketBase features
/// 6. Database abstraction with top-level functions
///
/// Note: Before running this example, you need to:
/// 1. Install and run PocketBase server
/// 2. Start the server with: ./pocketbase serve
/// 3. Access admin panel at http://127.0.0.1:8090/_/
/// 4. Create a users collection (optional for auth)
void main() async {
  print('📦 PocketBase Student Management Example');
  print('========================================\n');

  try {
    // Initialize PocketBase
    print('🚀 Initializing PocketBase...');
    await PocketBaseStudentService.initialize();
    print('✅ PocketBase initialized successfully\n');

    // Demo menu
    await showMenu();
  } catch (e) {
    print('❌ PocketBase initialization failed: $e');
    print('\n📝 To fix this:');
    print('1. Download PocketBase from https://pocketbase.io/');
    print('2. Extract the executable');
    print('3. Run: ./pocketbase serve');
    print('4. Access admin panel at http://127.0.0.1:8090/_/');
    print('5. Set up collections and auth if needed');

    // Run offline examples instead
    print('\n🔄 Running offline examples with mock data...');
    await runOfflineExamples();
  }
}

/// Interactive menu for running different examples
Future<void> showMenu() async {
  print('📋 Available Examples:');
  print('1. Basic CRUD Operations');
  print('2. Query Operations');
  print('3. Real-time Streaming (Simulated)');
  print('4. Advanced Operations');
  print('5. Error Handling');
  print('6. PocketBase Setup');
  print('7. Database Abstraction Demo');
  print('8. Run All Examples');
  print('9. Clean Database');
  print('0. Exit');

  // For demo purposes, run all examples
  print('\n🎯 Running all examples...\n');
  await PocketBaseExamples.runAllExamples();

  // Demonstrate database abstraction with top-level functions
  print('\n🔀 Running Database Abstraction Demo...\n');
  await demonstrateDatabaseSwitching();

  // Additional demos to show the power of abstraction
  print('\n💼 Running Business Logic Demo...\n');
  try {
    var mockDb = createMockDatabase();
    await demonstrateBusinessLogic(mockDb);
  } catch (e) {
    print('⚠️ Business logic demo failed: $e');
  }
}

/// Run examples with mock data when PocketBase is not available
Future<void> runOfflineExamples() async {
  print('\n📚 Mock Student Examples (Offline Mode)');
  print('======================================\n');

  // Create mock students
  List<Student> mockStudents = [
    Student(
      id: '1',
      name: 'Alice Johnson',
      age: 20,
      major: 'Computer Science',
      createdAt: DateTime.now(),
    ),
    Student(
      id: '2',
      name: 'Bob Smith',
      age: 22,
      major: 'Mathematics',
      createdAt: DateTime.now(),
    ),
    Student(
      id: '3',
      name: 'Charlie Brown',
      age: 19,
      major: 'Physics',
      createdAt: DateTime.now(),
    ),
  ];

  print('📖 Mock Students:');
  for (Student student in mockStudents) {
    print('  $student');
  }

  print('\n🔄 Demonstrating model methods:');

  // Demonstrate toMap
  print('\n📄 Student as Map:');
  print('  ${mockStudents.first.toMap()}');

  // Demonstrate copyWith
  print('\n✏️ Copying student with new age:');
  Student updatedAlice = mockStudents.first.copyWith(age: 21);
  print('  Original: ${mockStudents.first}');
  print('  Updated:  $updatedAlice');

  // Demonstrate filtering (simulating queries)
  print('\n🔍 Students in Computer Science:');
  List<Student> csStudents = mockStudents
      .where((student) => student.major == 'Computer Science')
      .toList();
  for (Student student in csStudents) {
    print('  $student');
  }

  print('\n📊 Students aged 20 or older:');
  List<Student> adults =
      mockStudents.where((student) => student.age >= 20).toList();
  for (Student student in adults) {
    print('  $student');
  }

  // Demonstrate database abstraction in offline mode
  print('\n⚙️ Running offline database abstraction demo...');
  try {
    var mockDb = createMockDatabase();
    await runDatabaseDemo(mockDb, 'Mock (Offline)');

    print('\n💼 Demonstrating database-agnostic business logic...');
    await demonstrateBusinessLogic(mockDb);
  } catch (e) {
    print('❌ Offline database demo failed: $e');
  }

  print('\n✅ Offline examples completed!');
  print('\n💡 To enable PocketBase features:');
  print('   1. Download PocketBase from https://pocketbase.io/');
  print('   2. Run: ./pocketbase serve');
  print('   3. Access admin panel at http://127.0.0.1:8090/_/');
}

/// Utility function to demonstrate individual operations
Future<void> demonstrateOperation(String operation) async {
  switch (operation.toLowerCase()) {
    case 'create':
      await _demonstrateCreate();
      break;
    case 'read':
      await _demonstrateRead();
      break;
    case 'update':
      await _demonstrateUpdate();
      break;
    case 'delete':
      await _demonstrateDelete();
      break;
    default:
      print('Unknown operation: $operation');
  }
}

Future<void> _demonstrateCreate() async {
  print('\n📝 CREATE Operation Demo');
  print('========================');

  Student newStudent = Student(
    id: '',
    name: 'Demo Student',
    age: 21,
    major: 'Demo Major',
    createdAt: DateTime.now(),
  );

  try {
    String id = await PocketBaseStudentService.createStudent(newStudent);
    print('✅ Created student with ID: $id');
  } catch (e) {
    print('❌ Create failed: $e');
  }
}

Future<void> _demonstrateRead() async {
  print('\n📖 READ Operation Demo');
  print('======================');

  try {
    List<Student> students = await PocketBaseStudentService.getAllStudents();
    print('✅ Retrieved ${students.length} students');
    for (Student student in students.take(3)) {
      print('  $student');
    }
  } catch (e) {
    print('❌ Read failed: $e');
  }
}

Future<void> _demonstrateUpdate() async {
  print('\n✏️ UPDATE Operation Demo');
  print('========================');

  try {
    List<Student> students = await PocketBaseStudentService.getAllStudents();
    if (students.isNotEmpty) {
      String id = students.first.id;
      await PocketBaseStudentService.updateStudent(id, {'age': 25});
      print('✅ Updated student $id');
    } else {
      print('⚠️ No students to update');
    }
  } catch (e) {
    print('❌ Update failed: $e');
  }
}

Future<void> _demonstrateDelete() async {
  print('\n🗑️ DELETE Operation Demo');
  print('========================');

  try {
    List<Student> students = await PocketBaseStudentService.getAllStudents();
    if (students.isNotEmpty) {
      String id = students.last.id;
      await PocketBaseStudentService.deleteStudent(id);
      print('✅ Deleted student $id');
    } else {
      print('⚠️ No students to delete');
    }
  } catch (e) {
    print('❌ Delete failed: $e');
  }
}
