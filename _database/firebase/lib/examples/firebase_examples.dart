import '../models/student.dart';
import '../services/student_service.dart';
import '../services/secure_student_service.dart';
import '../services/firebase_service.dart';
import '../migration/database_migration.dart';

/// Comprehensive examples demonstrating Firebase features
class FirebaseExamples {
  final StudentService _studentService = StudentService();
  final SecureStudentService _secureStudentService = SecureStudentService();
  final FirebaseService _firebaseService = FirebaseService();

  /// Example 1: Basic CRUD Operations
  Future<void> basicCrudExample() async {
    print('📚 Example 1: Basic CRUD Operations');
    print('=' * 50);

    try {
      // CREATE
      print('1. Creating a new student...');
      final student = Student(
        name: 'Alice Johnson',
        age: 20,
        major: 'Computer Science',
      );

      final createResult = await _studentService.create(student);
      String? studentId;

      createResult.fold(
        onSuccess: (id) {
          studentId = id;
          print('✅ Student created with ID: $id');
        },
        onError: (error) {
          print('❌ Creation failed: $error');
          return;
        },
      );

      if (studentId == null) return;

      // READ
      print('\n2. Reading the student...');
      final readResult = await _studentService.read(studentId!);

      readResult.fold(
        onSuccess: (student) {
          if (student != null) {
            print('✅ Student found: ${student.name}, Age: ${student.age}');
          } else {
            print('❌ Student not found');
          }
        },
        onError: (error) {
          print('❌ Read failed: $error');
        },
      );

      // UPDATE
      print('\n3. Updating the student...');
      final updatedStudent = student.copyWith(
        age: 21,
        major: 'Computer Engineering',
      );

      final updateResult = await _studentService.update(studentId!, updatedStudent);

      updateResult.fold(
        onSuccess: (_) {
          print('✅ Student updated successfully');
        },
        onError: (error) {
          print('❌ Update failed: $error');
        },
      );

      // READ AGAIN to verify update
      print('\n4. Verifying the update...');
      final verifyResult = await _studentService.read(studentId!);

      verifyResult.fold(
        onSuccess: (student) {
          if (student != null) {
            print('✅ Updated student: ${student.name}, Age: ${student.age}, Major: ${student.major}');
          }
        },
        onError: (error) {
          print('❌ Verification failed: $error');
        },
      );

      // DELETE
      print('\n5. Deleting the student...');
      final deleteResult = await _studentService.delete(studentId!);

      deleteResult.fold(
        onSuccess: (_) {
          print('✅ Student deleted successfully');
        },
        onError: (error) {
          print('❌ Delete failed: $error');
        },
      );

      print('\n✅ Basic CRUD example completed!\n');
    } catch (e) {
      print('❌ Example failed with error: $e\n');
    }
  }

  /// Example 2: Batch Operations
  Future<void> batchOperationsExample() async {
    print('📚 Example 2: Batch Operations');
    print('=' * 50);

    try {
      // Create multiple students at once
      final students = [
        Student(name: 'Alice Johnson', age: 20, major: 'Computer Science'),
        Student(name: 'Bob Smith', age: 22, major: 'Mathematics'),
        Student(name: 'Carol Davis', age: 21, major: 'Physics'),
        Student(name: 'David Wilson', age: 23, major: 'Computer Engineering'),
        Student(name: 'Eva Brown', age: 19, major: 'Data Science'),
      ];

      print('Creating ${students.length} students in batch...');
      final batchResult = await _studentService.createBatch(students);

      batchResult.fold(
        onSuccess: (ids) {
          print('✅ Created ${ids.length} students');
          print('   IDs: ${ids.join(', ')}');
        },
        onError: (error) {
          print('❌ Batch creation failed: $error');
        },
      );

      print('\n✅ Batch operations example completed!\n');
    } catch (e) {
      print('❌ Example failed with error: $e\n');
    }
  }

