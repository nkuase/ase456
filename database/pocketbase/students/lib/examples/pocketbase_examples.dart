import '../models/student.dart';
import '../services/pocketbase_student_service.dart';

/// PocketBase Examples
/// Demonstrates practical usage of PocketBase CRUD operations
/// These examples show how to use the PocketBaseStudentService
class PocketBaseExamples {
  
  /// Example 1: Basic CRUD Operations
  static Future<void> basicCrudExample() async {
    print('\n📚 === Basic CRUD Example ===');
    
    try {
      // 1. CREATE - Add new students
      print('\n1️⃣ Creating students...');
      
      Student alice = Student(
        id: '', // Will be auto-generated
        name: 'Alice Johnson',
        age: 20,
        major: 'Computer Science',
        createdAt: DateTime.now(),
      );
      
      Student bob = Student(
        id: '', // Will be auto-generated
        name: 'Bob Smith',
        age: 22,
        major: 'Mathematics',
        createdAt: DateTime.now(),
      );
      
      String aliceId = await PocketBaseStudentService.createStudent(alice);
      String bobId = await PocketBaseStudentService.createStudent(bob);
      
      // 2. READ - Get all students
      print('\n2️⃣ Reading all students...');
      List<Student> allStudents = await PocketBaseStudentService.getAllStudents();
      for (Student student in allStudents) {
        print('  📖 $student');
      }
      
      // 3. READ - Get specific student
      print('\n3️⃣ Reading specific student...');
      Student? foundAlice = await PocketBaseStudentService.getStudentById(aliceId);
      if (foundAlice != null) {
        print('  📖 Found: $foundAlice');
      }
      
      // 4. UPDATE - Update student age
      print('\n4️⃣ Updating student...');
      await PocketBaseStudentService.updateStudent(aliceId, {
        'age': 21,
        'major': 'Data Science'
      });
      
      // Verify update
      Student? updatedAlice = await PocketBaseStudentService.getStudentById(aliceId);
      if (updatedAlice != null) {
        print('  📝 Updated: $updatedAlice');
      }
      
      // 5. DELETE - Remove one student
      print('\n5️⃣ Deleting student...');
      await PocketBaseStudentService.deleteStudent(bobId);
      
      // Verify deletion
      List<Student> remainingStudents = await PocketBaseStudentService.getAllStudents();
      print('  🗑️ Remaining students: ${remainingStudents.length}');
      
    } catch (e) {
      print('❌ Basic CRUD Example failed: $e');
    }
  }
  
  /// Example 2: Query Operations
  static Future<void> queryExample() async {
    print('\n🔍 === Query Example ===');
    
    try {
      // Create sample data
      List<Student> sampleStudents = [
        Student(
          id: '',
          name: 'Charlie Brown',
          age: 19,
          major: 'Computer Science',
          createdAt: DateTime.now(),
        ),
        Student(
          id: '',
          name: 'Diana Prince',
          age: 23,
          major: 'Computer Science',
          createdAt: DateTime.now(),
        ),
        Student(
          id: '',
          name: 'Eve Wilson',
          age: 20,
          major: 'Mathematics',
          createdAt: DateTime.now(),
        ),
        Student(
          id: '',
          name: 'Frank Miller',
          age: 24,
          major: 'Physics',
          createdAt: DateTime.now(),
        ),
      ];
      
      // Create multiple students using batch
      await PocketBaseStudentService.createMultipleStudents(sampleStudents);
      
      // Query by major
      print('\n1️⃣ Students in Computer Science:');
      List<Student> csStudents = await PocketBaseStudentService.getStudentsByMajor('Computer Science');
      for (Student student in csStudents) {
        print('  👨‍💻 $student');
      }
      
      // Query by age range
      print('\n2️⃣ Students aged 20-22:');
      List<Student> youngStudents = await PocketBaseStudentService.getStudentsByAgeRange(20, 22);
      for (Student student in youngStudents) {
        print('  🎓 $student');
      }
      
      // Search by name
      print('\n3️⃣ Students with names containing "Ch":');
      List<Student> charlieStudents = await PocketBaseStudentService.searchStudentsByName('Ch');
      for (Student student in charlieStudents) {
        print('  🔎 $student');
      }
      
      // Count students
      int totalStudents = await PocketBaseStudentService.getStudentCount();
      print('\n📊 Total students in database: $totalStudents');
      
    } catch (e) {
      print('❌ Query Example failed: $e');
    }
  }
  
  /// Example 3: Real-time Data Streaming (Simulated)
  static Future<void> realtimeExample() async {
    print('\n📡 === Real-time Streaming Example ===');
    
    try {
      print('Setting up real-time listener...');
      
      // Set up real-time listener (simulated)
      var subscription = PocketBaseStudentService.getStudentsStream().listen(
        (students) {
          print('\n📡 Real-time update received:');
          print('   Total students: ${students.length}');
          for (Student student in students.take(3)) { // Show first 3
            print('   📖 $student');
          }
          if (students.length > 3) {
            print('   ... and ${students.length - 3} more');
          }
        },
        onError: (error) {
          print('❌ Real-time listener error: $error');
        },
      );
      
      // Simulate some changes
      print('\n🔄 Making changes to trigger real-time updates...');
      
      // Add a new student
      await Future.delayed(Duration(seconds: 1));
      Student newStudent = Student(
        id: '',
        name: 'Grace Hopper',
        age: 25,
        major: 'Computer Science',
        createdAt: DateTime.now(),
      );
      String graceId = await PocketBaseStudentService.createStudent(newStudent);
      
      // Update the student
      await Future.delayed(Duration(seconds: 2));
      await PocketBaseStudentService.updateStudent(graceId, {
        'age': 26,
      });
      
      // Wait a bit to see real-time updates
      await Future.delayed(Duration(seconds: 8));
      
      // Cancel subscription
      await subscription.cancel();
      print('\n🛑 Real-time listener cancelled');
      
    } catch (e) {
      print('❌ Real-time Example failed: $e');
    }
  }
  
