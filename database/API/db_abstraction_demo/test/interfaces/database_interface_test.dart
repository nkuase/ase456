import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:db_abstraction_demo/interfaces/database_interface.dart';
import 'package:db_abstraction_demo/models/student.dart';

/// Abstract test suite that verifies any database implementation follows the interface contract
///
/// This is a perfect example of how to test interfaces in a way that ensures
/// all implementations behave consistently. Students learn:
/// 1. How to write contract-based tests
/// 2. How to ensure different implementations are compatible
/// 3. The importance of consistent behavior across implementations
/// 4. How to test asynchronous operations
abstract class DatabaseInterfaceTest {
  late DatabaseInterface database;
  final _uuid = const Uuid();

  /// Create the database instance to test
  /// Each implementation test will override this
  DatabaseInterface createDatabase();

  /// Standard test suite that all database implementations must pass
  void runDatabaseInterfaceTests() {
    group('Database Interface Contract Tests', () {
      setUp(() async {
        database = createDatabase();
        await database.initialize();
        await database.clear(); // Start with a clean slate
      });

      tearDown(() async {
        await database.clear();
        await database.close();
      });

      group('Initialization and Connection', () {
        test('should initialize successfully', () async {
          final newDb = createDatabase();
          final result = await newDb.initialize();
          expect(result, isTrue);
          expect(newDb.isConnected, isTrue);
          await newDb.close();
        });

        test('should have proper database name', () {
          expect(database.databaseName, isNotEmpty);
          expect(database.databaseName, isA<String>());
        });

        test('should report connection status correctly', () {
          expect(database.isConnected, isTrue);
        });
      });

      group('Create Operations', () {
        test('should create a student successfully', () async {
          final student = _createTestStudent();

          final result = await database.create(student);

          expect(result.id, equals(student.id));
          expect(result.name, equals(student.name));
          expect(result.email, equals(student.email));
          expect(result.age, equals(student.age));
          expect(result.major, equals(student.major));
        });

        test('should handle duplicate email creation', () async {
          final student1 = _createTestStudent();
          final student2 = Student(
            id: _uuid.v4(),
            name: 'Different Name',
            email: student1.email, // Same email
            age: 25,
            major: 'Physics',
            createdAt: DateTime.now(),
          );

          await database.create(student1);

          // Some databases enforce unique email, others don't
          // We'll test both scenarios
          try {
            await database.create(student2);
            // If no exception, that's fine - not all DBs enforce uniqueness
          } catch (e) {
            // If exception, it should be a DBAbstractionException
            expect(e, isA<DBAbstractionException>());
          }
        });
      });

      group('Read Operations', () {
        test('should read existing student', () async {
          final student = _createTestStudent();
          await database.create(student);

          final result = await database.read(student.id);

          expect(result, isNotNull);
          expect(result!.id, equals(student.id));
          expect(result.name, equals(student.name));
          expect(result.email, equals(student.email));
          expect(result.age, equals(student.age));
          expect(result.major, equals(student.major));
        });

        test('should return null for non-existent student', () async {
          const fakeId = 'non-existent-id';

          final result = await database.read(fakeId);

          expect(result, isNull);
        });
      });

      group('Update Operations', () {
        test('should update existing student', () async {
          final original = _createTestStudent();
          await database.create(original);

          final updated = original.copyWith(
            name: 'Updated Name',
            age: 30,
            major: 'Updated Major',
          );

          final result = await database.update(updated);

          expect(result.id, equals(original.id));
          expect(result.name, equals('Updated Name'));
          expect(result.age, equals(30));
          expect(result.major, equals('Updated Major'));
          expect(result.email, equals(original.email)); // Unchanged

          // Verify by reading back
          final readBack = await database.read(original.id);
          expect(readBack!.name, equals('Updated Name'));
        });

        test('should throw exception for non-existent student update',
            () async {
          final nonExistent = _createTestStudent();

          expect(
            () => database.update(nonExistent),
            throwsA(isA<DBAbstractionException>()),
          );
        });
      });

      group('Delete Operations', () {
        test('should delete existing student', () async {
          final student = _createTestStudent();
          await database.create(student);

          final result = await database.delete(student.id);

          expect(result, isTrue);

          // Verify deletion by trying to read
          final readResult = await database.read(student.id);
          expect(readResult, isNull);
        });

        test('should return false for non-existent student deletion', () async {
          const fakeId = 'non-existent-id';

          final result = await database.delete(fakeId);

          expect(result, isFalse);
        });
      });

      group('Query Operations', () {
        test('should get all students', () async {
          final students = [
            _createTestStudent(name: 'Alice', major: 'Computer Science'),
            _createTestStudent(name: 'Bob', major: 'Mathematics'),
            _createTestStudent(name: 'Charlie', major: 'Computer Science'),
          ];

          for (final student in students) {
            await database.create(student);
          }

          final result = await database.getAll();

          expect(result.length, equals(3));
          // Results should be sorted by name
          expect(result[0].name, equals('Alice'));
          expect(result[1].name, equals('Bob'));
          expect(result[2].name, equals('Charlie'));
        });

        test('should filter students by major', () async {
          final students = [
            _createTestStudent(name: 'Alice', major: 'Computer Science'),
            _createTestStudent(name: 'Bob', major: 'Mathematics'),
            _createTestStudent(name: 'Charlie', major: 'Computer Science'),
          ];

          for (final student in students) {
            await database.create(student);
          }

          final result = await database.getAll(majorFilter: 'Computer Science');

          expect(result.length, equals(2));
          expect(result.every((s) => s.major == 'Computer Science'), isTrue);
        });

        test('should search students by name', () async {
          final students = [
            _createTestStudent(name: 'Alice Johnson'),
            _createTestStudent(name: 'Bob Smith'),
            _createTestStudent(name: 'Alice Brown'),
          ];

          for (final student in students) {
            await database.create(student);
          }

          final result = await database.searchByName('Alice');

          expect(result.length, equals(2));
          expect(result.every((s) => s.name.contains('Alice')), isTrue);
        });

        test('should count students correctly', () async {
          expect(await database.count(), equals(0));

          await database.create(_createTestStudent());
          expect(await database.count(), equals(1));

          await database.create(_createTestStudent());
          expect(await database.count(), equals(2));
        });

        test('should return empty list when no students exist', () async {
          final result = await database.getAll();
          expect(result, isEmpty);
        });
      });

      group('Clear Operations', () {
        test('should clear all students', () async {
          final students = [
            _createTestStudent(),
            _createTestStudent(),
            _createTestStudent(),
          ];

          for (final student in students) {
            await database.create(student);
          }

          expect(await database.count(), equals(3));

          final result = await database.clear();

          expect(result, isTrue);
          expect(await database.count(), equals(0));
          expect(await database.getAll(), isEmpty);
        });
      });

      group('Error Handling', () {
        test(
            'should throw DatabaseException on operations without initialization',
            () async {
          final uninitializedDb = createDatabase();
          final student = _createTestStudent();

          expect(
            () => uninitializedDb.create(student),
            throwsA(isA<DBAbstractionException>()),
          );

          expect(
            () => uninitializedDb.read('any-id'),
            throwsA(isA<DBAbstractionException>()),
          );

          expect(
            () => uninitializedDb.update(student),
            throwsA(isA<DBAbstractionException>()),
          );

          expect(
            () => uninitializedDb.delete('any-id'),
            throwsA(isA<DBAbstractionException>()),
          );
        });

        test('should handle concurrent operations gracefully', () async {
          final student = _createTestStudent();

          // Create student
          await database.create(student);

          // Try concurrent updates
          final futures = List.generate(5, (index) {
            final updated = student.copyWith(name: 'Updated $index');
            return database.update(updated);
          });

          // All should complete without throwing
          final results = await Future.wait(futures);
          expect(results.length, equals(5));
        });
      });

      group('Data Integrity', () {
        test('should preserve data types correctly', () async {
          final student = Student(
            id: _uuid.v4(),
            name: 'Test Student',
            email: 'test@example.com',
            age: 25,
            major: 'Computer Science',
            createdAt: DateTime.now(),
          );

          await database.create(student);
          final result = await database.read(student.id);

          expect(result!.id, isA<String>());
          expect(result.name, isA<String>());
          expect(result.email, isA<String>());
          expect(result.age, isA<int>());
          expect(result.major, isA<String>());
          expect(result.createdAt, isA<DateTime>());
        });

        test('should handle special characters in text fields', () async {
          final student = Student(
            id: _uuid.v4(),
            name: 'José María O\'Connor',
            email: 'josé@example.com',
            age: 25,
            major: 'Français & Español',
            createdAt: DateTime.now(),
          );

          await database.create(student);
          final result = await database.read(student.id);

          expect(result!.name, equals(student.name));
          expect(result.email, equals(student.email));
          expect(result.major, equals(student.major));
        });
      });
    });
  }

