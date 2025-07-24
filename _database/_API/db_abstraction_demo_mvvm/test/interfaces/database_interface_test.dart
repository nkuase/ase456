import 'package:flutter_test/flutter_test.dart';
import 'package:db_abstraction_demo_mvvm/interfaces/database_interface.dart';
import 'package:db_abstraction_demo_mvvm/models/student.dart';

/// Base test class for database implementations
abstract class DatabaseInterfaceTest {
  /// Create a new database instance for testing
  DatabaseInterface createDatabase();

  /// Run standard interface tests
  void runDatabaseInterfaceTests() {
    late DatabaseInterface database;

    setUp(() async {
      database = createDatabase();
      await database.initialize();
      await database.clear();
    });

    tearDown(() async {
      await database.clear();
      await database.close();
    });

    group('Database Interface Tests', () {
      test('CRUD operations', () async {
        // Create
        final student = Student(
          id: 'test-id',
          name: 'Test Student',
          email: 'test@example.com',
          age: 20,
          major: 'Computer Science',
          createdAt: DateTime.now(),
        );
        await database.create(student);

        // Read
        final retrieved = await database.read('test-id');
        expect(retrieved, isNotNull);
        expect(retrieved!.name, equals('Test Student'));

        // Update
        final updated = student.copyWith(name: 'Updated Name');
        await database.update(updated);
        final retrievedUpdated = await database.read('test-id');
        expect(retrievedUpdated!.name, equals('Updated Name'));

        // Delete
        await database.delete('test-id');
        final retrievedDeleted = await database.read('test-id');
        expect(retrievedDeleted, isNull);
      });

      test('getAll and count', () async {
        // Create multiple students
        for (var i = 0; i < 3; i++) {
          final student = Student(
            id: 'student-$i',
            name: 'Student $i',
            email: 'student$i@example.com',
            age: 20 + i,
            major: 'Major $i',
            createdAt: DateTime.now(),
          );
          await database.create(student);
        }

        final allStudents = await database.getAll();
        expect(allStudents.length, equals(3));

        final count = await database.count();
        expect(count, equals(3));
      });
    });
  }
}

// This allows the test file to be run directly
void main() {
  test('Skip - This is a base test class', () {
    // This file contains the base test class and shouldn't be run directly
    expect(true, isTrue);
  });
}
