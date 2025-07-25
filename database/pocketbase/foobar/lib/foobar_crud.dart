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

  /// READ: Get paginated FooBar records from the database
  /// Returns a list of FooBar objects
  Future<List<FooBar>> getRecord([int page = 1, int perPage = 5]) async {
    try {
      // Get paginated list (ResultList wrapper object)
      final resultList = await _pb
          .collection(_collectionName)
          .getList(page: page, perPage: perPage);

      return resultList.items
          .map((record) => FooBar.fromJson(record.data))
          .toList();
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

  /// DELETE ALL: Remove all FooBar records from the database
  /// WARNING: This is a destructive operation that cannot be undone!
  /// Uses pagination to handle large datasets efficiently
  /// Prints total number of deleted records for confirmation
  Future<void> deleteAllRecords() async {
    try {
      int page = 1;
      const int perPage = 10;
      int totalDeleted = 0;

      // Process records in batches to avoid memory issues with large datasets
      while (true) {
        final result = await _pb
            .collection(_collectionName)
            .getList(page: page, perPage: perPage);

        // If no more records, break the loop
        if (result.items.isEmpty) break;

        // Delete each record in the current batch
        for (final item in result.items) {
          await _pb.collection(_collectionName).delete(item.id);
          totalDeleted++;
        }
      }
      print('Total records deleted: $totalDeleted');
    } catch (e) {
      throw Exception('Failed to delete all FooBar records: $e');
    }
  }
}
