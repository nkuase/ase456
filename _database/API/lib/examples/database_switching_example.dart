import '../core/interfaces/database_service.dart';
import '../core/models/student.dart';
import '../core/utils/json_converter.dart';
import '../implementations/sqlite_service.dart';
import '../implementations/pocketbase_service.dart';
import '../api/crud_api_server.dart';
import '../api/crud_api_client.dart';

/// Example demonstrating how to switch between different database backends
/// This shows the power of the universal CRUD API - same code works with any database!
class DatabaseSwitchingExample {
  
  /// Demonstrate CRUD operations with any database service
  static Future<void> demonstrateCrud(DatabaseService dbService) async {
    print('\n🎯 === CRUD Demo with ${dbService.databaseType} ===');
    
    try {
      // Initialize database
      await dbService.initialize();
      print('✅ Database initialized');
      
      // Check health
      final isHealthy = await dbService.isHealthy();
      print('💗 Database health: ${isHealthy ? "healthy" : "unhealthy"}');
      
      // CREATE: Add sample students
      print('\n📝 CREATE Operations:');
      final sampleStudents = JsonConverter.createSampleStudents();
      
      // Create students individually
      final createdIds = <String>[];
      for (final student in sampleStudents.take(3)) {
        final id = await dbService.createStudent(student);
        createdIds.add(id);
        print('  ✅ Created student: ${student.name} (ID: $id)');
      }
      
      // Create students in batch
      final batchStudents = sampleStudents.skip(3).toList();
      if (batchStudents.isNotEmpty) {
        final batchResult = await dbService.createStudentsBatch(batchStudents);
        print('  ✅ Batch created: ${batchResult.successCount} students, ${batchResult.failureCount} failures');
      }
      
      // READ: Get all students
      print('\n📖 READ Operations:');
      final allStudents = await dbService.getStudents();
      print('  📊 Total students: ${allStudents.totalItems}');
      print('  📋 Students on page 1:');
      for (final student in allStudents.items) {
        print('    • ${student.name} (${student.age}) - ${student.major}');
      }
      
      // Read specific student
      if (createdIds.isNotEmpty) {
        final firstStudent = await dbService.getStudentById(createdIds.first);
        if (firstStudent != null) {
          print('  🔍 Found student by ID: ${firstStudent.name}');
        }
      }
      
      // READ with filtering
      final csStudents = await dbService.getStudents(
        const StudentQuery(major: 'Computer Science'),
      );
      print('  🖥️ Computer Science students: ${csStudents.items.length}');
      
      // UPDATE: Modify a student
      print('\n✏️ UPDATE Operations:');
      if (createdIds.isNotEmpty) {
        final studentToUpdate = await dbService.getStudentById(createdIds.first);
        if (studentToUpdate != null) {
          final updatedStudent = studentToUpdate.copyWith(
            age: studentToUpdate.age + 1,
            major: 'Updated ${studentToUpdate.major}',
          );
          
          final updateSuccess = await dbService.updateStudent(createdIds.first, updatedStudent);
          if (updateSuccess) {
            print('  ✅ Updated student: ${studentToUpdate.name}');
            
            // Verify update
            final verifyStudent = await dbService.getStudentById(createdIds.first);
            if (verifyStudent != null) {
              print('    📊 New age: ${verifyStudent.age}, New major: ${verifyStudent.major}');
            }
          }
        }
      }
      
      // UPDATE specific fields
      if (createdIds.length > 1) {
        final fieldsUpdateSuccess = await dbService.updateStudentFields(
          createdIds[1],
          {'age': 25},
        );
        if (fieldsUpdateSuccess) {
          print('  ✅ Updated student fields');
        }
      }
      
      // SEARCH: Find students
      print('\n🔍 SEARCH Operations:');
      final searchResults = await dbService.searchStudents('Alice');
      print('  🔍 Search results for "Alice": ${searchResults.length} students');
      for (final student in searchResults) {
        print('    • ${student.name} - ${student.major}');
      }
      
      // ANALYTICS: Get statistics
      print('\n📊 ANALYTICS:');
      final stats = await dbService.getStudentStatistics();
      print('  📈 Statistics:');
      print('    • Total students: ${stats['totalStudents']}');
      print('    • Average age: ${(stats['averageAge'] as double).toStringAsFixed(1)}');
      print('    • Major distribution: ${stats['majorDistribution']}');
      print('    • Age distribution: ${stats['ageDistribution']}');
      
      // DELETE: Remove some students
      print('\n🗑️ DELETE Operations:');
      if (createdIds.length > 2) {
        final deleteSuccess = await dbService.deleteStudent(createdIds.last);
        if (deleteSuccess) {
          print('  ✅ Deleted student with ID: ${createdIds.last}');
        }
      }
      
      // Get final count
      final finalCount = await dbService.getStudentsCount();
      print('  📊 Final student count: $finalCount');
      
      print('\n🎉 === ${dbService.databaseType} Demo Completed ===');
      
    } catch (e) {
      print('❌ Error during demo: $e');
    } finally {
      // Clean up
      await dbService.close();
      print('🔒 Database connection closed');
    }
  }
  