  /// Helper method to create test students
  Student _createTestStudent({
    String? name,
    String? email,
    int? age,
    String? major,
  }) {
    final id = _uuid.v4();
    return Student(
      id: id,
      name: name ?? 'Test Student',
      email:
          email ?? 'test.$id@example.com', // Make email unique by using the ID
      age: age ?? 20,
      major: major ?? 'Test Major',
      createdAt: DateTime.now(),
    );
  }
}

/// Mock implementation for testing
class MockDatabaseTest extends DatabaseInterfaceTest {
  @override
  DatabaseInterface createDatabase() {
    return MockDatabase();
  }
}

void main() {
  final test = MockDatabaseTest();
  test.runDatabaseInterfaceTests();
}

/// Mock database for testing
class MockDatabase implements DatabaseInterface {
  final Map<String, Student> _students = {};
  bool _isConnected = false;

  @override
  String get databaseName => 'MockDatabase';

  @override
  bool get isConnected => _isConnected;

  void _checkConnection() {
    if (!_isConnected) {
      throw DBAbstractionException('Database not initialized');
    }
  }

  @override
  Future<bool> initialize() async {
    _isConnected = true;
    return true;
  }

  @override
  Future<Student> create(Student student) async {
    _checkConnection();

    // Check for duplicate email
    if (_students.values.any((s) => s.email == student.email)) {
      throw DBAbstractionException(
          'Student with email ${student.email} already exists');
    }

    _students[student.id] = student;
    return student;
  }