  /// Example 4: Advanced Operations
  static Future<void> advancedExample() async {
    print('\n⚡ === Advanced Operations Example ===');
    
    try {
      // Get current student count
      int initialCount = await PocketBaseStudentService.getStudentCount();
      print('Initial student count: $initialCount');
      
      // Batch operation - create multiple students
      print('\n1️⃣ Batch creating students...');
      List<Student> batchStudents = [
        Student(
          id: '',
          name: 'John Doe',
          age: 21,
          major: 'Engineering',
          createdAt: DateTime.now(),
        ),
        Student(
          id: '',
          name: 'Jane Doe',
          age: 22,
          major: 'Engineering',
          createdAt: DateTime.now(),
        ),
        Student(
          id: '',
          name: 'Mike Johnson',
          age: 20,
          major: 'Business',
          createdAt: DateTime.now(),
        ),
      ];
      
      await PocketBaseStudentService.createMultipleStudents(batchStudents);
      
      // Verify batch creation
      int afterBatchCount = await PocketBaseStudentService.getStudentCount();
      print('After batch: $afterBatchCount students (+${afterBatchCount - initialCount})');
      
      // Transaction example - transfer student to new major
      print('\n2️⃣ Transaction example...');
      List<Student> engineeringStudents = await PocketBaseStudentService.getStudentsByMajor('Engineering');
      if (engineeringStudents.isNotEmpty) {
        String studentId = engineeringStudents.first.id;
        await PocketBaseStudentService.transferStudentMajor(studentId, 'Computer Engineering');
        print('Transferred student to Computer Engineering');
      }
      
      // Increment age example
      print('\n3️⃣ Increment age example...');
      List<Student> allStudents = await PocketBaseStudentService.getAllStudents();
      if (allStudents.isNotEmpty) {
        String studentId = allStudents.first.id;
        await PocketBaseStudentService.incrementStudentAge(studentId);
        print('Incremented age for student: ${allStudents.first.name}');
      }
      
      // Clean up - delete students by major
      print('\n4️⃣ Cleanup - deleting Business students...');
      int deletedCount = await PocketBaseStudentService.deleteStudentsByMajor('Business');
      print('Deleted $deletedCount Business students');
      
      // Final count
      int finalCount = await PocketBaseStudentService.getStudentCount();
      print('\nFinal student count: $finalCount');
      
    } catch (e) {
      print('❌ Advanced Example failed: $e');
    }
  }
  
  /// Example 5: Error Handling
  static Future<void> errorHandlingExample() async {
    print('\n⚠️ === Error Handling Example ===');
    
    try {
      // Try to get a non-existent student
      print('1️⃣ Attempting to get non-existent student...');
      Student? nonExistent = await PocketBaseStudentService.getStudentById('non-existent-id');
      if (nonExistent == null) {
        print('✅ Correctly handled: Student not found');
      }
      
      // Try to update a non-existent student
      print('\n2️⃣ Attempting to update non-existent student...');
      try {
        await PocketBaseStudentService.updateStudent('non-existent-id', {'age': 25});
      } catch (e) {
        print('✅ Correctly caught update error: $e');
      }
      
      // Try to delete a non-existent student
      print('\n3️⃣ Attempting to delete non-existent student...');
      try {
        await PocketBaseStudentService.deleteStudent('non-existent-id');
      } catch (e) {
        print('✅ Correctly caught delete error: $e');
      }
      
    } catch (e) {
      print('❌ Error Handling Example failed: $e');
    }
  }
  
  /// Example 6: PocketBase Setup (Collection Creation)
  static Future<void> setupExample() async {
    print('\n🛠️ === PocketBase Setup Example ===');
    
    try {
      print('Setting up students collection...');
      await PocketBaseStudentService.setupCollection();
      print('✅ Collection setup completed');
      
    } catch (e) {
      print('❌ Setup Example failed: $e');
    }
  }
  
  /// Run all examples
  static Future<void> runAllExamples() async {
    print('🚀 Starting PocketBase Examples...\n');
    
    // Initialize service
    await PocketBaseStudentService.initialize();
    
    // Setup collection (this might fail if already exists, which is fine)
    await setupExample();
    
    // Run examples
    await basicCrudExample();
    await queryExample();
    await realtimeExample();
    await advancedExample();
    await errorHandlingExample();
    
    print('\n✅ All PocketBase examples completed!');
  }
  
  /// Clean up database - remove all test data
  static Future<void> cleanupDatabase() async {
    print('\n🧹 Cleaning up database...');
    try {
      await PocketBaseStudentService.deleteAllStudents();
      print('✅ Database cleanup completed');
    } catch (e) {
      print('❌ Cleanup failed: $e');
    }
  }
}
