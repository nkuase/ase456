# FooBar Utility Functions

**File**: `lib/foobar_utility.dart`  
**Purpose**: Advanced operations including import/export, bulk operations, and utility functions.

## 📋 Overview

The `FooBarUtility` class provides high-level operations that combine basic CRUD functionality to perform complex tasks like data import/export, backup operations, and database utilities.

## 🔧 Features

- ✅ **JSON Import/Export**: Bulk data transfer between files and database
- ✅ **Database Backup**: Automated backup with timestamps
- ✅ **Sample Data Generation**: Create test data quickly
- ✅ **Count & Exists**: Utility functions for data verification
- ✅ **Error Handling**: Comprehensive error reporting with progress tracking

## 💡 Usage Examples

### Basic Setup

```dart
import 'package:pocketbase/pocketbase.dart';
import 'lib/foobar_crud.dart';
import 'lib/foobar_utility.dart';

final pb = PocketBase('http://127.0.0.1:8090');
final crudService = FooBarCrudService(pb);
final utility = FooBarUtility(crudService);
```

### Import/Export Operations

```dart
// Create sample data file
await utility.createSampleJsonFile('sample_data.json');

// Import data from JSON file
final importedCount = await utility.importFromJsonFile('sample_data.json');
print('Imported $importedCount records');

// Export all data to JSON file
final exportedCount = await utility.exportToJsonFile('exported_data.json');
print('Exported $exportedCount records');
```

### Backup Operations

```dart
// Create timestamped backup
final backupPath = await utility.backupDatabase('backups/');
print('Backup created: $backupPath');
// Output: backups/foobar_backup_20240125_143022.json
```

### Utility Functions

```dart
// Count total records
final totalRecords = await utility.count();
print('Total records in database: $totalRecords');

// Check if record exists
final exists = await utility.exists('record_id_here');
if (exists) {
  print('Record exists!');
} else {
  print('Record not found');
}
```

## 🎯 Method Reference

### Import/Export Operations

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `importFromJsonFile()` | `String filePath` | `Future<int>` | Import JSON data to database |
| `exportToJsonFile()` | `String filePath` | `Future<int>` | Export database to JSON file |
| `createSampleJsonFile()` | `String filePath` | `Future<void>` | Create sample test data |

### Backup Operations

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `backupDatabase()` | `String backupDirectory` | `Future<String>` | Create timestamped backup |

### Utility Functions

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `count()` | none | `Future<int>` | Count total records |
| `exists()` | `String id` | `Future<bool>` | Check if record exists |
| `clearDatabase()` | none | `Future<int>` | ⚠️ Clear all records |

## 📄 JSON Format

The utility expects and generates JSON in this format:

```json
[
  {"foo": "Hello World", "bar": 42},
  {"foo": "Test Data", "bar": 123},
  {"foo": "Sample Text", "bar": 999}
]
```

## 💡 Detailed Examples

### Complete Import/Export Workflow

```dart
// 1. Create sample data for testing
await utility.createSampleJsonFile('test_data.json');

// 2. Import to database
try {
  final imported = await utility.importFromJsonFile('test_data.json');
  print('✅ Successfully imported $imported records');
} catch (e) {
  print('❌ Import failed: $e');
}

// 3. Verify data
final count = await utility.count();
print('📊 Database now contains $count records');

// 4. Export for backup
final exported = await utility.exportToJsonFile('backup.json');
print('💾 Exported $exported records to backup');
```

### Error Handling with Progress Tracking

```dart
Future<void> importWithProgress(String filePath) async {
  try {
    print('🚀 Starting import from: $filePath');
    
    final importedCount = await utility.importFromJsonFile(filePath);
    
    print('✅ Import completed successfully!');
    print('📊 Total imported: $importedCount records');
    
    // Verify import
    final totalCount = await utility.count();
    print('🔍 Total records in database: $totalCount');
    
  } catch (e) {
    print('❌ Import failed: $e');
    // Handle specific error types
    if (e.toString().contains('File not found')) {
      print('💡 Please ensure the file exists and path is correct');
    }
  }
}
```

### Batch Operations

```dart
// Process multiple files
final files = ['data1.json', 'data2.json', 'data3.json'];
int totalImported = 0;

for (final file in files) {
  try {
    final count = await utility.importFromJsonFile(file);
    totalImported += count;
    print('✅ $file: $count records imported');
  } catch (e) {
    print('❌ $file: Failed to import - $e');
  }
}

print('📊 Total imported across all files: $totalImported');
```

### Database Maintenance

```dart
// Create daily backup
final now = DateTime.now();
final backupDir = 'backups/${now.year}/${now.month.toString().padLeft(2, '0')}';

final backupPath = await utility.backupDatabase(backupDir);
print('📦 Daily backup created: $backupPath');

// Check database health
final recordCount = await utility.count();
if (recordCount == 0) {
  print('⚠️ Warning: Database is empty');
  // Restore from backup if needed
  await utility.importFromJsonFile('latest_backup.json');
}
```

## 🚨 Error Scenarios

### Common Errors and Solutions

```dart
// File not found
try {
  await utility.importFromJsonFile('missing_file.json');
} catch (e) {
  // Error: File not found: missing_file.json
  print('Solution: Check file path and ensure file exists');
}

// Invalid JSON format
try {
  await utility.importFromJsonFile('invalid.json');
} catch (e) {
  // Error: JSON file must contain an array of objects
  print('Solution: Ensure JSON is an array of {foo, bar} objects');
}

// Network/Database error
try {
  await utility.count();
} catch (e) {
  // Error: Failed to count FooBar records: ...
  print('Solution: Check PocketBase server connection');
}
```

## ⚡ Performance Notes

- **Large Files**: Import processes records one by one with progress reporting
- **Memory Usage**: Export uses streaming for large datasets
- **Network**: Each record is sent individually (could be optimized for bulk)

## 🔗 Related Modules

- **[foobar.dart](./foobar.md)**: Data model used in all operations
- **[foobar_crud.dart](./foobar_crud.md)**: Underlying CRUD service used by utility
- **[foobar_create_collection.dart](./foobar_create_collection.md)**: Required setup before using utility
