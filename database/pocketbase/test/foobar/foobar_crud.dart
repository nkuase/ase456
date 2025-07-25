import 'package:pocketbase/pocketbase.dart';
import 'foobar.dart';

/// CRUD Service for FooBar collection
/// This class provides simple Create, Read, Update, Delete operations
class FooBarCrudService {
  final PocketBase _pb;
  static const String _collectionName = 'foobar';

  /// Constructor: Initialize with PocketBase instance
  FooBarCrudService(this._pb);

  /// CREATE: Add a new FooBar record to the database
  /// Returns the created FooBar with its generated ID
  Future<FooBar> create(FooBar foobar) async {
    try {
      // Convert FooBar object to JSON and send to PocketBase
      final record = await _pb.collection(_collectionName).create(
            body: foobar.toJson(),
          );

      // Convert the returned record back to FooBar object
      return FooBar.fromJson(record.data);
    } catch (e) {
      throw Exception('Failed to create FooBar: $e');
    }
  }

  /// READ: Get a single FooBar record by ID
  /// Returns the FooBar object if found, throws exception if not found
  Future<FooBar> getById(String id) async {
    try {
      // Fetch record from PocketBase using the ID
      final record = await _pb.collection(_collectionName).getOne(id);

      // Convert record data to FooBar object
      return FooBar.fromJson(record.data);
    } catch (e) {
      throw Exception('Failed to get FooBar with ID $id: $e');
    }
  }

  /// READ: Get all FooBar records from the database
  /// Returns a list of all FooBar objects
  Future<List<FooBar>> getAll() async {
    try {
      // Fetch all records from the collection
      final resultList = await _pb.collection(_collectionName).getFullList();

      // Convert each record to FooBar object and return as list
      return resultList.map((record) => FooBar.fromJson(record.data)).toList();
    } catch (e) {
      throw Exception('Failed to get all FooBar records: $e');
    }
  }

  /// READ: Search FooBar records with filtering
  /// Example usage: searchByFoo("hello") returns all records where foo contains "hello"
  Future<List<FooBar>> searchByFoo(String searchTerm) async {
    try {
      // Use PocketBase filter syntax to search
      final resultList = await _pb.collection(_collectionName).getFullList(
            filter: 'foo ~ "$searchTerm"', // ~ means "contains"
          );

      return resultList.map((record) => FooBar.fromJson(record.data)).toList();
    } catch (e) {
      throw Exception('Failed to search FooBar records: $e');
    }
  }

  /// UPDATE: Modify an existing FooBar record
  /// Requires the record ID and the updated FooBar data
  Future<FooBar> update(String id, FooBar updatedFoobar) async {
    try {
      // Send updated data to PocketBase
      final record = await _pb.collection(_collectionName).update(
            id,
            body: updatedFoobar.toJson(),
          );

      // Return the updated FooBar object
      return FooBar.fromJson(record.data);
    } catch (e) {
      throw Exception('Failed to update FooBar with ID $id: $e');
    }
  }

  /// DELETE: Remove a FooBar record from the database
  /// Returns true if deletion was successful
  Future<bool> delete(String id) async {
    try {
      // Delete the record from PocketBase
      await _pb.collection(_collectionName).delete(id);
      return true;
    } catch (e) {
      throw Exception('Failed to delete FooBar with ID $id: $e');
    }
  }

  /// UTILITY: Count total number of FooBar records
  /// Useful for pagination or statistics
  Future<int> count() async {
    try {
      final result = await _pb.collection(_collectionName).getFullList();
      return result.length;
    } catch (e) {
      throw Exception('Failed to count FooBar records: $e');
    }
  }

  /// UTILITY: Check if a FooBar record exists by ID
  /// Returns true if the record exists, false otherwise
  Future<bool> exists(String id) async {
    try {
      await _pb.collection(_collectionName).getOne(id);
      return true;
    } catch (e) {
      return false; // Record doesn't exist
    }
  }
}

/// Example usage and testing
void main() async {
  // Initialize PocketBase client
  final pb = PocketBase('http://127.0.0.1:8090');

  // Create CRUD service instance
  final foobarService = FooBarCrudService(pb);

  try {
    // Example 1: CREATE a new FooBar
    print('=== Creating a new FooBar ===');
    final newFoobar = FooBar(foo: 'Hello World', bar: 42);
    final createdFoobar = await foobarService.create(newFoobar);
    print('Created: ${createdFoobar.foo}, ${createdFoobar.bar}');

    // Example 2: READ by ID (you would use the actual ID from creation)
    // print('=== Reading FooBar by ID ===');
    // final foundFoobar = await foobarService.getById('actual_record_id');
    // print('Found: ${foundFoobar.foo}, ${foundFoobar.bar}');

    // Example 3: READ all FooBars
    print('=== Reading all FooBars ===');
    final allFoobars = await foobarService.getAll();
    print('Total records: ${allFoobars.length}');
    for (final foobar in allFoobars) {
      print('- ${foobar.foo}: ${foobar.bar}');
    }

    // Example 4: SEARCH FooBars
    print('=== Searching FooBars ===');
    final searchResults = await foobarService.searchByFoo('Hello');
    print('Search results: ${searchResults.length}');

    // Example 5: COUNT records
    print('=== Counting FooBars ===');
    final totalCount = await foobarService.count();
    print('Total FooBar records: $totalCount');
  } catch (e) {
    print('Error: $e');
  }
}