  @override
  Future<Student?> read(String id) async {
    _checkConnection();
    return _students[id];
  }

  @override
  Future<Student> update(Student student) async {
    _checkConnection();

    if (!_students.containsKey(student.id)) {
      throw DBAbstractionException('Student with ID ${student.id} not found');
    }

    // Check for duplicate email, excluding the current student
    if (_students.values
        .any((s) => s.email == student.email && s.id != student.id)) {
      throw DBAbstractionException(
          'Student with email ${student.email} already exists');
    }

    _students[student.id] = student;
    return student;
  }

  @override
  Future<bool> delete(String id) async {
    _checkConnection();
    return _students.remove(id) != null;
  }

  @override
  Future<List<Student>> getAll({String? majorFilter}) async {
    _checkConnection();
    var students = _students.values.toList();
    if (majorFilter != null) {
      students = students.where((s) => s.major == majorFilter).toList();
    }
    students.sort((a, b) => a.name.compareTo(b.name));
    return students;
  }

  @override
  Future<List<Student>> searchByName(String query) async {
    _checkConnection();
    return _students.values
        .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<int> count() async {
    _checkConnection();
    return _students.length;
  }

  @override
  Future<bool> clear() async {
    _checkConnection();
    _students.clear();
    return true;
  }

  @override
  Future<void> close() async {
    _isConnected = false;
    _students.clear();
  }
}
