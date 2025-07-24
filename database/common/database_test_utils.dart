import '../common/database_service.dart';
import '../common/student.dart';

/// Test utilities for database services
/// Provides common test scenarios that can be used with any database implementation
class DatabaseTestSuite {
  final DatabaseService db;
  final String dbName;
  
  DatabaseTestSuite(this.db, this.dbName);
  
  /// Run comprehensive test suite
  Future<bool> runAllTests() async {
    print('\n🧪 Running test suite for $dbName');
    print('=' * 50);
    
    try {
      await db.initialize();
      await db.clearAllStudents();
      
      final results = [
        await testCreate(),
        await testRead(),
        await testUpdate(),
        await testDelete(),
        await testQuery(),
        await testSearch(),
        await testBulkOperations(),
      ];
      
      final passed = results.where((r) => r).length;
      final total = results.length;
      
      print('\n📊 Test Results for $dbName:');
      print('   Passed: $passed/$total tests');
      print('   Success Rate: ${(passed / total * 100).toStringAsFixed(1)}%');
      
      if (passed == total) {
        print('   ✅ All tests passed!');
      } else {
        print('   ❌ Some tests failed');
      }
      
      return passed == total;
    } catch (e) {
      print('❌ Test suite failed: $e');
      return false;
    } finally {
      await db.close();
    }
  }
  
  /// Test CREATE operations
  Future<bool> testCreate() async {
    try {
      print('\n🔧 Testing CREATE operations...');
      
      final student = Student(
        id: 'TEST001',
        name: 'Test Student',
        age: 20,
        major: 'Testing',
        createdAt: DateTime.now(),
      );
      
      final id = await db.createStudent(student);
      
      if (id == 'TEST001') {
        print('   ✅ CREATE test passed');
        return true;
      } else {
        print('   ❌ CREATE test failed: Wrong ID returned');
        return false;
      }
    } catch (e) {
      print('   ❌ CREATE test failed: $e');
      return false;
    }
  }
  
  /// Test READ operations
  Future<bool> testRead() async {
    try {
      print('\n📖 Testing READ operations...');
      
      // Test read single
      final student = await db.readStudent('TEST001');
      if (student == null) {
        print('   ❌ READ test failed: Student not found');
        return false;
      }
      
      if (student.name != 'Test Student') {
        print('   ❌ READ test failed: Wrong student data');
        return false;
      }
      
      // Test read all
      final allStudents = await db.readAllStudents();
      if (allStudents.isEmpty) {
        print('   ❌ READ ALL test failed: No students found');
        return false;
      }
      
      print('   ✅ READ tests passed');
      return true;
    } catch (e) {
      print('   ❌ READ test failed: $e');
      return false;
    }
  }
  
  /// Test UPDATE operations
  Future<bool> testUpdate() async {
    try {
      print('\n📝 Testing UPDATE operations...');
      
      final success = await db.updateStudent('TEST001', {
        'age': 21,
        'major': 'Updated Testing'
      });
      
      if (!success) {
        print('   ❌ UPDATE test failed: Update returned false');
        return false;
      }
      
      // Verify update
      final student = await db.readStudent('TEST001');
      if (student?.age != 21 || student?.major != 'Updated Testing') {
        print('   ❌ UPDATE test failed: Data not updated correctly');
        return false;
      }
      
      print('   ✅ UPDATE test passed');
      return true;
    } catch (e) {
      print('   ❌ UPDATE test failed: $e');
      return false;
    }
  }
  
  /// Test DELETE operations
  Future<bool> testDelete() async {
    try {
      print('\n🗑️ Testing DELETE operations...');
      
      // Create another student to delete
      await db.createStudent(Student(
        id: 'DELETE_ME',
        name: 'Delete Test',
        age: 22,
        major: 'Temporary',
        createdAt: DateTime.now(),
      ));
      
      final success = await db.deleteStudent('DELETE_ME');
      if (!success) {
        print('   ❌ DELETE test failed: Delete returned false');
        return false;
      }
      
      // Verify deletion
      final student = await db.readStudent('DELETE_ME');
      if (student != null) {
        print('   ❌ DELETE test failed: Student still exists');
        return false;
      }
      
      print('   ✅ DELETE test passed');
      return true;
    } catch (e) {
      print('   ❌ DELETE test failed: $e');
      return false;
    }
  }
  
