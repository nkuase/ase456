import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'foobar.dart';
import 'foobar_crud.dart';

/// Utility class for importing/exporting FooBar data between JSON and IndexedDB
/// This class demonstrates how to handle bulk data operations in the browser
class FooBarUtility {
  final FooBarCrudService _crudService;

  /// Constructor: Initialize with CRUD service
  FooBarUtility(this._crudService);

  /// IMPORT: Read JSON content and upload FooBar records to IndexedDB
  ///
  /// Expected JSON format:
  /// [
  ///   {"foo": "value1", "bar": 123},
  ///   {"foo": "value2", "bar": 456}
  /// ]
  ///
  /// Returns the number of successfully imported records
  Future<int> importFromJsonString(String jsonString) async {
    try {
      print('Starting import from JSON string');
      print('JSON size: ${jsonString.length} characters');

      // Step 1: Parse JSON string to List
      final dynamic jsonData = jsonDecode(jsonString);

      // Cast to List<dynamic> with proper type checking
      if (jsonData is! List) {
        throw Exception('JSON must contain an array of objects');
      }

      final List<dynamic> jsonList = jsonData as List<dynamic>;
      print('JSON parsed successfully, found ${jsonList.length} records');

      // Step 2: Convert each JSON object to FooBar and upload to database
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

      print('\\n=== Import Summary ===');
      print('Total records in JSON: ${jsonList.length}');
      print('Successfully imported: $successCount');
      print('Failed to import: $failureCount');

      return successCount;
    } catch (e) {
      throw Exception('Failed to import from JSON string: $e');
    }
  }