  /// Demonstrate switching between database backends
  static Future<void> demonstrateDatabaseSwitching() async {
    print('🔄 === Database Switching Demonstration ===');
    print('This example shows how the same code works with different databases!');
    
    // 1. SQLite Database
    print('\n1️⃣ Testing with SQLite...');
    final sqliteService = SQLiteService(customDbPath: 'demo_sqlite.db');
    await demonstrateCrud(sqliteService);
    
    // 2. PocketBase Database (mock implementation)
    print('\n2️⃣ Testing with PocketBase...');
    final pocketbaseService = PocketBaseService();
    await demonstrateCrud(pocketbaseService);
    
    // 3. API-based access (if server is running)
    print('\n3️⃣ Testing with API Client...');
    try {
      final apiClient = ApiDatabaseService('http://localhost:8080');
      final isApiHealthy = await apiClient.isHealthy();
      
      if (isApiHealthy) {
        print('✅ API server is available, running demo...');
        // Convert ApiDatabaseService to work with demonstrateCrud
        // Note: This would require wrapping ApiDatabaseService to implement DatabaseService
        print('📝 API demo would run here (implementation needed)');
      } else {
        print('⚠️ API server not available, skipping API demo');
        print('💡 Start the API server with: dart run lib/examples/api_server_example.dart');
      }
      
      apiClient.dispose();
    } catch (e) {
      print('⚠️ API server not available: $e');
      print('💡 Start the API server first to test API access');
    }
    
    print('\n✨ === Switching Demo Complete ===');
    print('🎯 Key Takeaway: Same CRUD code works with ANY database!');
    print('🔄 You can switch databases by changing just one line of code');
  }
  
  /// Demonstrate data migration between databases
  static Future<void> demonstrateDataMigration() async {
    print('\n📦 === Data Migration Demonstration ===');
    
    try {
      // Source database (SQLite)
      final sourceDb = SQLiteService(customDbPath: 'source.db');
      await sourceDb.initialize();
      print('✅ Source database (SQLite) initialized');
      
      // Add some data to source
      final sampleStudents = JsonConverter.createSampleStudents();
      await sourceDb.createStudentsBatch(sampleStudents);
      print('📝 Added ${sampleStudents.length} students to source database');
      
      // Export data from source
      final exportedData = await sourceDb.exportStudents();
      print('📤 Exported ${exportedData.length} student records');
      
      // Target database (different type)
      final targetDb = PocketBaseService();
      await targetDb.initialize();
      print('✅ Target database (PocketBase) initialized');
      
      // Import data to target
      final importResult = await targetDb.importStudents(exportedData);
      print('📥 Import result: ${importResult.successCount} successful, ${importResult.failureCount} failed');
      
      // Verify migration
      final sourceCount = await sourceDb.getStudentsCount();
      final targetCount = await targetDb.getStudentsCount();
      print('📊 Migration verification:');
      print('   Source: $sourceCount students');
      print('   Target: $targetCount students');
      
      if (sourceCount == targetCount) {
        print('✅ Migration successful - all data transferred!');
      } else {
        print('⚠️ Migration incomplete - some data may be missing');
      }
      
      // Clean up
      await sourceDb.close();
      await targetDb.close();
      
    } catch (e) {
      print('❌ Migration failed: $e');
    }
    
    print('📦 === Migration Demo Complete ===');
  }
  
  /// Show performance comparison between databases
  static Future<void> demonstratePerformanceComparison() async {
    print('\n⚡ === Performance Comparison ===');
    
    final testSize = 100;
    final testStudents = List.generate(testSize, (i) => Student(
      name: 'Test Student $i',
      age: 20 + (i % 10),
      major: ['Computer Science', 'Mathematics', 'Physics'][i % 3],
    ));
    
    // Test SQLite performance
    print('\n🏃 Testing SQLite performance...');
    await _measureDatabasePerformance('SQLite', 
      SQLiteService(customDbPath: 'perf_test_sqlite.db'), 
      testStudents
    );
    
    // Test PocketBase performance (mock)
    print('\n🏃 Testing PocketBase performance...');
    await _measureDatabasePerformance('PocketBase', 
      PocketBaseService(), 
      testStudents
    );
    
    print('\n⚡ === Performance Comparison Complete ===');
  }
  
  static Future<void> _measureDatabasePerformance(
    String dbName, 
    DatabaseService dbService, 
    List<Student> testStudents
  ) async {
    try {
      await dbService.initialize();
      
      // Measure batch create
      final createStart = DateTime.now();
      final batchResult = await dbService.createStudentsBatch(testStudents);
      final createDuration = DateTime.now().difference(createStart);
      
      print('  📝 $dbName Create: ${createDuration.inMilliseconds}ms for ${batchResult.successCount} students');
      
      // Measure read all
      final readStart = DateTime.now();
      final allStudents = await dbService.getStudents();
      final readDuration = DateTime.now().difference(readStart);
      
      print('  📖 $dbName Read: ${readDuration.inMilliseconds}ms for ${allStudents.totalItems} students');
      
      // Measure search
      final searchStart = DateTime.now();
      final searchResults = await dbService.searchStudents('Computer');
      final searchDuration = DateTime.now().difference(searchStart);
      
      print('  🔍 $dbName Search: ${searchDuration.inMilliseconds}ms, found ${searchResults.length} results');
      
      // Cleanup
      await dbService.deleteAllStudents();
      await dbService.close();
      
    } catch (e) {
      print('  ❌ $dbName performance test failed: $e');
    }
  }
}

/// Main function to run all examples
Future<void> main() async {
  print('🚀 === Universal CRUD API Examples ===');
  print('This demonstrates database-agnostic development!');
  
  try {
    // 1. Basic database switching
    await DatabaseSwitchingExample.demonstrateDatabaseSwitching();
    
    // 2. Data migration between databases
    await DatabaseSwitchingExample.demonstrateDataMigration();
    
    // 3. Performance comparison
    await DatabaseSwitchingExample.demonstratePerformanceComparison();
    
  } catch (e) {
    print('❌ Example execution failed: $e');
  }
  
  print('\n🎯 === All Examples Complete ===');
  print('💡 Key Benefits Demonstrated:');
  print('   • Same CRUD interface works with ANY database');
  print('   • Easy switching between database backends');
  print('   • Seamless data migration between systems');
  print('   • Performance testing across different databases');
  print('   • Database-agnostic application development');
}