  /// Test QUERY operations
  Future<bool> testQuery() async {
    try {
      print('\n🔍 Testing QUERY operations...');
      
      // Add students with different majors
      await db.createStudent(Student(
        id: 'CS001',
        name: 'CS Student 1',
        age: 20,
        major: 'Computer Science',
        createdAt: DateTime.now(),
      ));
      
      await db.createStudent(Student(
        id: 'CS002',
        name: 'CS Student 2',
        age: 21,
        major: 'Computer Science',
        createdAt: DateTime.now(),
      ));
      
      await db.createStudent(Student(
        id: 'MATH001',
        name: 'Math Student',
        age: 19,
        major: 'Mathematics',
        createdAt: DateTime.now(),
      ));
      
      // Query by major
      final csStudents = await db.getStudentsByMajor('Computer Science');
      if (csStudents.length != 2) {
        print('   ❌ QUERY test failed: Expected 2 CS students, got ${csStudents.length}');
        return false;
      }
      
      final mathStudents = await db.getStudentsByMajor('Mathematics');
      if (mathStudents.length != 1) {
        print('   ❌ QUERY test failed: Expected 1 Math student, got ${mathStudents.length}');
        return false;
      }
      
      print('   ✅ QUERY test passed');
      return true;
    } catch (e) {
      print('   ❌ QUERY test failed: $e');
      return false;
    }
  }
  
  /// Test SEARCH operations
  Future<bool> testSearch() async {
    try {
      print('\n🔎 Testing SEARCH operations...');
      
      // Search for students with "CS" in name
      final searchResults = await db.searchStudentsByName('CS');
      if (searchResults.length < 2) {
        print('   ❌ SEARCH test failed: Expected at least 2 results, got ${searchResults.length}');
        return false;
      }
      
      // Search for non-existent name
      final emptyResults = await db.searchStudentsByName('NonExistent');
      if (emptyResults.isNotEmpty) {
        print('   ❌ SEARCH test failed: Expected no results for non-existent name');
        return false;
      }
      
      print('   ✅ SEARCH test passed');
      return true;
    } catch (e) {
      print('   ❌ SEARCH test failed: $e');
      return false;
    }
  }
  
  /// Test bulk operations
  Future<bool> testBulkOperations() async {
    try {
      print('\n📦 Testing BULK operations...');
      
      // Clear all students
      await db.clearAllStudents();
      
      // Verify cleared
      final studentsAfterClear = await db.readAllStudents();
      if (studentsAfterClear.isNotEmpty) {
        print('   ❌ BULK test failed: Students not cleared');
        return false;
      }
      
      // Add multiple students
      for (int i = 1; i <= 5; i++) {
        await db.createStudent(Student(
          id: 'BULK$i',
          name: 'Bulk Student $i',
          age: 18 + i,
          major: i % 2 == 0 ? 'Even Major' : 'Odd Major',
          createdAt: DateTime.now(),
        ));
      }
      
      final allStudents = await db.readAllStudents();
      if (allStudents.length != 5) {
        print('   ❌ BULK test failed: Expected 5 students, got ${allStudents.length}');
        return false;
      }
      
      print('   ✅ BULK test passed');
      return true;
    } catch (e) {
      print('   ❌ BULK test failed: $e');
      return false;
    }
  }
}

/// Performance benchmarking utilities
class DatabaseBenchmark {
  final DatabaseService db;
  final String dbName;
  
  DatabaseBenchmark(this.db, this.dbName);
  
  /// Run performance benchmark
  Future<Map<String, int>> runBenchmark() async {
    print('\n⚡ Running performance benchmark for $dbName');
    print('=' * 50);
    
    await db.initialize();
    await db.clearAllStudents();
    
    final results = <String, int>{};
    
    // Benchmark CREATE operations
    results['create_single'] = await _benchmarkCreate();
    results['create_batch'] = await _benchmarkBatchCreate();
    
    // Benchmark READ operations
    results['read_single'] = await _benchmarkRead();
    results['read_all'] = await _benchmarkReadAll();
    
    // Benchmark QUERY operations
    results['query_by_major'] = await _benchmarkQuery();
    
    await db.close();
    
    print('\n📊 Benchmark Results for $dbName:');
    results.forEach((operation, time) {
      print('   $operation: ${time}ms');
    });
    
    return results;
  }
  
  Future<int> _benchmarkCreate() async {
    final stopwatch = Stopwatch()..start();
    
    await db.createStudent(Student(
      id: 'PERF001',
      name: 'Performance Test',
      age: 20,
      major: 'Testing',
      createdAt: DateTime.now(),
    ));
    
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }
  
  Future<int> _benchmarkBatchCreate() async {
    final stopwatch = Stopwatch()..start();
    
    for (int i = 1; i <= 10; i++) {
      await db.createStudent(Student(
        id: 'BATCH$i',
        name: 'Batch Student $i',
        age: 18 + (i % 5),
        major: 'Batch Testing',
        createdAt: DateTime.now(),
      ));
    }
    
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }
  
  Future<int> _benchmarkRead() async {
    final stopwatch = Stopwatch()..start();
    await db.readStudent('PERF001');
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }
  
  Future<int> _benchmarkReadAll() async {
    final stopwatch = Stopwatch()..start();
    await db.readAllStudents();
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }
  
  Future<int> _benchmarkQuery() async {
    final stopwatch = Stopwatch()..start();
    await db.getStudentsByMajor('Batch Testing');
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }
}