  /// IMPORT: Handle file upload and import from JSON file
  /// This method creates a file input element and handles the file selection
  Future<int> importFromJsonFile() async {
    try {
      print('Opening file dialog for JSON import...');

      // Create file input element
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = '.json';

      // Create a completer to handle the async file selection
      final Completer<int> completer = Completer<int>();

      // Handle file selection
      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files!.isEmpty) {
          completer.complete(0);
          return;
        }

        try {
          final file = files[0];
          print('Selected file: ${file.name} (${file.size} bytes)');

          // Read file content
          final reader = html.FileReader();
          reader.readAsText(file);

          reader.onLoadEnd.listen((e) async {
            try {
              final jsonString = reader.result as String;
              final importCount = await importFromJsonString(jsonString);
              completer.complete(importCount);
            } catch (e) {
              completer.completeError(e);
            }
          });

          reader.onError.listen((e) {
            completer.completeError('Failed to read file: ${reader.error}');
          });

        } catch (e) {
          completer.completeError(e);
        }
      });

      // Trigger file dialog
      uploadInput.click();

      return await completer.future;
    } catch (e) {
      throw Exception('Failed to import from JSON file: $e');
    }
  }

  /// EXPORT: Read all FooBar records from IndexedDB and download as JSON file
  ///
  /// Creates a JSON file with all database records in the format:
  /// [
  ///   {"foo": "value1", "bar": 123},
  ///   {"foo": "value2", "bar": 456}
  /// ]
  ///
  /// Returns the number of exported records
  Future<int> exportToJsonFile([String fileName = 'foobar_export.json']) async {
    try {
      print('Starting export to: $fileName');

      // Step 1: Get all FooBar records from database
      final allFoobars = await _crudService.getAll();
      print('Retrieved ${allFoobars.length} records from database');

      // Step 2: Convert FooBar objects to JSON maps (excluding auto-generated IDs)
      final List<Map<String, dynamic>> jsonList = [];
      for (final foobar in allFoobars) {
        final jsonMap = foobar.toJson();
        // Remove ID for clean export (IDs are auto-generated)
        jsonMap.remove('id');
        jsonList.add(jsonMap);
      }

      // Step 3: Convert to JSON string with pretty formatting
      final jsonString = JsonEncoder.withIndent('  ').convert(jsonList);
      print('JSON string created, size: ${jsonString.length} characters');

      // Step 4: Create download link and trigger download
      final blob = html.Blob([jsonString], 'application/json');
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      // Clean up
      html.Url.revokeObjectUrl(url);

      print('\\n=== Export Summary ===');
      print('Records exported: ${allFoobars.length}');
      print('File name: $fileName');
      print('File size: ${jsonString.length} characters');

      return allFoobars.length;
    } catch (e) {
      throw Exception('Failed to export to JSON file: $e');
    }
  }

  /// UTILITY: Create a sample JSON file for testing
  /// This method creates and downloads a sample JSON file with test data
  Future<void> createSampleJsonFile([String fileName = 'foobar_sample.json']) async {
    try {
      // Sample FooBar data
      final sampleData = [
        {'foo': 'Hello World', 'bar': 42},
        {'foo': 'Dart Programming', 'bar': 100},
        {'foo': 'IndexedDB Tutorial', 'bar': 75},
        {'foo': 'JSON Import', 'bar': 200},
        {'foo': 'Browser Database', 'bar': 150},
      ];

      // Convert to pretty JSON
      final jsonString = JsonEncoder.withIndent('  ').convert(sampleData);

      // Create download
      final blob = html.Blob([jsonString], 'application/json');
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      // Clean up
      html.Url.revokeObjectUrl(url);

      print('Sample JSON file created: $fileName');
      print('Contains ${sampleData.length} sample records');
    } catch (e) {
      throw Exception('Failed to create sample JSON file: $e');
    }
  }

  /// UTILITY: Backup database to JSON file with timestamp
  /// Creates a backup file with current date and time
  Future<String> backupDatabase() async {
    try {
      // Create backup filename with timestamp
      final now = DateTime.now();
      final timestamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
      final backupFileName = 'foobar_backup_$timestamp.json';

      // Export to backup file
      final recordCount = await exportToJsonFile(backupFileName);

      print('\\n=== Backup Complete ===');
      print('Backup file: $backupFileName');
      print('Records backed up: $recordCount');

      return backupFileName;
    } catch (e) {
      throw Exception('Failed to backup database: $e');
    }
  }

  /// UTILITY: Clear all records from database
  /// WARNING: This will delete all FooBar records!
  Future<int> clearDatabase() async {
    try {
      print('WARNING: Clearing all FooBar records from IndexedDB!');

      // Get count before deletion
      final count = await _crudService.count();

      // Delete all records
      await _crudService.deleteAllRecords();

      print('Cleared $count records from database');
      return count;
    } catch (e) {
      throw Exception('Failed to clear database: $e');
    }
  }

  /// UTILITY: Count total number of FooBar records
  /// Useful for pagination or statistics
  Future<int> count() async {
    try {
      return await _crudService.count();
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

  /// UTILITY: Get database statistics
  /// Returns useful information about the database
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final allRecords = await _crudService.getAll();
      final totalCount = allRecords.length;

      if (totalCount == 0) {
        return {
          'totalRecords': 0,
          'averageBar': 0,
          'minBar': 0,
          'maxBar': 0,
          'uniqueFooValues': 0,
        };
      }

      final barValues = allRecords.map((f) => f.bar).toList();
      final fooValues = allRecords.map((f) => f.foo).toSet();

      final averageBar = barValues.reduce((a, b) => a + b) / barValues.length;
      final minBar = barValues.reduce((a, b) => a < b ? a : b);
      final maxBar = barValues.reduce((a, b) => a > b ? a : b);

      return {
        'totalRecords': totalCount,
        'averageBar': averageBar.round(),
        'minBar': minBar,
        'maxBar': maxBar,
        'uniqueFooValues': fooValues.length,
      };
    } catch (e) {
      throw Exception('Failed to get database statistics: $e');
    }
  }

  /// UTILITY: Import sample data into the database
  /// Creates some sample FooBar records for testing
  Future<int> importSampleData() async {
    try {
      final sampleJson = '''
      [
        {"foo": "Hello World", "bar": 42},
        {"foo": "Dart Programming", "bar": 100},
        {"foo": "IndexedDB Tutorial", "bar": 75},
        {"foo": "JSON Import", "bar": 200},
        {"foo": "Browser Database", "bar": 150}
      ]
      ''';

      return await importFromJsonString(sampleJson);
    } catch (e) {
      throw Exception('Failed to import sample data: $e');
    }
  }
}
