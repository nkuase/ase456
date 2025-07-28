import 'package:firebase_core/firebase_core.dart';
import 'models/foobar.dart';
import 'services/foobar_crud_firebase.dart';

/// Main entry point for the Firebase CRUD demonstration
/// This file provides a simple example of using Firebase CRUD operations
Future<void> main() async {
  print('🎓 Firebase CRUD Operations - Educational Demo');
  print('=' * 50);

  try {
    // Initialize Firebase (for real Firebase usage)
    // Note: This requires firebase_options.dart file which is platform-specific
    // For this demo, we'll use comments to show where initialization would go
    
    print('📱 Initializing Firebase...');
    
    // Uncomment these lines when using real Firebase:
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    
    // For this demo, we'll create the service without real Firebase
    print('   ⚠️  Demo mode: Using simulated Firebase operations');
    print('   💡 To use real Firebase, uncomment initialization code');
    
    // Initialize the CRUD service
    // For real Firebase, just use: FooBarCrudFirebase()
    final crudService = FooBarCrudFirebase();

    // Demonstrate basic CRUD operations
    await demonstrateBasicCRUD(crudService);
    
  } catch (e) {
    print('❌ Error: $e');
    print('💡 Note: This demo requires Firebase setup for full functionality');
    print('   For testing, run: dart test (uses fake Firebase)');
  }
}

/// Demonstrates basic CRUD operations in a simple workflow
Future<void> demonstrateBasicCRUD(FooBarCrudFirebase crudService) async {
  try {
    // 1. CREATE - Add new documents
    print('\n📝 Creating sample documents...');
    final id1 = await crudService.create(FooBar(foo: 'Student', bar: 2024));
    final id2 = await crudService.create(FooBar(foo: 'Teacher', bar: 2023));
    final id3 = await crudService.create(FooBar(foo: 'Course', bar: 456));

    print('   ✓ Created documents with IDs: $id1, $id2, $id3');

    // 2. READ - Retrieve and display all documents
    print('\n📖 Reading all documents...');
    final allRecords = await crudService.readAll();
    for (final record in allRecords) {
      print('   📄 ID: ${record.id}, foo: "${record.foo}", bar: ${record.bar}');
      if (record.createdAt != null) {
        print('      📅 Created: ${record.createdAt}');
      }
    }
    print('   ✓ Found ${allRecords.length} total documents');

    // 3. READ - Get a specific document
    print('\n🔍 Reading specific document (ID: $id2)...');
    final specificRecord = await crudService.read(id2);
    if (specificRecord != null) {
      print('   ✓ Found: "${specificRecord.foo}" with bar: ${specificRecord.bar}');
    }

    // 4. UPDATE - Modify an existing document
    print('\n✏️  Updating document (ID: $id1)...');
    final updatedFooBar = FooBar(foo: 'Updated Student', bar: 2025);
    final updateSuccess = await crudService.update(id1, updatedFooBar);

    if (updateSuccess) {
      print('   ✓ Update successful');
      final updated = await crudService.read(id1);
      if (updated != null) {
        print('   📄 New values: "${updated.foo}", bar: ${updated.bar}');
      }
    }

    // 5. COUNT - Show statistics
    print('\n📊 Database statistics...');
    final totalCount = await crudService.count();
    print('   ✓ Total documents: $totalCount');

    // 6. SEARCH - Find documents by exact match
    print('\n🔎 Searching for documents with foo = "Teacher"...');
    final searchResults = await crudService.findByFoo('Teacher');
    print('   ✓ Found ${searchResults.length} matching documents:');
    for (final record in searchResults) {
      print('     📄 "${record.foo}" (bar: ${record.bar})');
    }

    // 7. RANGE QUERY - Find documents by bar value range
    print('\n📈 Finding documents with bar between 400 and 2024...');
    final rangeResults = await crudService.findByBarRange(400, 2024);
    print('   ✓ Found ${rangeResults.length} documents in range:');
    for (final record in rangeResults) {
      print('     📄 "${record.foo}" (bar: ${record.bar})');
    }

    // 8. BATCH CREATE - Create multiple documents at once
    print('\n📦 Creating batch of documents...');
    final batchFooBars = [
      FooBar(foo: 'Batch Item 1', bar: 100),
      FooBar(foo: 'Batch Item 2', bar: 200),
      FooBar(foo: 'Batch Item 3', bar: 300),
    ];
    final batchIds = await crudService.createBatch(batchFooBars);
    print('   ✓ Created ${batchIds.length} documents in batch');

    // 9. UPDATE FIELDS - Update specific fields only
    print('\n🔧 Updating specific fields...');
    final fieldUpdateSuccess = await crudService.updateFields(id2, {
      'bar': 9999,
      'description': 'Field update example'
    });
    if (fieldUpdateSuccess) {
      print('   ✓ Field update successful');
    }

    // 10. PAGINATION - Demonstrate paginated reading
    print('\n📄 Reading paginated results (limit: 3)...');
    final paginatedResults = await crudService.readPaginated(limit: 3);
    print('   ✓ Retrieved ${paginatedResults.length} documents (first page)');

    // 11. DELETE - Remove a specific document
    print('\n🗑️  Deleting document (ID: $id3)...');
    final deleteSuccess = await crudService.delete(id3);
    if (deleteSuccess) {
      print('   ✓ Delete successful');
      final remainingCount = await crudService.count();
      print('   📊 Documents remaining: $remainingCount');
    }

    print('\n🎉 Firebase CRUD demonstration completed successfully!');
    await showComparisonWithSQLite();
    
  } catch (e) {
    print('❌ Demo error: $e');
    print('💡 This is expected when running without real Firebase setup');
  }
}

/// Shows comparison between Firebase and SQLite approaches
Future<void> showComparisonWithSQLite() async {
  print('\n🔄 Firebase vs SQLite Comparison:');
  print('=' * 40);
  
  print('\n📊 Data Storage:');
  print('   SQLite: Relational tables with rows/columns');
  print('   Firebase: NoSQL documents with JSON structure');
  
  print('\n🔍 Queries:');
  print('   SQLite: SQL with JOIN, LIKE, complex conditions');
  print('   Firebase: Limited queries, no JOINs, simple conditions');
  
  print('\n🌐 Connectivity:');
  print('   SQLite: Local file, works offline');
  print('   Firebase: Cloud-based, real-time sync, offline support');
  
  print('\n⚡ Real-time Updates:');
  print('   SQLite: Manual refresh needed');
  print('   Firebase: Automatic real-time synchronization');
  
  print('\n🔒 Security:');
  print('   SQLite: File-level security');
  print('   Firebase: Rule-based security, authentication');
  
  print('\n💡 Next steps:');
  print('   • Run comprehensive tests: dart test');
  print('   • Compare with SQLite version side-by-side');
  print('   • Try real-time streams with Firebase');
  print('   • Explore Firebase security rules');
}
