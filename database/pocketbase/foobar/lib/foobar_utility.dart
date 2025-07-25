import 'dart:io';
import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';
import 'foobar.dart';
import 'foobar_crud.dart';

/// Utility class for importing/exporting FooBar data between JSON files and database
/// This class demonstrates how to handle bulk data operations
class FooBarUtility {
  final FooBarCrudService _crudService;

  /// Constructor: Initialize with CRUD service
  FooBarUtility(this._crudService);

  /// IMPORT: Read JSON file and upload FooBar records to database
  ///
  /// Expected JSON format:
  /// [
  ///   {"foo": "value1", "bar": 123},
  ///   {"foo": "value2", "bar": 456}
  /// ]
  ///
  /// Returns the number of successfully imported records
  Future<int> importFromJsonFile(String filePath) async {
    try {
      print('Starting import from: $filePath');

      // Step 1: Check if file exists
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      // Step 2: Read file contents
      final jsonString = await file.readAsString();
      print('File read successfully, size: ${jsonString.length} characters');

      // Step 3: Parse JSON string to List
      final dynamic jsonData = jsonDecode(jsonString);

      // Cast to List<dynamic> with proper type checking
      if (jsonData is! List) {
        throw Exception('JSON file must contain an array of objects');
      }

      final List<dynamic> jsonList = jsonData as List<dynamic>;
      print('JSON parsed successfully, found ${jsonList.length} records');

      // Step 4: Convert each JSON object to FooBar and upload to database
      int successCount = 0;
      int failureCount = 0;

      for (int i = 0; i < jsonList.length; i++) {
        try {
          // Convert JSON map to FooBar object
          final Map<String, dynamic> jsonMap =
              jsonList[i] as Map<String, dynamic>;
          final foobar = FooBar.fromJson(jsonMap);

          // Upload to database using CRUD service
          await _crudService.create(foobar);
          successCount++;

          print('✓ Record ${i + 1}: ${foobar.foo} - ${foobar.bar}');
        } catch (e) {
          failureCount++;
          print('✗ Failed to import record ${i + 1}: $e');
        }
      }

      print('\n=== Import Summary ===');
      print('Total records in file: ${jsonList.length}');
      print('Successfully imported: $successCount');
      print('Failed to import: $failureCount');

      return successCount;
    } catch (e) {
      throw Exception('Failed to import from JSON file: $e');
    }
  }

  /// EXPORT: Read all FooBar records from database and write to JSON file
  ///
  /// Creates a JSON file with all database records in the format:
  /// [
  ///   {"foo": "value1", "bar": 123},
  ///   {"foo": "value2", "bar": 456}
  /// ]
  ///
  /// Returns the number of exported records
  Future<int> exportToJsonFile(String filePath) async {
    try {
      print('Starting export to: $filePath');

      // Step 1: Get all FooBar records from database
      final allFoobars = await _crudService.getAll();
      print('Retrieved ${allFoobars.length} records from database');

      // Step 2: Convert FooBar objects to JSON maps
      final List<Map<String, dynamic>> jsonList = [];
      for (final foobar in allFoobars) {
        jsonList.add(foobar.toJson());
      }

      // Step 3: Convert to JSON string with pretty formatting
      final jsonString = JsonEncoder.withIndent('  ').convert(jsonList);
      print('JSON string created, size: ${jsonString.length} characters');

      // Step 4: Write to file
      final file = File(filePath);

      // Create directory if it doesn't exist
      final directory = file.parent;
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        print('Created directory: ${directory.path}');
      }

      await file.writeAsString(jsonString);
      print('File written successfully');

      print('\n=== Export Summary ===');
      print('Records exported: ${allFoobars.length}');
      print('File location: $filePath');
      print('File size: ${jsonString.length} characters');

      return allFoobars.length;
    } catch (e) {
      throw Exception('Failed to export to JSON file: $e');
    }
  }

  /// UTILITY: Create a sample JSON file for testing
  /// This method creates a sample JSON file with test data
  Future<void> createSampleJsonFile(String filePath) async {
    try {
      // Sample FooBar data
      final sampleData = [
        {'foo': 'Hello World', 'bar': 42},
        {'foo': 'Dart Programming', 'bar': 100},
        {'foo': 'Database Tutorial', 'bar': 75},
        {'foo': 'JSON Import', 'bar': 200},
        {'foo': 'PocketBase Demo', 'bar': 150},
      ];

      // Convert to pretty JSON
      final jsonString = JsonEncoder.withIndent('  ').convert(sampleData);

      // Write to file
      final file = File(filePath);
      final directory = file.parent;
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      await file.writeAsString(jsonString);
      print('Sample JSON file created: $filePath');
      print('Contains ${sampleData.length} sample records');
    } catch (e) {
      throw Exception('Failed to create sample JSON file: $e');
    }
  }

  /// UTILITY: Backup database to JSON file with timestamp
  /// Creates a backup file with current date and time
  Future<String> backupDatabase(String backupDirectory) async {
    try {
      // Create backup filename with timestamp
      final now = DateTime.now();
      final timestamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
      final backupFileName = 'foobar_backup_$timestamp.json';
      final backupPath = '$backupDirectory/$backupFileName';

      // Export to backup file
      final recordCount = await exportToJsonFile(backupPath);

      print('\n=== Backup Complete ===');
      print('Backup file: $backupFileName');
      print('Records backed up: $recordCount');

      return backupPath;
    } catch (e) {
      throw Exception('Failed to backup database: $e');
    }
  }

  /// UTILITY: Clear all records from database
  /// WARNING: This will delete all FooBar records!
  Future<int> clearDatabase() async {
    try {
      print('WARNING: Clearing all FooBar records from database!');

      // Get all records first
      final allFoobars = await _crudService.getAll();
      int deletedCount = 0;

      // Delete each record
      for (final foobar in allFoobars) {
        try {
          // Note: We need the record ID to delete, but our FooBar model doesn't include it
          // In a real application, you'd modify the model to include the ID
          // For now, we'll get all records and delete them using the database directly
          print(
              'Note: To fully implement clearDatabase, the FooBar model needs to include record ID');
          break; // Exit for now
        } catch (e) {
          print('Failed to delete record: $e');
        }
      }

      return deletedCount;
    } catch (e) {
      throw Exception('Failed to clear database: $e');
    }
  }

  /// UTILITY: Count total number of FooBar records
  /// Useful for pagination or statistics
  Future<int> count() async {
    try {
      final allRecords = await _crudService.getAll();
      return allRecords.length;
    } catch (e) {
      throw Exception('Failed to count FooBar records: $e');
    }
  }

  /// UTILITY: Check if a FooBar record exists by ID
  /// Returns true if the record exists, false otherwise
  Future<bool> exists(String id) async {
    try {
      await _crudService.getById(id);
      return true;
    } catch (e) {
      return false; // Record doesn't exist
    }
  }
}
