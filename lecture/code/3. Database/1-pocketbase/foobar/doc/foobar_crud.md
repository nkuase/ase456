# FooBar CRUD Operations

**File**: `lib/foobar_crud.dart`  
**Purpose**: Provide basic Create, Read, Update, Delete operations for FooBar records.

## 📋 Overview

The `FooBarCrudService` class encapsulates all database operations for FooBar records. It provides a clean, type-safe interface between your application and the PocketBase database.

## 🔧 Features

- ✅ **Complete CRUD**: Create, Read, Update, Delete operations
- ✅ **Type Safety**: Uses `FooBar` model for all operations
- ✅ **Error Handling**: Comprehensive exception handling
- ✅ **Pagination**: Built-in pagination support
- ✅ **Search**: Text-based search functionality
- ✅ **Bulk Operations**: Delete all records functionality

## 💡 Usage Examples

### Basic Setup

```dart
import 'package:pocketbase/pocketbase.dart';
import 'lib/foobar_crud.dart';
import 'lib/foobar.dart';

final pb = PocketBase('http://127.0.0.1:8090');
final crudService = FooBarCrudService(pb);
```

### Create Operation

```dart
// Create a new record
final newFoobar = FooBar(foo: 'Hello World', bar: 42);
final createdFoobar = await crudService.create(newFoobar);

print('Created record with ID: ${createdFoobar.id}');
```

### Read Operations

```dart
// Get single record by ID
final foobar = await crudService.getById('record_id_here');
print('Found: ${foobar.foo} - ${foobar.bar}');

// Get all records
final allFoobars = await crudService.getAll();
print('Total records: ${allFoobars.length}');

// Get paginated records
final page1 = await crudService.getRecord(1, 5); // page 1, 5 items
final page2 = await crudService.getRecord(2, 5); // page 2, 5 items

// Search by foo field
final searchResults = await crudService.searchByFoo('Hello');
print('Found ${searchResults.length} records containing "Hello"');
```

### Update Operation

```dart
// Update existing record
final updatedData = FooBar(foo: 'Updated Text', bar: 100);
final result = await crudService.update('record_id_here', updatedData);

print('Updated: ${result.foo} - ${result.bar}');
```

### Delete Operations

```dart
// Delete single record
final success = await crudService.delete('record_id_here');
if (success) {
  print('Record deleted successfully');
}

// Delete ALL records (⚠️ DESTRUCTIVE!)
await crudService.deleteAllRecords();
print('All records deleted');
```

## 🎯 Method Reference

### CREATE Operations

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `create()` | `FooBar foobar` | `Future<FooBar>` | Create new record |

### READ Operations

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `getById()` | `String id` | `Future<FooBar>` | Get single record by ID |
| `getAll()` | none | `Future<List<FooBar>>` | Get all records |
| `getRecord()` | `int page, int perPage` | `Future<List<FooBar>>` | Get paginated records |
| `searchByFoo()` | `String searchTerm` | `Future<List<FooBar>>` | Search records by foo field |

### UPDATE Operations

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `update()` | `String id, FooBar foobar` | `Future<FooBar>` | Update existing record |

### DELETE Operations

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `delete()` | `String id` | `Future<bool>` | Delete single record |
| `deleteAllRecords()` | none | `Future<void>` | ⚠️ Delete ALL records |

## 🚨 Error Handling

All methods throw `Exception` with descriptive messages:

```dart
try {
  final foobar = await crudService.getById('invalid_id');
} catch (e) {
  print('Error: $e'); // "Failed to get FooBar with ID invalid_id: ..."
}
```

## ⚡ Performance Tips

### Pagination for Large Datasets

```dart
// Instead of loading all records
final allRecords = await crudService.getAll(); // Could be slow!

// Use pagination
final page = await crudService.getRecord(1, 20); // Load 20 at a time
```

### Efficient Search

```dart
// Search is case-insensitive and uses "contains" logic
final results = await crudService.searchByFoo('test');
// Matches: "test", "Test", "testing", "My test", etc.
```

## 🔐 Authentication

```dart
// Most operations require authentication
await pb.collection('users').authWithPassword('user@example.com', 'password');

// Now CRUD operations will work
final foobar = await crudService.create(newFoobar);
```

## 🧪 Testing

```dart
// For testing, handle connection errors gracefully
try {
  final count = await crudService.getAll();
} catch (e) {
  if (e.toString().contains('Failed to get all FooBar records')) {
    // Handle database connection error
    print('Database not available for testing');
  }
}
```

## 🔗 Related Modules

- **[foobar.dart](./foobar.md)**: Data model used by all operations
- **[foobar_create_collection.dart](./foobar_create_collection.md)**: Setup required before using CRUD
- **[foobar_utility.dart](./foobar_utility.md)**: Uses this service for advanced operations
