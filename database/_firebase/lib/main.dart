import 'package:firebase_core/firebase_core.dart';
import 'examples/firebase_examples.dart';
import 'examples/database_abstraction_demo.dart';
import 'models/student.dart';
import 'services/firebase_student_service.dart';

/// Main entry point for Firebase Student Example
/// 
/// This example demonstrates:
/// 1. Firebase initialization
/// 2. CRUD operations with Firestore
/// 3. Real-time data streaming
/// 4. Query operations
/// 5. Advanced Firebase features
/// 
/// Note: Before running this example, you need to:
/// 1. Set up a Firebase project
/// 2. Configure Firebase for your platform
/// 3. Add the firebase_options.dart file
/// 4. Set up Firestore database
void main() async {
  print('🔥 Firebase Student Management Example');
  print('=====================================\n');
  
  try {
    // Initialize Firebase
    print('🚀 Initializing Firebase...');
    await Firebase.initializeApp(
      // Note: You need to add firebase_options.dart from Firebase Console
      // For now, this will use default configuration
    );
    print('✅ Firebase initialized successfully\n');
    
    // Initialize our service
    await FirebaseStudentService.initialize();
    
    // Demo menu
    await showMenu();
    
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
    print('\n📝 To fix this:');
    print('1. Create a Firebase project at https://console.firebase.google.com');
    print('2. Add your app to the project');
    print('3. Download and add firebase_options.dart to your project');
    print('4. Set up Firestore database');
    
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
  print('3. Real-time Streaming');
  print('4. Advanced Operations');
  print('5. Error Handling');
  print('6. Database Abstraction Demo');
  print('7. Run All Examples');
  print('8. Clean Database');
  print('0. Exit');
  
  // For demo purposes, run all examples
  print('\n🎯 Running all examples...\n');
  await FirebaseExamples.runAllExamples();
  
  // Also run database abstraction demo
  print('\n🔀 Running Database Abstraction Demo...\n');
  await DatabaseAbstractionDemo.switchingDatabases();
}

/// Run examples with mock data when Firebase is not available
Future<void> runOfflineExamples() async {
  print('\n📚 Mock Student Examples (Offline Mode)');
  print('=====================================\n');
  
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
  List<Student> adults = mockStudents
      .where((student) => student.age >= 20)
      .toList();
  for (Student student in adults) {
    print('  $student');
  }
  
  print('\n✅ Offline examples completed!');
  print('\n💡 To enable Firebase features:');
  print('   1. Set up Firebase project');
  print('   2. Add firebase_options.dart');
  print('   3. Configure Firestore');
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
    String id = await FirebaseStudentService.createStudent(newStudent);
    print('✅ Created student with ID: $id');
  } catch (e) {
    print('❌ Create failed: $e');
  }
}

Future<void> _demonstrateRead() async {
  print('\n📖 READ Operation Demo');
  print('======================');
  
  try {
    List<Student> students = await FirebaseStudentService.getAllStudents();
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
    List<Student> students = await FirebaseStudentService.getAllStudents();
    if (students.isNotEmpty) {
      String id = students.first.id;
      await FirebaseStudentService.updateStudent(id, {'age': 25});
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
    List<Student> students = await FirebaseStudentService.getAllStudents();
    if (students.isNotEmpty) {
      String id = students.last.id;
      await FirebaseStudentService.deleteStudent(id);
      print('✅ Deleted student $id');
    } else {
      print('⚠️ No students to delete');
    }
  } catch (e) {
    print('❌ Delete failed: $e');
  }
}