  /// Example 3: Advanced Queries
  Future<void> advancedQueriesExample() async {
    print('📚 Example 3: Advanced Queries');
    print('=' * 50);

    try {
      // Query by major
      print('1. Finding Computer Science students...');
      final csResult = await _studentService.getStudentsByMajor('Computer Science');

      csResult.fold(
        onSuccess: (students) {
          print('✅ Found ${students.length} Computer Science students');
          for (final student in students) {
            print('   • ${student.name} (Age: ${student.age})');
          }
        },
        onError: (error) {
          print('❌ Query failed: $error');
        },
      );

      // Query by age range
      print('\n2. Finding students aged 20-22...');
      final ageResult = await _studentService.getStudentsByAgeRange(20, 22);

      ageResult.fold(
        onSuccess: (students) {
          print('✅ Found ${students.length} students aged 20-22');
          for (final student in students) {
            print('   • ${student.name} (Age: ${student.age}, Major: ${student.major})');
          }
        },
        onError: (error) {
          print('❌ Age query failed: $error');
        },
      );

      // Complex query (major and age range)
      print('\n3. Finding Computer Science students aged 20-22...');
      final complexResult = await _studentService.getByMajorAndAgeRange('Computer Science', 20, 22);

      print('✅ Found ${complexResult.length} CS students aged 20-22');
      for (final student in complexResult) {
        print('   • ${student.name} (Age: ${student.age})');
      }

      // Get newest students
      print('\n4. Getting newest students...');
      final newestResult = await _studentService.getNewestStudents(limit: 3);

      newestResult.fold(
        onSuccess: (students) {
          print('✅ Found ${students.length} newest students');
          for (final student in students) {
            print('   • ${student.name} (Created: ${student.createdAt})');
          }
        },
        onError: (error) {
          print('❌ Newest query failed: $error');
        },
      );

      print('\n✅ Advanced queries example completed!\n');
    } catch (e) {
      print('❌ Example failed with error: $e\n');
    }
  }

  /// Example 4: Real-time Streams
  Future<void> realTimeStreamsExample() async {
    print('📚 Example 4: Real-time Streams');
    print('=' * 50);

    try {
      print('Setting up real-time stream (will run for 10 seconds)...');

      // Listen to all students
      final subscription = _studentService.streamAll(
        orderBy: 'createdAt',
        descending: true,
      ).listen((students) {
        print('📡 Real-time update: ${students.length} students');
        for (final student in students.take(3)) {
          print('   • ${student.name} (${student.major})');
        }
        if (students.length > 3) {
          print('   ... and ${students.length - 3} more');
        }
      });

      // Wait for 10 seconds to demonstrate real-time updates
      await Future.delayed(const Duration(seconds: 10));

      // Cancel subscription
      await subscription.cancel();
      print('✅ Real-time stream example completed!\n');
    } catch (e) {
      print('❌ Example failed with error: $e\n');
    }
  }

  /// Example 5: Statistics and Analytics
  Future<void> statisticsExample() async {
    print('📚 Example 5: Statistics and Analytics');
    print('=' * 50);

    try {
      // Get student statistics
      print('1. Getting student statistics...');
      final stats = await _studentService.getStudentStatistics();

      if (stats.containsKey('error')) {
        print('❌ Statistics failed: ${stats['error']}');
        return;
      }

      print('✅ Student Statistics:');
      print('   Total Students: ${stats['totalStudents']}');
      print('   Average Age: ${(stats['averageAge'] as double).toStringAsFixed(2)}');

      if (stats['majorCounts'] != null) {
        print('   Students by Major:');
        final majorCounts = stats['majorCounts'] as Map<String, int>;
        for (final entry in majorCounts.entries) {
          print('     • ${entry.key}: ${entry.value}');
        }
      }

      if (stats['ageDistribution'] != null) {
        print('   Age Distribution:');
        final ageDistribution = stats['ageDistribution'] as Map<String, int>;
        for (final entry in ageDistribution.entries) {
          print('     • ${entry.key}: ${entry.value}');
        }
      }

      // Get average age
      print('\n2. Getting average age...');
      final avgAge = await _studentService.getAverageAge();
      print('✅ Average Age: ${avgAge.toStringAsFixed(2)}');

      // Get student count by major
      print('\n3. Getting student count by major...');
      final majorCounts = await _studentService.getStudentCountByMajor();
      print('✅ Student Count by Major:');
      for (final entry in majorCounts.entries) {
        print('   • ${entry.key}: ${entry.value}');
      }

      print('\n✅ Statistics example completed!\n');
    } catch (e) {
      print('❌ Example failed with error: $e\n');
    }
  }

