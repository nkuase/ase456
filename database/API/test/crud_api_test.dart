import 'package:test/test.dart';
import '../lib/core/models/student.dart';
import '../lib/core/models/api_response.dart';
import '../lib/core/utils/json_converter.dart';
import '../lib/implementations/sqlite_service.dart';

void main() {
  group('Universal CRUD API Tests', () {
    late SQLiteService dbService;
    
    setUp(() async {
      // Create a unique test database for each test
      final timestamp = DateTime.now().microsecondsSinceEpoch;
      dbService = SQLiteService(customDbPath: 'test_$timestamp.db');
      await dbService.initialize();
    });
    
    tearDown(() async {
      await dbService.close();
    });

    group('Student Model Tests', () {
      test('should create student from JSON', () {
        final json = {
          'id': '123',
          'name': 'Test Student',
          'age': 20,
          'major': 'Computer Science',
          'createdAt': '2025-01-15T10:30:00Z',
          'updatedAt': '2025-01-15T10:30:00Z',
        };

        final student = Student.fromJson(json);

        expect(student.id, equals('123'));
        expect(student.name, equals('Test Student'));
        expect(student.age, equals(20));
        expect(student.major, equals('Computer Science'));
      });

      test('should convert student to JSON', () {
        const student = Student(
          id: '123',
          name: 'Test Student',
          age: 20,
          major: 'Computer Science',
        );

        final json = student.toJson();

        expect(json['id'], equals('123'));
        expect(json['name'], equals('Test Student'));
        expect(json['age'], equals(20));
        expect(json['major'], equals('Computer Science'));
      });

      test('should validate student data', () {
        const validStudent = Student(
          name: 'Valid Student',
          age: 20,
          major: 'Computer Science',
        );

        const invalidStudent = Student(
          name: '',
          age: 15,
          major: '',
        );

        expect(validStudent.isValid(), isTrue);
        expect(invalidStudent.isValid(), isFalse);
        
        final errors = invalidStudent.getValidationErrors();
        expect(errors, contains('Name cannot be empty'));
        expect(errors, contains('Age must be between 16 and 120'));
        expect(errors, contains('Major cannot be empty'));
      });

      test('should create copy with modified fields', () {
        const original = Student(
          id: '123',
          name: 'Original Name',
          age: 20,
          major: 'Original Major',
        );

        final copy = original.copyWith(
          name: 'New Name',
          age: 21,
        );

        expect(copy.id, equals('123'));
        expect(copy.name, equals('New Name'));
        expect(copy.age, equals(21));
        expect(copy.major, equals('Original Major'));
      });
    });

    group('Database Service Tests', () {
      test('should create and retrieve student', () async {
        const student = Student(
          name: 'Test Student',
          age: 20,
          major: 'Computer Science',
        );

        // Create student
        final id = await dbService.createStudent(student);
        expect(id, isNotEmpty);

        // Retrieve student
        final retrieved = await dbService.getStudentById(id);
        expect(retrieved, isNotNull);
        expect(retrieved!.name, equals('Test Student'));
        expect(retrieved.age, equals(20));
        expect(retrieved.major, equals('Computer Science'));
      });

      test('should update student', () async {
        const student = Student(
          name: 'Original Name',
          age: 20,
          major: 'Original Major',
        );

        final id = await dbService.createStudent(student);
        
        const updatedStudent = Student(
          name: 'Updated Name',
          age: 21,
          major: 'Updated Major',
        );

        final success = await dbService.updateStudent(id, updatedStudent);
        expect(success, isTrue);

        final retrieved = await dbService.getStudentById(id);
        expect(retrieved!.name, equals('Updated Name'));
        expect(retrieved.age, equals(21));
        expect(retrieved.major, equals('Updated Major'));
      });

      test('should delete student', () async {
        const student = Student(
          name: 'To Delete',
          age: 20,
          major: 'Computer Science',
        );

        final id = await dbService.createStudent(student);
        
        final deleteSuccess = await dbService.deleteStudent(id);
        expect(deleteSuccess, isTrue);

        final retrieved = await dbService.getStudentById(id);
        expect(retrieved, isNull);
      });

      test('should handle batch operations', () async {
        final students = [
          const Student(name: 'Student 1', age: 20, major: 'CS'),
          const Student(name: 'Student 2', age: 21, major: 'Math'),
          const Student(name: 'Student 3', age: 22, major: 'Physics'),
        ];

        final batchResult = await dbService.createStudentsBatch(students);
        
        expect(batchResult.successCount, equals(3));
        expect(batchResult.failureCount, equals(0));
        expect(batchResult.createdIds, hasLength(3));

        final allStudents = await dbService.getStudents();
        expect(allStudents.totalItems, equals(3));
      });

      test('should filter students by query', () async {
        final students = [
          const Student(name: 'Alice CS', age: 20, major: 'Computer Science'),
          const Student(name: 'Bob Math', age: 21, major: 'Mathematics'),
          const Student(name: 'Carol CS', age: 22, major: 'Computer Science'),
        ];

        await dbService.createStudentsBatch(students);

        // Filter by major
        final csStudents = await dbService.getStudents(
          const StudentQuery(major: 'Computer Science'),
        );
        expect(csStudents.items, hasLength(2));
        expect(csStudents.items.every((s) => s.major == 'Computer Science'), isTrue);

        // Filter by age range
        final youngStudents = await dbService.getStudents(
          const StudentQuery(minAge: 20, maxAge: 21),
        );
        expect(youngStudents.items, hasLength(2));
        expect(youngStudents.items.every((s) => s.age >= 20 && s.age <= 21), isTrue);

        // Filter by name contains
        final aliceStudents = await dbService.getStudents(
          const StudentQuery(nameContains: 'Alice'),
        );
        expect(aliceStudents.items, hasLength(1));
        expect(aliceStudents.items.first.name, contains('Alice'));
      });

      test('should handle pagination', () async {
        final students = List.generate(10, (i) => Student(
          name: 'Student $i',
          age: 20 + i,
          major: 'Major $i',
        ));

        await dbService.createStudentsBatch(students);

        // Get first page
        final firstPage = await dbService.getStudents(
          const StudentQuery(limit: 3, offset: 0, sortBy: 'name'),
        );
        expect(firstPage.items, hasLength(3));
        expect(firstPage.totalItems, equals(10));
        expect(firstPage.hasNext, isTrue);
        expect(firstPage.hasPrevious, isFalse);

        // Get second page
        final secondPage = await dbService.getStudents(
          const StudentQuery(limit: 3, offset: 3, sortBy: 'name'),
        );
        expect(secondPage.items, hasLength(3));
        expect(secondPage.hasNext, isTrue);
        expect(secondPage.hasPrevious, isTrue);
      });

      test('should search students', () async {
        final students = [
          const Student(name: 'Alice Johnson', age: 20, major: 'Computer Science'),
          const Student(name: 'Alice Smith', age: 21, major: 'Mathematics'),
          const Student(name: 'Bob Alice', age: 22, major: 'Physics'),
          const Student(name: 'Carol Davis', age: 23, major: 'Chemistry'),
        ];

        await dbService.createStudentsBatch(students);

        final searchResults = await dbService.searchStudents('Alice');
        expect(searchResults, hasLength(3));
        expect(searchResults.every((s) => s.name.contains('Alice')), isTrue);
      });

      test('should get student statistics', () async {
        final students = [
          const Student(name: 'Student 1', age: 20, major: 'Computer Science'),
          const Student(name: 'Student 2', age: 22, major: 'Computer Science'),
          const Student(name: 'Student 3', age: 24, major: 'Mathematics'),
          const Student(name: 'Student 4', age: 26, major: 'Mathematics'),
        ];

        await dbService.createStudentsBatch(students);

        final stats = await dbService.getStudentStatistics();
        
        expect(stats['totalStudents'], equals(4));
        expect(stats['averageAge'], equals(23.0));
        
        final majorDistribution = stats['majorDistribution'] as Map<String, int>;
        expect(majorDistribution['Computer Science'], equals(2));
        expect(majorDistribution['Mathematics'], equals(2));
      });

      test('should export and import students', () async {
        final originalStudents = [
          const Student(name: 'Export Student 1', age: 20, major: 'CS'),
          const Student(name: 'Export Student 2', age: 21, major: 'Math'),
        ];

        await dbService.createStudentsBatch(originalStudents);

        // Export
        final exportedData = await dbService.exportStudents();
        expect(exportedData, hasLength(2));

        // Clear database
        await dbService.deleteAllStudents();
        final emptyCount = await dbService.getStudentsCount();
        expect(emptyCount, equals(0));

        // Import
        final importResult = await dbService.importStudents(exportedData);
        expect(importResult.successCount, equals(2));
        expect(importResult.failureCount, equals(0));

        // Verify import
        final importedStudents = await dbService.getStudents();
        expect(importedStudents.totalItems, equals(2));
      });
    });

    group('API Response Tests', () {
      test('should create success response', () {
        final response = ApiResponse.success('test data');
        
        expect(response.success, isTrue);
        expect(response.data, equals('test data'));
        expect(response.error, isNull);
      });

      test('should create error response', () {
        final response = ApiResponse<String>.error('test error');
        
        expect(response.success, isFalse);
        expect(response.data, isNull);
        expect(response.error, equals('test error'));
      });

      test('should create validation error response', () {
        final response = ApiResponse<String>.validationError(['error 1', 'error 2']);
        
        expect(response.success, isFalse);
        expect(response.error, equals('Validation failed'));
        expect(response.errorDetails, equals('error 1, error 2'));
        expect(response.statusCode, equals(400));
      });

      test('should handle fold operation', () {
        final successResponse = ApiResponse.success('test data');
        final errorResponse = ApiResponse<String>.error('test error');

        final successResult = successResponse.fold(
          onSuccess: (data) => 'Success: $data',
          onError: (error) => 'Error: $error',
        );

        final errorResult = errorResponse.fold(
          onSuccess: (data) => 'Success: $data',
          onError: (error) => 'Error: $error',
        );

        expect(successResult, equals('Success: test data'));
        expect(errorResult, equals('Error: test error'));
      });
    });

    group('JSON Converter Tests', () {
      test('should convert student between database formats', () {
        final sqliteData = {
          'id': 123,
          'name': 'Test Student',
          'age': 20,
          'major': 'CS',
          'createdAt': '2025-01-15T10:30:00Z',
          'updatedAt': '2025-01-15T10:30:00Z',
        };

        final student = JsonConverter.adaptStudentFromDatabase(sqliteData, 'sqlite');
        
        expect(student.id, equals('123')); // Converted to string
        expect(student.name, equals('Test Student'));
        expect(student.age, equals(20));
        expect(student.major, equals('CS'));
      });

      test('should validate JSON structure', () {
        final validJson = {
          'name': 'Test Student',
          'age': 20,
          'major': 'Computer Science',
        };

        final invalidJson = {
          'name': 'Test Student',
          'age': 'invalid', // Should be int
          'major': 'Computer Science',
        };

        expect(JsonConverter.isValidStudentJson(validJson), isTrue);
        expect(JsonConverter.isValidStudentJson(invalidJson), isFalse);
      });

      test('should sanitize string input', () {
        final messy = '  Multiple   Spaces  ';
        final clean = JsonConverter.sanitizeString(messy);
        
        expect(clean, equals('Multiple Spaces'));
      });

      test('should parse DateTime safely', () {
        final isoString = '2025-01-15T10:30:00Z';
        final parsed = JsonConverter.parseDateTime(isoString);
        
        expect(parsed, isNotNull);
        expect(parsed!.year, equals(2025));
        expect(parsed.month, equals(1));
        expect(parsed.day, equals(15));

        final invalidString = 'not a date';
        final invalidParsed = JsonConverter.parseDateTime(invalidString);
        expect(invalidParsed, isNull);
      });
    });
  });
}
