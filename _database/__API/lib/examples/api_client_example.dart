import '../api/crud_api_client.dart';
import '../core/models/student.dart';
import '../core/utils/json_converter.dart';

/// Example of using the CRUD API client to interact with the server
/// This demonstrates how applications can use the API regardless of the backend database
Future<void> main(List<String> args) async {
  print('📱 === CRUD API Client Example ===');
  print('Demonstrating how to interact with the Universal CRUD API...');
  
  // Parse command line arguments
  String apiUrl = 'http://localhost:8080';
  
  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--url':
      case '-u':
        if (i + 1 < args.length) {
          apiUrl = args[i + 1];
          i++;
        }
        break;
      case '--help':
        printHelp();
        return;
    }
  }
  
  // Create API client
  final client = CrudApiClient(baseUrl: apiUrl);
  
  try {
    await runApiClientDemo(client);
  } catch (e) {
    print('❌ Demo failed: $e');
    print('💡 Make sure the API server is running at $apiUrl');
    print('   Start server with: dart run lib/examples/api_server_example.dart');
  } finally {
    client.dispose();
  }
}

/// Run the complete API client demonstration
Future<void> runApiClientDemo(CrudApiClient client) async {
  print('\\n🔍 === Testing API Connection ===');
  
  // 1. Health Check
  final isHealthy = await client.isHealthy();
  if (!isHealthy) {
    throw Exception('API server is not healthy or not reachable');
  }
  print('✅ API server is healthy and reachable');
  
  // 2. Get initial statistics
  final initialStats = await client.getStatistics();
  print('📊 Initial database statistics:');
  print('   Total students: ${initialStats['totalStudents']}');
  print('   Average age: ${(initialStats['averageAge'] as num).toStringAsFixed(1)}');
  
  print('\\n📝 === CREATE Operations ===');
  
  // 3. Create individual students
  final sampleStudents = JsonConverter.createSampleStudents();
  final createdStudents = <Student>[];
  
  for (final student in sampleStudents.take(3)) {
    try {
      final created = await client.createStudent(student);
      createdStudents.add(created);
      print('✅ Created: ${created.name} (ID: ${created.id})');
    } catch (e) {
      print('❌ Failed to create ${student.name}: $e');
    }
  }
  
  // 4. Create students in batch
  final batchStudents = sampleStudents.skip(3).toList();
  if (batchStudents.isNotEmpty) {
    try {
      final batchResult = await client.createStudentsBatch(batchStudents);
      print('📦 Batch creation result:');
      print('   Successful: ${batchResult.successCount}');
      print('   Failed: ${batchResult.failureCount}');
      if (batchResult.errors.isNotEmpty) {
        print('   Errors:');
        for (final error in batchResult.errors) {
          print('     Index ${error.index}: ${error.error}');
        }
      }
    } catch (e) {
      print('❌ Batch creation failed: $e');
    }
  }
  
  print('\\n📖 === READ Operations ===');
  
  // 5. Get all students
  final allStudents = await client.getStudents();
  print('📋 Retrieved ${allStudents.totalItems} total students (page ${allStudents.page + 1}):');
  for (final student in allStudents.items) {
    print('   • ${student.name} (${student.age}) - ${student.major}');
  }
  
  // 6. Get students with pagination
  final paginatedStudents = await client.getStudents(
    const StudentQuery(limit: 2, offset: 0, sortBy: 'name'),
  );
  print('\\n📄 Paginated results (first 2 students, sorted by name):');
  for (final student in paginatedStudents.items) {
    print('   • ${student.name} - ${student.major}');
  }
  
  // 7. Get students with filtering
  final csStudents = await client.getStudents(
    const StudentQuery(major: 'Computer Science'),
  );
  print('\\n🖥️ Computer Science students: ${csStudents.items.length}');
  for (final student in csStudents.items) {
    print('   • ${student.name} (age ${student.age})');
  }
  
  // 8. Get specific student by ID
  if (createdStudents.isNotEmpty) {
    final firstStudent = createdStudents.first;
    final retrievedStudent = await client.getStudentById(firstStudent.id!);
    if (retrievedStudent != null) {
      print('\\n🔍 Retrieved student by ID: ${retrievedStudent.name}');
    }
  }
  
  print('\\n🔍 === SEARCH Operations ===');
  
  // 9. Search students
  final searchResults = await client.searchStudents('Alice');
  print('🔍 Search results for "Alice": ${searchResults.length} students');
  for (final student in searchResults) {
    print('   • ${student.name} - ${student.major}');
  }
  
  print('\\n✏️ === UPDATE Operations ===');
  
  // 10. Update a student
  if (createdStudents.isNotEmpty) {
    final studentToUpdate = createdStudents.first;
    final updatedStudent = studentToUpdate.copyWith(
      age: studentToUpdate.age + 1,
      major: 'Updated ${studentToUpdate.major}',
    );
    
    try {
      final result = await client.updateStudent(studentToUpdate.id!, updatedStudent);
      print('✅ Updated student: ${result.name}');
      print('   New age: ${result.age}, New major: ${result.major}');
    } catch (e) {
      print('❌ Failed to update student: $e');
    }
  }
  
  // 11. Update specific fields
  if (createdStudents.length > 1) {
    final studentToUpdate = createdStudents[1];
    try {
      final result = await client.updateStudentFields(
        studentToUpdate.id!,
        {'age': 25, 'major': 'Data Science'},
      );
      print('✅ Updated student fields: ${result.name}');
      print('   New age: ${result.age}, New major: ${result.major}');
    } catch (e) {
      print('❌ Failed to update student fields: $e');
    }
  }
  
  print('\\n📊 === ANALYTICS ===');
  
  // 12. Get updated statistics
  final updatedStats = await client.getStatistics();
  print('📈 Updated database statistics:');
  print('   Total students: ${updatedStats['totalStudents']}');
  print('   Average age: ${(updatedStats['averageAge'] as num).toStringAsFixed(1)}');
  print('   Major distribution: ${updatedStats['majorDistribution']}');
  print('   Age distribution: ${updatedStats['ageDistribution']}');
  
  print('\\n📤 === EXPORT/IMPORT ===');
  
  // 13. Export data
  final exportedData = await client.exportStudents();
  print('📤 Exported ${exportedData.length} student records');
  
  // Show first exported record as example
  if (exportedData.isNotEmpty) {
    print('📄 Example exported record:');
    final prettyJson = JsonConverter.prettyPrintJson(exportedData.first);
    print(prettyJson);
  }
  
  print('\\n🗑️ === DELETE Operations ===');
  
  // 14. Delete a specific student
  if (createdStudents.length > 2) {
    final studentToDelete = createdStudents.last;
    try {
      final deleteSuccess = await client.deleteStudent(studentToDelete.id!);
      if (deleteSuccess) {
        print('✅ Deleted student: ${studentToDelete.name}');
      } else {
        print('⚠️ Student not found for deletion');
      }
    } catch (e) {
      print('❌ Failed to delete student: $e');
    }
  }
  
  // 15. Get final count
  final finalStudents = await client.getStudents();
  print('📊 Final student count: ${finalStudents.totalItems}');
  
  print('\\n🎉 === API Client Demo Complete ===');
  print('✨ Successfully demonstrated all CRUD operations via REST API!');
  print('🔗 The client can work with ANY database backend through the API');
}