  /// Example 6: Secure Operations with Validation
  Future<void> secureOperationsExample() async {
    print('📚 Example 6: Secure Operations with Validation');
    print('=' * 50);

    try {
      print('1. Attempting to create student with valid data...');
      final validResult = await _secureStudentService.createFromFormData(
        name: 'John Doe',
        ageText: '20',
        major: 'Computer Science',
      );

      validResult.fold(
        onSuccess: (id) {
          print('✅ Valid student created with ID: $id');
        },
        onError: (error) {
          print('❌ Unexpected error: $error');
        },
      );

      print('\n2. Attempting to create student with invalid data...');
      final invalidResult = await _secureStudentService.createFromFormData(
        name: '', // Invalid - empty name
        ageText: 'abc', // Invalid - not a number
        major: 'Invalid Major', // Invalid - not in list
      );

      invalidResult.fold(
        onSuccess: (id) {
          print('❌ Unexpected success: $id');
        },
        onError: (error) {
          print('✅ Validation correctly caught errors: $error');
        },
      );

      print('\n3. Testing bulk validation...');
      final mixedStudents = [
        Student(name: 'Valid Student', age: 20, major: 'Computer Science'), // Valid
        Student(name: '', age: 20, major: 'Computer Science'), // Invalid name
        Student(name: 'Another Valid', age: 21, major: 'Mathematics'), // Valid
        Student(name: 'Invalid Age', age: 15, major: 'Physics'), // Invalid age
      ];

      final bulkResult = await _secureStudentService.bulkCreateSecurely(mixedStudents);

      bulkResult.fold(
        onSuccess: (ids) {
          print('❌ Unexpected success with invalid data: $ids');
        },
        onError: (error) {
          print('✅ Bulk validation correctly caught errors: $error');
        },
      );

      print('\n✅ Secure operations example completed!\n');
    } catch (e) {
      print('❌ Example failed with error: $e\n');
    }
  }

  /// Example 7: Database Abstraction
  Future<void> databaseAbstractionExample() async {
    print('📚 Example 7: Database Abstraction');
    print('=' * 50);

    try {
      print('Using Firebase through database abstraction layer...');

      // Create using abstraction
      final studentData = {
        'name': 'Abstraction Test Student',
        'age': 25,
        'major': 'Computer Science',
      };

      final id = await _firebaseService.create(studentData);
      print('✅ Created student through abstraction: $id');

      // Read using abstraction
      final readData = await _firebaseService.read(id);
      if (readData != null) {
        print('✅ Read student: ${readData['name']} (Age: ${readData['age']})');
      }

      // Update using abstraction
      final updateData = {
        'name': 'Updated Abstraction Student',
        'age': 26,
        'major': 'Data Science',
      };

      final updateSuccess = await _firebaseService.update(id, updateData);
      print('✅ Update ${updateSuccess ? 'succeeded' : 'failed'}');

      // Delete using abstraction
      final deleteSuccess = await _firebaseService.delete(id);
      print('✅ Delete ${deleteSuccess ? 'succeeded' : 'failed'}');

      // Print implementation info
      print('\nDatabase Implementation Info:');
      print('  Name: ${_firebaseService.implementationName}');
      print('  Real-time support: ${_firebaseService.supportsRealTime}');
      print('  Transaction support: ${_firebaseService.supportsTransactions}');
      print('  Offline support: ${_firebaseService.supportsOffline}');

      print('\n✅ Database abstraction example completed!\n');
    } catch (e) {
      print('❌ Example failed with error: $e\n');
    }
  }

  /// Example 8: Migration Simulation
  Future<void> migrationExample() async {
    print('📚 Example 8: Migration Simulation');
    print('=' * 50);

    try {
      print('Simulating database migration...');

      // Create migration utilities
      final firebaseToSqlite = FirebaseToSQLiteMigration();
      final syncUtility = DatabaseSyncUtility();

      // Simulate backup
      print('\n1. Creating backup...');
      await firebaseToSqlite.backupToJson();

      // Simulate export (this would export to SQLite in real scenario)
      print('\n2. Simulating export to SQLite...');
      await firebaseToSqlite.exportFromFirebase();

      // Simulate sync (this would sync between databases in real scenario)
      print('\n3. Simulating bidirectional sync...');
      await syncUtility.syncData();

      // Clean up
      syncUtility.dispose();

      print('\n✅ Migration example completed!\n');
    } catch (e) {
      print('❌ Example failed with error: $e\n');
    }
  }

