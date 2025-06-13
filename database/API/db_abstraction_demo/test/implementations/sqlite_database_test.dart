import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:db_abstraction_demo/interfaces/database_interface.dart';
import 'package:db_abstraction_demo/implementations/sqlite_database.dart';
import 'package:db_abstraction_demo/models/student.dart';
import '../interfaces/database_interface_test.dart';

/// Test suite for SQLite database implementation
///
/// This class demonstrates how to test specific implementations
/// while still verifying they follow the interface contract
class SQLiteDatabaseTest extends DatabaseInterfaceTest {
  @override
  DatabaseInterface createDatabase() {
    // Create a new database instance with a unique name
    return SQLiteDatabase(
        databaseName: 'test_${DateTime.now().millisecondsSinceEpoch}.db');
  }

  void runSQLiteSpecificTests() {
    group('SQLite-specific Tests', () {
      setUp(() async {
        database = createDatabase();
        await database.initialize();
        await database.clear();
      });

      tearDown(() async {
        await database.clear();
        await database.close();
      });

      test('should use SQLite as database name', () {
        expect(database.databaseName, equals('SQLite'));
      });

      test('should handle SQL injection attempts safely', () async {
        // Try to create a student with malicious SQL in the name
        final maliciousStudent = Student(
          id: 'test-id',
          name: "'; DROP TABLE students; --",
          email: 'hacker@example.com',
          age: 25,
          major: 'Computer Science',
          createdAt: DateTime.now(),
        );

        // This should work without breaking the database
        await database.create(maliciousStudent);

        // Verify the student was stored correctly and database still works
        final retrieved = await database.read('test-id');
        expect(retrieved, isNotNull);
        expect(retrieved!.name, equals("'; DROP TABLE students; --"));

        // Verify database is still functional
        final allStudents = await database.getAll();
        expect(allStudents.length, equals(1));
      });

      test('should handle concurrent database operations', () async {
        // Create multiple students concurrently
        final futures = List.generate(10, (index) {
          final student = Student(
            id: 'student-$index',
            name: 'Student $index',
            email: 'student$index@example.com',
            age: 20 + index,
            major: 'Major $index',
            createdAt: DateTime.now(),
          );
          return database.create(student);
        });

        // All operations should complete successfully
        final results = await Future.wait(futures);
        expect(results.length, equals(10));

        // Verify all students were created
        final count = await database.count();
        expect(count, equals(10));
      });
    });
  }
}

void main() {
  // Initialize FFI before running any tests
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  final test = SQLiteDatabaseTest();
  test.runDatabaseInterfaceTests();

  group('SQLite-specific Tests', () {
    test.runSQLiteSpecificTests();
  });
}
