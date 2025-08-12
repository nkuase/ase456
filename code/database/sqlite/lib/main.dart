import 'models/foobar.dart';
import 'services/foobar_crud_sqlite.dart';

/// Main entry point for the SQLite CRUD demonstration
/// This file provides a simple example of using the CRUD operations
Future<void> main() async {
  print('🎓 SQLite CRUD Operations - Educational Demo');
  print('=' * 50);

  // Initialize the CRUD service
  final crudService = FooBarCrudSQLite();

  try {
    // Demonstrate basic CRUD operations
    await demonstrateBasicCRUD(crudService);
  } catch (e) {
    print('❌ Error: $e');
  } finally {
    // Always clean up resources
    await crudService.close();
    print('\n✅ Database connection closed');
  }
}

/// Demonstrates basic CRUD operations in a simple workflow
Future<void> demonstrateBasicCRUD(FooBarCrudSQLite crudService) async {
  // 1. CREATE - Add new records
  print('\n📝 Creating sample records...');
  final id1 = await crudService.create(FooBar(foo: 'Student', bar: 2024));
  final id2 = await crudService.create(FooBar(foo: 'Teacher', bar: 2023));
  final id3 = await crudService.create(FooBar(foo: 'Course', bar: 456));

  print('   ✓ Created records with IDs: $id1, $id2, $id3');

  // 2. READ - Retrieve and display all records
  print('\n📖 Reading all records...');
  final allRecords = await crudService.readAll();
  for (final record in allRecords) {
    print('   📄 foo: "${record.foo}", bar: ${record.bar}');
  }
  print('   ✓ Found ${allRecords.length} total records');

  // 3. READ - Get a specific record
  print('\n🔍 Reading specific record (ID: $id2)...');
  final specificRecord = await crudService.read(id2);
  if (specificRecord != null) {
    print(
        '   ✓ Found: "${specificRecord.foo}" with bar: ${specificRecord.bar}');
  }

  // 4. UPDATE - Modify an existing record
  print('\n✏️  Updating record (ID: $id1)...');
  final updatedFooBar = FooBar(foo: 'Updated Student', bar: 2025);
  final updateSuccess = await crudService.update(id1, updatedFooBar);

  if (updateSuccess) {
    print('   ✓ Update successful');
    final updated = await crudService.read(id1);
    print('   📄 New values: "${updated!.foo}", bar: ${updated.bar}');
  }

  // 5. COUNT - Show statistics
  print('\n📊 Database statistics...');
  final totalCount = await crudService.count();
  print('   ✓ Total records: $totalCount');

  // 6. SEARCH - Find records containing specific text
  print('\n🔎 Searching for records containing "e"...');
  final searchResults = await crudService.findByFoo('e');
  print('   ✓ Found ${searchResults.length} matching records:');
  for (final record in searchResults) {
    print('     📄 "${record.foo}" (bar: ${record.bar})');
  }

  // 7. DELETE - Remove a specific record
  print('\n🗑️  Deleting record (ID: $id3)...');
  final deleteSuccess = await crudService.delete(id3);
  if (deleteSuccess) {
    print('   ✓ Delete successful');
    final remainingCount = await crudService.count();
    print('   📊 Records remaining: $remainingCount');
  }

  print('\n🎉 CRUD demonstration completed successfully!');
  print('\n💡 Next steps:');
  print(
      '   • Run the comprehensive demo: dart run lib/examples/crud_demo.dart');
  print('   • Run the tests: dart test');
  print('   • Read the tutorial: doc/crud_tutorial.md');
}
