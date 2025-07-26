import '../database/firebase/lib/services/database_service.dart' as firebase_service;
import '../database/firebase/lib/services/firebase_database_adapter.dart';
import '../database/firebase/lib/models/student.dart' as firebase_student;

import '../database/pocketbase/lib/services/database_service.dart' as pocketbase_service;
import '../database/pocketbase/lib/services/pocketbase_database_adapter.dart';
import '../database/pocketbase/lib/models/student.dart' as pocketbase_student;

/// Combined Database Demo
/// Shows how to use both Firebase and PocketBase with the same interface
/// This demonstrates true database abstraction
void main() async {
  print('🔀 Combined Database Abstraction Demo');
  print('====================================');
  
  // Example 1: Using Firebase
  print('\n📊 Testing with Firebase...');
  try {
    firebase_service.DatabaseService firebaseDb = FirebaseDatabaseAdapter();
    await demonstrateDatabaseOperations(firebaseDb, 'Firebase');
  } catch (e) {
    print('❌ Firebase demo failed: $e');
    print('💡 Make sure Firebase is configured properly');
  }
  
  // Example 2: Using PocketBase
  print('\n📦 Testing with PocketBase...');
  try {
    pocketbase_service.DatabaseService pocketbaseDb = PocketBaseDatabaseAdapter();
    await demonstratePocketBaseOperations(pocketbaseDb, 'PocketBase');
  } catch (e) {
    print('❌ PocketBase demo failed: $e');
    print('💡 Make sure PocketBase server is running at http://127.0.0.1:8090');
  }
  
  print('\n✅ Combined database demo completed!');
  print('\n🎯 Key Takeaway:');
  print('   The same application logic works with both databases!');
  print('   You can switch from Firebase to PocketBase (or vice versa)');
  print('   without changing your business logic code.');
}

/// Demonstrate database operations using Firebase interface
Future<void> demonstrateDatabaseOperations(
    firebase_service.DatabaseService db, String dbName) async {
  
  print('   Initializing $dbName...');
  await db.initialize();
  
  // Create a student
  firebase_student.Student student = firebase_student.Student(
    id: '',
    name: 'Alice Johnson',
    age: 20,
    major: 'Computer Science',
    createdAt: DateTime.now(),
  );
  
  String studentId = await db.createStudent(student);
  print('   ✅ Created student in $dbName: $studentId');
  
  // Read students
  List<firebase_student.Student> students = await db.getAllStudents();
  print('   📖 Retrieved ${students.length} students from $dbName');
  
  // Update student
  await db.updateStudent(studentId, {'age': 21});
  print('   ✏️ Updated student in $dbName');
  
  // Clean up
  await db.deleteStudent(studentId);
  print('   🗑️ Deleted student from $dbName');
}

/// Demonstrate database operations using PocketBase interface
Future<void> demonstratePocketBaseOperations(
    pocketbase_service.DatabaseService db, String dbName) async {
  
  print('   Initializing $dbName...');
  await db.initialize();
  
  // Create a student
  pocketbase_student.Student student = pocketbase_student.Student(
    id: '',
    name: 'Bob Smith',
    age: 22,
    major: 'Mathematics',
    createdAt: DateTime.now(),
  );
  
  String studentId = await db.createStudent(student);
  print('   ✅ Created student in $dbName: $studentId');
  
  // Read students
  List<pocketbase_student.Student> students = await db.getAllStudents();
  print('   📖 Retrieved ${students.length} students from $dbName');
  
  // Update student
  await db.updateStudent(studentId, {'age': 23});
  print('   ✏️ Updated student in $dbName');
  
  // Clean up
  await db.deleteStudent(studentId);
  print('   🗑️ Deleted student from $dbName');
}