  /// Run all examples
  Future<void> runAllExamples() async {
    print('🚀 Running all Firebase examples...');
    print('=' * 70);

    await basicCrudExample();
    await batchOperationsExample();
    await advancedQueriesExample();
    await realTimeStreamsExample();
    await statisticsExample();
    await secureOperationsExample();
    await databaseAbstractionExample();
    await migrationExample();

    print('🎉 All examples completed successfully!');
    print('=' * 70);
  }

  /// Demo for classroom presentation
  Future<void> classroomDemo() async {
    print('🎓 Firebase Classroom Demo');
    print('=' * 50);

    try {
      print('Welcome to Firebase CRUD demonstration!');
      print('This demo shows real-time database operations.\n');

      // Step 1: Create sample students
      print('📝 Step 1: Creating sample students...');
      final sampleStudents = [
        Student(name: 'Alice Johnson', age: 20, major: 'Computer Science'),
        Student(name: 'Bob Smith', age: 22, major: 'Mathematics'),
        Student(name: 'Carol Davis', age: 21, major: 'Physics'),
      ];

      final batchResult = await _studentService.createBatch(sampleStudents);
      List<String> createdIds = [];

      batchResult.fold(
        onSuccess: (ids) {
          createdIds = ids;
          print('✅ Created ${ids.length} students');
        },
        onError: (error) {
          print('❌ Failed to create students: $error');
          return;
        },
      );

      // Step 2: Query and display
      print('\n📊 Step 2: Querying all students...');
      final allStudents = await _studentService.readAll(orderBy: 'name');

      allStudents.fold(
        onSuccess: (students) {
          print('✅ Found ${students.length} students:');
          for (final student in students) {
            print('   • ${student.name} (${student.major}, Age: ${student.age})');
          }
        },
        onError: (error) {
          print('❌ Query failed: $error');
        },
      );

      // Step 3: Update a student
      if (createdIds.isNotEmpty) {
        print('\n✏️  Step 3: Updating a student...');
        final updateResult = await _studentService.updateFields(createdIds.first, {
          'age': 23,
          'major': 'Computer Engineering',
        });

        updateResult.fold(
          onSuccess: (_) {
            print('✅ Student updated successfully');
          },
          onError: (error) {
            print('❌ Update failed: $error');
          },
        );
      }

      // Step 4: Show statistics
      print('\n📈 Step 4: Student statistics...');
      final stats = await _studentService.getStudentStatistics();

      if (!stats.containsKey('error')) {
        print('✅ Statistics:');
        print('   Total: ${stats['totalStudents']}');
        print('   Average Age: ${(stats['averageAge'] as double).toStringAsFixed(1)}');
        
        if (stats['majorCounts'] != null) {
          final majorCounts = stats['majorCounts'] as Map<String, int>;
          print('   By Major: ${majorCounts.entries.map((e) => '${e.key}: ${e.value}').join(', ')}');
        }
      }

      // Step 5: Clean up (optional)
      print('\n🧹 Step 5: Cleaning up demo data...');
      for (final id in createdIds) {
        await _studentService.delete(id);
      }
      print('✅ Demo data cleaned up');

      print('\n🎉 Classroom demo completed!');
      print('Key concepts demonstrated:');
      print('• CRUD operations with Firebase');
      print('• Real-time data synchronization');
      print('• Error handling with Result pattern');
      print('• Batch operations for efficiency');
      print('• Data validation and security');
      print('• Statistics and analytics');

    } catch (e) {
      print('❌ Demo failed: $e');
    }
  }
}

/// Simple CLI for running examples
void main() async {
  print('🔥 Firebase Examples CLI');
  print('Choose an example to run:');
  print('1. Basic CRUD Operations');
  print('2. Batch Operations');
  print('3. Advanced Queries');
  print('4. Real-time Streams');
  print('5. Statistics');
  print('6. Secure Operations');
  print('7. Database Abstraction');
  print('8. Migration Simulation');
  print('9. Run All Examples');
  print('10. Classroom Demo');

  // For this example, we'll run the classroom demo
  // In a real CLI, you would get user input
  final examples = FirebaseExamples();
  await examples.classroomDemo();
}
