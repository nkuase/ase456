import 'dart:io';
import 'package:test/test.dart';
import '../lib/models/foobar.dart';
import '../lib/services/foobar_crud_sqlite.dart';

void main() {
  // Test database instance
  late FooBarCrudSQLite crudService;

  // Test data samples
  final testFooBar1 = FooBar(foo: 'Hello', bar: 42);
  final testFooBar2 = FooBar(foo: 'World', bar: 100);
  final testFooBar3 = FooBar(foo: 'Test', bar: 25);

  /// Setup: Run before all tests
  setUpAll(() async {
    // Ensure data directory exists
    final dataDir = Directory('data');
    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }
  });

  /// Setup: Run before each test
  setUp(() async {
    crudService = FooBarCrudSQLite();
    // Clean up any existing test data
    await crudService.deleteAll();
  });

  /// Cleanup: Run after each test
  tearDown(() async {
    await crudService.close();
    // Remove test database file
    final dbFile = File('data/foobar.db');
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
  });

  group('FooBarCrudSQLite Tests', () {
    test('CREATE: Should insert a new FooBar record', () async {
      // Act: Create a new record
      final id = await crudService.create(testFooBar1);

      // Assert: Check if ID is valid
      expect(id, greaterThan(0));

      // Verify by reading back
      final retrieved = await crudService.read(id);
      expect(retrieved, isNotNull);
      expect(retrieved!.foo, equals(testFooBar1.foo));
      expect(retrieved.bar, equals(testFooBar1.bar));
    });

    test('READ: Should retrieve all FooBar records', () async {
      // Arrange: Insert test data
      await crudService.create(testFooBar1);
      await crudService.create(testFooBar2);
      await crudService.create(testFooBar3);

      // Act: Read all records
      final allRecords = await crudService.readAll();

      // Assert: Check count and content
      expect(allRecords.length, equals(3));
      expect(allRecords.map((f) => f.foo),
          containsAll(['Hello', 'World', 'Test']));
    });

    test('READ: Should retrieve FooBar by ID', () async {
      // Arrange: Insert a test record
      final id = await crudService.create(testFooBar1);

      // Act: Read by ID
      final retrieved = await crudService.read(id);

      // Assert: Check if correct record is retrieved
      expect(retrieved, isNotNull);
      expect(retrieved!.foo, equals(testFooBar1.foo));
      expect(retrieved.bar, equals(testFooBar1.bar));
    });

    test('READ: Should return null for non-existent ID', () async {
      // Act: Try to read non-existent record
      final retrieved = await crudService.read(999);

      // Assert: Should be null
      expect(retrieved, isNull);
    });

    test('SEARCH: Should find records by foo field', () async {
      // Arrange: Insert test data
      await crudService.create(FooBar(foo: 'Hello World', bar: 1));
      await crudService.create(FooBar(foo: 'Hello Universe', bar: 2));
      await crudService.create(FooBar(foo: 'Goodbye', bar: 3));

      // Act: Search for records containing "Hello"
      final results = await crudService.findByFoo('Hello');

      // Assert: Should find 2 records
      expect(results.length, equals(2));
      expect(results.every((f) => f.foo.contains('Hello')), isTrue);
    });

    test('UPDATE: Should update existing FooBar record', () async {
      // Arrange: Insert a test record
      final id = await crudService.create(testFooBar1);
      final updatedFooBar = FooBar(foo: 'Updated', bar: 999);

      // Act: Update the record
      final success = await crudService.update(id, updatedFooBar);

      // Assert: Check if update was successful
      expect(success, isTrue);

      // Verify by reading back
      final retrieved = await crudService.read(id);
      expect(retrieved!.foo, equals('Updated'));
      expect(retrieved.bar, equals(999));
    });

    test('UPDATE: Should return false for non-existent record', () async {
      // Act: Try to update non-existent record
      final success = await crudService.update(999, testFooBar1);

      // Assert: Should return false
      expect(success, isFalse);
    });

    test('DELETE: Should delete FooBar record by ID', () async {
      // Arrange: Insert a test record
      final id = await crudService.create(testFooBar1);

      // Act: Delete the record
      final success = await crudService.delete(id);

      // Assert: Check if deletion was successful
      expect(success, isTrue);

      // Verify by trying to read
      final retrieved = await crudService.read(id);
      expect(retrieved, isNull);
    });

    test('DELETE: Should return false for non-existent record', () async {
      // Act: Try to delete non-existent record
      final success = await crudService.delete(999);

      // Assert: Should return false
      expect(success, isFalse);
    });

    test('DELETE ALL: Should delete all records', () async {
      // Arrange: Insert multiple test records
      await crudService.create(testFooBar1);
      await crudService.create(testFooBar2);
      await crudService.create(testFooBar3);

      // Act: Delete all records
      final deletedCount = await crudService.deleteAll();

      // Assert: Check if all records were deleted
      expect(deletedCount, equals(3));

      // Verify by counting
      final count = await crudService.count();
      expect(count, equals(0));
    });

    test('COUNT: Should return correct count of records', () async {
      // Arrange: Insert test records
      await crudService.create(testFooBar1);
      await crudService.create(testFooBar2);

      // Act: Get count
      final count = await crudService.count();

      // Assert: Should have 2 records
      expect(count, equals(2));
    });

    test('EXISTS: Should check if record exists', () async {
      // Arrange: Insert a test record
      final id = await crudService.create(testFooBar1);

      // Act & Assert: Check existence
      expect(await crudService.exists(id), isTrue);
      expect(await crudService.exists(999), isFalse);
    });

    test('INTEGRATION: Complete CRUD workflow', () async {
      // This test demonstrates a complete workflow

      // 1. CREATE: Insert a record
      final id = await crudService.create(testFooBar1);
      expect(id, greaterThan(0));

      // 2. READ: Verify it exists
      final created = await crudService.read(id);
      expect(created, isNotNull);
      expect(created!.foo, equals(testFooBar1.foo));

      // 3. UPDATE: Modify the record
      final updatedFooBar = FooBar(foo: 'Modified', bar: 777);
      final updateSuccess = await crudService.update(id, updatedFooBar);
      expect(updateSuccess, isTrue);

      // 4. READ: Verify the update
      final updated = await crudService.read(id);
      expect(updated!.foo, equals('Modified'));
      expect(updated.bar, equals(777));

      // 5. DELETE: Remove the record
      final deleteSuccess = await crudService.delete(id);
      expect(deleteSuccess, isTrue);

      // 6. READ: Verify deletion
      final deleted = await crudService.read(id);
      expect(deleted, isNull);
    });

    test('ERROR HANDLING: Should handle database operations gracefully',
        () async {
      // Test that we can perform operations even with empty database
      final allRecords = await crudService.readAll();
      expect(allRecords, isEmpty);

      final count = await crudService.count();
      expect(count, equals(0));

      final nonExistent = await crudService.read(1);
      expect(nonExistent, isNull);
    });
  });
}
