import 'dart:async';
import 'dart:html' as html;
import 'dart:convert';
import 'foobar.dart';
import 'foobar_crud.dart';

/// Utility class for importing/exporting FooBar data between JSON and IndexedDB
/// This class demonstrates how to handle bulk data operations in the browser
class FooBarUtility {
  final FooBarCrudService _crudService;

  /// Constructor: Initialize with CRUD service
  FooBarUtility(this._crudService);

  /// IMPORT: Read JSON from user-selected file and upload FooBar records to database
  /// 
  /// Opens a file picker dialog for the user to select a JSON file
  /// Expected JSON format:
  /// [
  ///   {"foo": "value1", "bar": 123},
  ///   {"foo": "value2", "bar": 456}
  /// ]
  ///
  /// Returns the number of successfully imported records
  Future<int> importFromJsonFile() async {
    try {
      print('Opening file picker for JSON import...');
      
      // Create file input element
      final fileInput = html.FileInputElement()
        ..accept = 'application/json,.json';
      
      // Create completer to wait for file selection
      final completer = Completer<html.File>();
      
      // Listen for file selection
      fileInput.onChange.listen((event) {
        final files = fileInput.files;
        if (files != null && files.isNotEmpty) {
          completer.complete(files.first);
        } else {
          completer.completeError('No file selected');
        }
      });
      
      // Trigger file picker
      fileInput.click();
      
      // Wait for file selection
      final file = await completer.future;
      print('File selected: ${file.name}');
      
      // Read file contents
      final reader = html.FileReader();
      final readerCompleter = Completer<String>();
      
      reader.onLoadEnd.listen((event) {
        final result = reader.result;
        if (result is String) {
          readerCompleter.complete(result);
        } else {
          readerCompleter.completeError('Failed to read file as text');
        }
      });
      
      reader.onError.listen((event) {
        readerCompleter.completeError('Error reading file');
      });
      
      reader.readAsText(file);
      final jsonString = await readerCompleter.future;
      print('File read successfully, size: ${jsonString.length} characters');
      
      // Parse JSON string to List
      final dynamic jsonData = jsonDecode(jsonString);
      
      if (jsonData is! List) {
        throw Exception('JSON file must contain an array of objects');
      }
      
      final List<dynamic> jsonList = jsonData;
      print('JSON parsed successfully, found ${jsonList.length} records');
      
      // Convert each JSON object to FooBar and upload to database
      int successCount = 0;
      int failureCount = 0;
      
      for (int i = 0; i < jsonList.length; i++) {
        try {
          // Convert JSON map to FooBar object
          final Map<String, dynamic> jsonMap = jsonList[i] as Map<String, dynamic>;
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

  /// EXPORT: Read all FooBar records from database and download as JSON file
  ///
  /// Creates a JSON file with all database records and triggers download
  /// Output format:
  /// [
  ///   {"foo": "value1", "bar": 123},
  ///   {"foo": "value2", "bar": 456}
  /// ]
  ///
  /// Returns the number of exported records
  Future<int> exportToJsonFile([String filename = 'foobar_export.json']) async {
    try {
      print('Starting export to: $filename');
      
      // Get all FooBar records from database
      final allFoobars = await _crudService.getAll();
      print('Retrieved ${allFoobars.length} records from database');
      
      // Convert FooBar objects to JSON maps (without IDs for compatibility)
      final List<Map<String, dynamic>> jsonList = [];
      for (final foobar in allFoobars) {
        jsonList.add(foobar.toJsonWithoutId());
      }
      
      // Convert to JSON string with pretty formatting
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);
      print('JSON string created, size: ${jsonString.length} characters');
      
      // Create blob and download link
      final blob = html.Blob([jsonString], 'application/json');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // Create download link and trigger download
      final anchor = html.AnchorElement()
        ..href = url
        ..download = filename
        ..style.display = 'none';
      
      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
      
      // Clean up the URL
      html.Url.revokeObjectUrl(url);
      
      print('\n=== Export Summary ===');
      print('Records exported: ${allFoobars.length}');
      print('File name: $filename');
      print('File size: ${jsonString.length} characters');
      
      return allFoobars.length;
    } catch (e) {
      throw Exception('Failed to export to JSON file: $e');
    }
  }

  /// UTILITY: Create and download a sample JSON file for testing
  /// This method creates a sample JSON file with test data
  Future<void> createSampleJsonFile([String filename = 'foobar_sample.json']) async {
    try {
      // Sample FooBar data
      final sampleData = [
        {'foo': 'Hello World', 'bar': 42},
        {'foo': 'Dart Programming', 'bar': 100},
        {'foo': 'Database Tutorial', 'bar': 75},
        {'foo': 'JSON Import', 'bar': 200},
        {'foo': 'IndexedDB Demo', 'bar': 150},
      ];
      
      // Convert to pretty JSON
      final jsonString = const JsonEncoder.withIndent('  ').convert(sampleData);
      
      // Create blob and download
      final blob = html.Blob([jsonString], 'application/json');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      final anchor = html.AnchorElement()
        ..href = url
        ..download = filename
        ..style.display = 'none';
      
      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
      
      html.Url.revokeObjectUrl(url);
      
      print('Sample JSON file created: $filename');
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
      final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}_'
          '${now.hour.toString().padLeft(2, '0')}'
          '${now.minute.toString().padLeft(2, '0')}'
          '${now.second.toString().padLeft(2, '0')}';
      final backupFileName = 'foobar_backup_$timestamp.json';
      
      // Export to backup file
      final recordCount = await exportToJsonFile(backupFileName);
      
      print('\n=== Backup Complete ===');
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
      print('WARNING: Clearing all FooBar records from database!');
      
      // Get count before clearing
      final beforeCount = await count();
      
      // Clear all records
      await _crudService.deleteAllRecords();
      
      print('Database cleared. Deleted $beforeCount records.');
      return beforeCount;
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

  /// UTILITY: Import from JSON string (useful for programmatic import)
  /// Similar to importFromJsonFile but accepts a JSON string directly
  Future<int> importFromJsonString(String jsonString) async {
    try {
      // Parse JSON string to List
      final dynamic jsonData = jsonDecode(jsonString);
      
      if (jsonData is! List) {
        throw Exception('JSON must contain an array of objects');
      }
      
      final List<dynamic> jsonList = jsonData;
      
      // Convert each JSON object to FooBar and upload to database
      int successCount = 0;
      
      for (final item in jsonList) {
        try {
          final Map<String, dynamic> jsonMap = item as Map<String, dynamic>;
          final foobar = FooBar.fromJson(jsonMap);
          await _crudService.create(foobar);
          successCount++;
        } catch (e) {
          print('Failed to import record: $e');
        }
      }
      
      return successCount;
    } catch (e) {
      throw Exception('Failed to import from JSON string: $e');
    }
  }

  /// UTILITY: Export to JSON string (useful for programmatic export)
  /// Returns all records as a JSON string
  Future<String> exportToJsonString() async {
    try {
      final allFoobars = await _crudService.getAll();
      final jsonList = allFoobars.map((f) => f.toJsonWithoutId()).toList();
      return const JsonEncoder.withIndent('  ').convert(jsonList);
    } catch (e) {
      throw Exception('Failed to export to JSON string: $e');
    }
  }
}