/// Interactive demo that lets users try operations manually
Future<void> runInteractiveDemo(CrudApiClient client) async {
  print('\\n🎮 === Interactive Demo ===');
  print('You can now try API operations manually!');
  print('');
  print('Available operations:');
  print('1. Create student');
  print('2. List all students');
  print('3. Search students');
  print('4. Get student by ID');
  print('5. Update student');
  print('6. Delete student');
  print('7. Get statistics');
  print('8. Health check');
  print('0. Exit');
  
  // Note: This is a simplified version. In a real interactive demo,
  // you would need to handle stdin input, which requires additional setup
  print('\\n💡 For a full interactive demo, implement stdin handling');
  print('💡 For now, check the API endpoints directly with curl commands');
}

/// Print help message
void printHelp() {
  print('Universal CRUD API Client Example');
  print('');
  print('Usage: dart run lib/examples/api_client_example.dart [OPTIONS]');
  print('');
  print('Options:');
  print('  -u, --url URL          API server URL [default: http://localhost:8080]');
  print('  --help                 Show this help message');
  print('');
  print('Examples:');
  print('  dart run lib/examples/api_client_example.dart');
  print('  dart run lib/examples/api_client_example.dart -u http://localhost:3000');
  print('');
  print('Note: Make sure the API server is running before running this client.');
  print('Start server with: dart run lib/examples/api_server_example.dart');
}
