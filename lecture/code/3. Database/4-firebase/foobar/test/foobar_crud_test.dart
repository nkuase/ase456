import 'package:test/test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../lib/models/foobar.dart';
import '../lib/services/foobar_crud_firebase.dart';

void main() {
  // Test Firebase instance using fake_cloud_firestore
  late FooBarCrudFirebase crudService;
  late FakeFirebaseFirestore fakeFirestore;

  // Test data samples
  final testFooBar1 = FooBar(foo: 'Hello', bar: 42);
  final testFooBar2 = FooBar(foo: 'World', bar: 100);
  final testFooBar3 = FooBar(foo: 'Test', bar: 25);

  /// Setup: Run before each test
  setUp(() async {
    // Create a fresh fake Firestore instance for each test
    fakeFirestore = FakeFirebaseFirestore();
    crudService = FooBarCrudFirebase(firestore: fakeFirestore);
  });

  group('FooBarCrudFirebase Tests', () {
    test('CREATE: Should add a new FooBar document', () async {
      // Act: Create a new document
      final id = await crudService.create(testFooBar1);

      // Assert: Check if ID is valid
      expect(id, isNotEmpty);

      // Verify by reading back
      final retrieved = await crudService.read(id);
      expect(retrieved, isNotNull);
      expect(retrieved!.foo, equals(testFooBar1.foo));
      expect(retrieved.bar, equals(testFooBar1.bar));
      expect(retrieved.id, equals(id));
    });

    test('READ: Should retrieve all FooBar documents', () async {
      // Arrange: Insert test data
      await crudService.create(testFooBar1);
      await crudService.create(testFooBar2);
      await crudService.create(testFooBar3);

      // Act: Read all documents
      final allRecords = await crudService.readAll();

      // Assert: Check count and content
      expect(allRecords.length, equals(3));
      expect(allRecords.map((f) => f.foo),
          containsAll(['Hello', 'World', 'Test']));
    });

    test('READ: Should retrieve FooBar by ID', () async {
      // Arrange: Insert a test document
      final id = await crudService.create(testFooBar1);

      // Act: Read by ID
      final retrieved = await crudService.read(id);

      // Assert: Check if correct document is retrieved
      expect(retrieved, isNotNull);
      expect(retrieved!.foo, equals(testFooBar1.foo));
      expect(retrieved.bar, equals(testFooBar1.bar));
      expect(retrieved.id, equals(id));
    });

    test('READ: Should return null for non-existent ID', () async {
      // Act: Try to read non-existent document
      final retrieved = await crudService.read('non-existent-id');

      // Assert: Should be null
      expect(retrieved, isNull);
    });

    test('SEARCH: Should find documents by exact foo field match', () async {
      // Arrange: Insert test data
      await crudService.create(FooBar(foo: 'Hello', bar: 1));
      await crudService.create(FooBar(foo: 'Hello', bar: 2));
      await crudService.create(FooBar(foo: 'Goodbye', bar: 3));

      // Act: Search for documents with exact foo match
      final results = await crudService.findByFoo('Hello');

      // Assert: Should find 2 documents
      expect(results.length, equals(2));
      expect(results.every((f) => f.foo == 'Hello'), isTrue);
    });

    test('SEARCH: Should find documents by foo field containing text', () async {
      // Arrange: Insert test data
      await crudService.create(FooBar(foo: 'Hello World', bar: 1));
      await crudService.create(FooBar(foo: 'Hello Universe', bar: 2));
      await crudService.create(FooBar(foo: 'Goodbye', bar: 3));

      // Act: Search for documents containing "Hello"
      final results = await crudService.findByFooContains('Hello');

      // Assert: Should find 2 documents
      expect(results.length, equals(2));
      expect(results.every((f) => f.foo.contains('Hello')), isTrue);
    });

    test('SEARCH: Should find documents by bar range', () async {
      // Arrange: Insert test data with different bar values
      await crudService.create(FooBar(foo: 'Low', bar: 10));
      await crudService.create(FooBar(foo: 'Medium', bar: 50));
      await crudService.create(FooBar(foo: 'High', bar: 100));

      // Act: Search for documents with bar between 25 and 75
      final results = await crudService.findByBarRange(25, 75);

      // Assert: Should find 1 document (bar = 50)
      expect(results.length, equals(1));
      expect(results.first.bar, equals(50));
      expect(results.first.foo, equals('Medium'));
    });

    test('UPDATE: Should update existing FooBar document', () async {
      // Arrange: Insert a test document
      final id = await crudService.create(testFooBar1);
      final updatedFooBar = FooBar(foo: 'Updated', bar: 999);

      // Act: Update the document
      final success = await crudService.update(id, updatedFooBar);

      // Assert: Check if update was successful
      expect(success, isTrue);

      // Verify by reading back
      final retrieved = await crudService.read(id);
      expect(retrieved!.foo, equals('Updated'));
      expect(retrieved.bar, equals(999));
    });

    test('UPDATE: Should return false for non-existent document', () async {
      // Act: Try to update non-existent document
      final success = await crudService.update('non-existent-id', testFooBar1);

      // Assert: Should return false
      expect(success, isFalse);
    });

    test('UPDATE: Should update specific fields only', () async {
      // Arrange: Insert a test document
      final id = await crudService.create(testFooBar1);

      // Act: Update specific fields
      final success = await crudService.updateFields(id, {
        'bar': 777,
        'description': 'Test description'
      });

      // Assert: Check if update was successful
      expect(success, isTrue);

      // Verify by reading back
      final retrieved = await crudService.read(id);
      expect(retrieved!.foo, equals(testFooBar1.foo)); // Should remain unchanged
      expect(retrieved.bar, equals(777)); // Should be updated
    });

    test('DELETE: Should delete FooBar document by ID', () async {
      // Arrange: Insert a test document
      final id = await crudService.create(testFooBar1);

      // Act: Delete the document
      final success = await crudService.delete(id);

      // Assert: Check if deletion was successful
      expect(success, isTrue);

      // Verify by trying to read
      final retrieved = await crudService.read(id);
      expect(retrieved, isNull);
    });

    test('DELETE: Should return false for non-existent document', () async {
      // Act: Try to delete non-existent document
      final success = await crudService.delete('non-existent-id');

      // Assert: Should return false
      expect(success, isFalse);
    });

    test('DELETE ALL: Should delete all documents', () async {
      // Arrange: Insert multiple test documents
      await crudService.create(testFooBar1);
      await crudService.create(testFooBar2);
      await crudService.create(testFooBar3);

      // Act: Delete all documents
      final deletedCount = await crudService.deleteAll();

      // Assert: Check if all documents were deleted
      expect(deletedCount, equals(3));

      // Verify by counting
      final count = await crudService.count();
      expect(count, equals(0));
    });

    test('COUNT: Should return correct count of documents', () async {
      // Arrange: Insert test documents
      await crudService.create(testFooBar1);
      await crudService.create(testFooBar2);

      // Act: Get count
      final count = await crudService.count();

      // Assert: Should have 2 documents
      expect(count, equals(2));
    });

    test('EXISTS: Should check if document exists', () async {
      // Arrange: Insert a test document
      final id = await crudService.create(testFooBar1);

      // Act & Assert: Check existence
      expect(await crudService.exists(id), isTrue);
      expect(await crudService.exists('non-existent-id'), isFalse);
    });

    test('BATCH CREATE: Should create multiple documents at once', () async {
      // Arrange: Prepare batch data
      final batchFooBars = [
        FooBar(foo: 'Batch 1', bar: 100),
        FooBar(foo: 'Batch 2', bar: 200),
        FooBar(foo: 'Batch 3', bar: 300),
      ];

      // Act: Create batch
      final ids = await crudService.createBatch(batchFooBars);

      // Assert: Check if all documents were created
      expect(ids.length, equals(3));
      
      // Verify by reading all
      final allDocs = await crudService.readAll();
      expect(allDocs.length, equals(3));
      expect(allDocs.map((f) => f.foo), 
          containsAll(['Batch 1', 'Batch 2', 'Batch 3']));
    });

    test('PAGINATION: Should return limited results', () async {
      // Arrange: Insert multiple test documents
      for (int i = 1; i <= 10; i++) {
        await crudService.create(FooBar(foo: 'Item $i', bar: i));
      }

      // Act: Get paginated results
      final paginatedResults = await crudService.readPaginated(limit: 3);

      // Assert: Should return exactly 3 documents
      expect(paginatedResults.length, equals(3));
    });

    test('STREAMS: Should stream all documents in real-time', () async {
      // Arrange: Insert initial document
      await crudService.create(testFooBar1);

      // Act: Listen to stream
      final streamResult = await crudService.streamAll().first;

      // Assert: Should contain the initial document
      expect(streamResult.length, equals(1));
      expect(streamResult.first.foo, equals(testFooBar1.foo));
    });

    test('STREAMS: Should stream specific document by ID', () async {
      // Arrange: Insert a test document
      final id = await crudService.create(testFooBar1);

      // Act: Listen to document stream
      final streamResult = await crudService.streamById(id).first;

      // Assert: Should receive the correct document
      expect(streamResult, isNotNull);
      expect(streamResult!.foo, equals(testFooBar1.foo));
      expect(streamResult.id, equals(id));
    });

    test('INTEGRATION: Complete CRUD workflow', () async {
      // This test demonstrates a complete Firebase workflow

      // 1. CREATE: Insert a document
      final id = await crudService.create(testFooBar1);
      expect(id, isNotEmpty);

      // 2. READ: Verify it exists
      final created = await crudService.read(id);
      expect(created, isNotNull);
      expect(created!.foo, equals(testFooBar1.foo));

      // 3. UPDATE: Modify the document
      final updatedFooBar = FooBar(foo: 'Modified', bar: 777);
      final updateSuccess = await crudService.update(id, updatedFooBar);
      expect(updateSuccess, isTrue);

      // 4. READ: Verify the update
      final updated = await crudService.read(id);
      expect(updated!.foo, equals('Modified'));
      expect(updated.bar, equals(777));

      // 5. DELETE: Remove the document
      final deleteSuccess = await crudService.delete(id);
      expect(deleteSuccess, isTrue);

      // 6. READ: Verify deletion
      final deleted = await crudService.read(id);
      expect(deleted, isNull);
    });

    test('ERROR HANDLING: Should handle operations gracefully', () async {
      // Test that we can perform operations even with empty database
      final allRecords = await crudService.readAll();
      expect(allRecords, isEmpty);

      final count = await crudService.count();
      expect(count, equals(0));

      final nonExistent = await crudService.read('non-existent');
      expect(nonExistent, isNull);
    });

    test('FIREBASE FEATURES: Document ID and timestamps', () async {
      // Arrange & Act: Create a document
      final id = await crudService.create(testFooBar1);
      final retrieved = await crudService.read(id);

      // Assert: Check Firebase-specific features
      expect(retrieved!.id, isNotEmpty);
      expect(retrieved.id, equals(id));
      // Note: createdAt testing depends on fake_cloud_firestore implementation
    });

    test('COMPARISON: Firebase vs SQLite differences', () async {
      // This test demonstrates key differences between Firebase and SQLite

      print('\n📝 Key Differences Demonstrated:');
      
      // 1. Document IDs vs Auto-increment
      final id = await crudService.create(testFooBar1);
      expect(id, isA<String>()); // Firebase uses string IDs
      print('   ✓ Firebase uses string document IDs');

      // 2. NoSQL structure vs Relational
      final doc = await crudService.read(id);
      expect(doc!.toMap(), isA<Map<String, dynamic>>());
      print('   ✓ Firebase stores documents as JSON/Map structures');

      // 3. Real-time capabilities
      final stream = crudService.streamAll();
      expect(stream, isA<Stream<List<FooBar>>>());
      print('   ✓ Firebase provides real-time streams');

      // 4. Cloud vs Local
      print('   ✓ Firebase is cloud-based (vs SQLite local files)');
      
      // 5. Query limitations
      print('   ✓ Firebase has query limitations (no complex JOINs)');
      
      print('   💡 Both have their strengths for different use cases!');
    });
  });
}
