import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:pocketbase/pocketbase.dart';

// Get the directory where this Dart script is located
String get scriptDirectory {
  final script = Platform.script;
  if (script.scheme == 'file') {
    return File(script.toFilePath()).parent.path;
  }
  return Directory.current.path;
}

// PocketBase client configuration
const String email = 'goodbye@gmail.com';
const String password = '12345678';

// Initialize PocketBase client
final pb = PocketBase('http://127.0.0.1:8090');

/// Helper function to generate random data object
/// This mimics the JavaScript Math.random() behavior
Map<String, dynamic> randomData() {
  final random = Random();

  // Generate random string equivalent to Math.random().toString(36).substring(2, 10)
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final randomString = String.fromCharCodes(
    Iterable.generate(8, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
  );

  // Generate random integer equivalent to Math.floor(Math.random() * 1000)
  final randomInt = random.nextInt(1000);

  return {'foo': randomString, 'bar': randomInt};
}

// =============================================================================
// # 1. CREATE OPERATIONS
// =============================================================================

// #1. Upload a single random record
Future<void> uploadRecord() async {
  final record = {'data': randomData()};
  try {
    final created = await pb.collection('records').create(body: record);
    print('Record uploaded: $created');
  } catch (err) {
    print('Error uploading record: $err');
  }
}

// #2. Upload records from a local JSON file
Future<void> uploadFromJson() async {
  try {
    final filePath = './data.json'; // Adjust to your actual file location
    final file = File(filePath);
    final fileContent = await file.readAsString();
    final List<dynamic> records = jsonDecode(fileContent);

    for (final record in records) {
      final created = await pb.collection('records').create(body: record);
      print('Created record: $created');
    }
    print('All records imported successfully.');
  } catch (error) {
    print('Error importing records: $error');
  }
}

// =============================================================================
// # 2. READ OPERATIONS
// =============================================================================

/// Get records from PocketBase with pagination
/// [page] - The page number (1-based)
/// [perPage] - Number of records per page
Future<RecordModel?> getRecord([int page = 1, int perPage = 5]) async {
  try {
    print('📖 Fetching records (page: $page, perPage: $perPage)...');

    // Get a list of records with pagination
    final result = await pb
        .collection('records')
        .getList(page: page, perPage: perPage);

    print('   Found ${result.items.length} records on this page');
    print('   Total records: ${result.totalItems}');

    if (result.items.isNotEmpty) {
      final firstRecord = result.items[0];
      print('   ✅ First record: ID=${firstRecord.id}');
      print('   Record data: ${firstRecord.data}');
      return firstRecord;
    } else {
      print('   ⚠️  No records found.');
      return null;
    }
  } catch (err) {
    print('❌ Error getting record: $err');
    return null;
  }
}

// =============================================================================
// # 3. UPDATE OPERATIONS
// =============================================================================

/// Update a record by modifying its data field
Future<void> updateRecord(RecordModel recordToUpdate) async {
  print('\n✏️  Updating record ${recordToUpdate.id}...');

  try {
    print('   Current record data: ${recordToUpdate.data}');

    // Check what fields actually exist in the record
    final availableFields = recordToUpdate.data.keys.toList();
    print('   Available fields: $availableFields');

    if (availableFields.isEmpty) {
      print('   ❌ Cannot update: Record has no data fields');
      print(
        '   💡 This means the collection schema doesn\'t match your data structure',
      );
      return;
    }

    // Try to update based on available fields
    Map<String, dynamic> updateData = {};

    // Check for nested data structure
    if (recordToUpdate.data.containsKey('data')) {
      final currentData = recordToUpdate.data['data'] as Map<String, dynamic>?;
      final currentFoo = currentData?['foo'] as String? ?? 'unknown';
      final currentBar = currentData?['bar'] as int? ?? 0;

      print('   Current nested foo value: $currentFoo');

      updateData = {
        'data': {'foo': 'P-$currentFoo', 'bar': currentBar},
      };
    }
    // Check for direct foo field
    else if (recordToUpdate.data.containsKey('foo')) {
      final currentFoo = recordToUpdate.data['foo'] as String? ?? 'unknown';
      print('   Current direct foo value: $currentFoo');

      updateData = {'foo': 'P-$currentFoo'};
    }
    // Check for other fields
    else {
      print('   ⚠️  No recognized fields to update');
      return;
    }

    print('   Update data: $updateData');

    final updated = await pb
        .collection('records')
        .update(recordToUpdate.id, body: updateData);
    print('   ✅ Record updated successfully:');
    print('   New data: ${updated.data}');
  } catch (err) {
    print('❌ Error updating record: $err');
  }
}

// =============================================================================
// # 4. DELETE OPERATIONS
// =============================================================================

/// Delete a single record by ID
Future<void> deleteRecord(RecordModel recordToDelete) async {
  print('\n🗑️  Deleting record ${recordToDelete.id}...');

  try {
    await pb.collection('records').delete(recordToDelete.id);
    print('   ✅ Successfully deleted record: ${recordToDelete.id}');
  } catch (err) {
    print('❌ Error deleting record: $err');
  }
}

/// Delete all records in the collection using pagination
/// This function demonstrates batch processing
Future<void> deleteAllRecords() async {
  print('\n🗑️  Deleting all records...');

  int page = 1;
  const int perPage = 10; // Process records in batches
  int totalDeleted = 0;

  while (true) {
    try {
      // Fetch a page of records
      final result = await pb
          .collection('records')
          .getList(page: page, perPage: perPage);

      if (result.items.isEmpty) {
        print('   No more records to delete');
        break;
      }

      print('   Processing batch: ${result.items.length} records');

      // Delete each record in the current page
      for (final item in result.items) {
        await pb.collection('records').delete(item.id);
        totalDeleted++;
        print('   Deleted record $totalDeleted: ${item.id}');
      }

      // If fewer than perPage items returned, we're done
      if (result.items.length < perPage) {
        print('   Reached end of records');
        break;
      }

      // Note: We don't increment page because records shift when deleted
      // So we always query page 1 to get the "new first" records
    } catch (err) {
      print('❌ Error in deleteAllRecords: $err');
      break;
    }
  }

  print('✅ Cleanup complete. Total records deleted: $totalDeleted');
}

// =============================================================================
// MAIN FUNCTION - Demonstrates the full CRUD workflow
// =============================================================================

Future<void> main() async {
  print('🚀 === Dart PocketBase CRUD Test ===\n');

  try {
    // Step 0: Authentication
    print('🔐 Authenticating with PocketBase...');
    await pb.collection('users').authWithPassword(email, password);
    print('✅ Authentication successful\n');

    // Step 1: CREATE operations
    print('📝 === CREATE OPERATIONS ===');
    await uploadRecord();
    await uploadFromJson();

    // Step 2: READ operations
    print('\n📖 === READ OPERATIONS ===');
    final firstRecord = await getRecord();

    if (firstRecord != null) {
      // Step 3: UPDATE operations
      print('\n✏️  === UPDATE OPERATIONS ===');
      await updateRecord(firstRecord);

      // Read the updated record to verify changes
      print('\n📖 Verifying update...');
      final updatedRecord = await getRecord();
      if (updatedRecord != null) {
        print('   Verification: Updated record data: ${updatedRecord.data}');
      }
    }

    // Step 4: DELETE operations
    print('\n🗑️  === DELETE OPERATIONS ===');

    // Delete a specific record (get the second record if available)
    final secondRecord = await getRecord(2, 1);
    if (secondRecord != null) {
      await deleteRecord(secondRecord);
    } else {
      print('   No second record found to delete individually');
    }

    // Clean up: Delete all remaining records (commented out to preserve data)
    // Uncomment the next line if you want to clean up all records
    // await deleteAllRecords();

    print('\n🎉 === CRUD Test Completed ===');
    print('💡 If you saw empty data, check your PocketBase collection schema!');
  } catch (e) {
    print('❌ Fatal error: $e');
    print('   Make sure PocketBase is running on http://127.0.0.1:8090');
    print('   and the user credentials are correct');
    print('   Check that the "records" collection exists with proper fields');
  }
}
