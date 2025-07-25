# Complete FooBar Tutorial

**Complete workflow tutorial for students learning database operations with Dart and PocketBase.**

## 🎯 Learning Objectives

After completing this tutorial, students will understand:
- Data modeling with Dart classes
- Database schema creation
- CRUD operations (Create, Read, Update, Delete)
- Import/export functionality
- Error handling and testing

## 🚀 Step-by-Step Tutorial

### Step 1: Understanding the Data Model

```dart
// lib/foobar.dart - Simple data structure
final foobar = FooBar(foo: 'Hello', bar: 42);
final json = foobar.toJson(); // Convert to JSON
final restored = FooBar.fromJson(json); // Restore from JSON
```

**Key Concepts**: Object-oriented programming, JSON serialization, immutable data

### Step 2: Setting Up the Database

```bash
# Run once to create the database collection
dart run lib/foobar_create_collection.dart
```

**Key Concepts**: Database schema, authentication, access control

### Step 3: Basic CRUD Operations

```dart
// lib/foobar_crud.dart - Essential database operations
final pb = PocketBase('http://127.0.0.1:8090');
final crud = FooBarCrudService(pb);

// Create
final newRecord = await crud.create(FooBar(foo: 'Test', bar: 123));

// Read
final record = await crud.getById(newRecord.id);
final allRecords = await crud.getAll();

// Update
final updated = await crud.update(record.id, FooBar(foo: 'Updated', bar: 456));

// Delete
await crud.delete(record.id);
```

**Key Concepts**: Asynchronous programming, exception handling, database operations

### Step 4: Advanced Operations

```dart
// lib/foobar_utility.dart - Bulk operations and utilities
final utility = FooBarUtility(crud);

// Create sample data
await utility.createSampleJsonFile('sample.json');

// Import data
await utility.importFromJsonFile('sample.json');

// Count records
final count = await utility.count();
print('Database contains $count records');

// Export backup
await utility.exportToJsonFile('backup.json');
```

**Key Concepts**: File I/O, bulk operations, data validation

## 🧪 Testing Your Understanding

### Exercise 1: Basic Operations
```dart
// Create a FooBar with your name and age
final myData = FooBar(foo: 'Your Name', bar: 20);

// Save to database and retrieve it
final saved = await crud.create(myData);
final retrieved = await crud.getById(saved.id);

// Verify they're the same
assert(retrieved.foo == myData.foo);
assert(retrieved.bar == myData.bar);
```

### Exercise 2: Search and Filter
```dart
// Create test data
await crud.create(FooBar(foo: 'Apple', bar: 1));
await crud.create(FooBar(foo: 'Banana', bar: 2));
await crud.create(FooBar(foo: 'Cherry', bar: 3));

// Search for fruits containing 'a'
final results = await crud.searchByFoo('a');
// Should find 'Apple' and 'Banana'
```

### Exercise 3: Import/Export
```dart
// Create a JSON file with your favorite foods
final foods = [
  {'foo': 'Pizza', 'bar': 10},
  {'foo': 'Burger', 'bar': 8},
  {'foo': 'Salad', 'bar': 6}
];

// Save to file and import to database
// Then export and compare files
```

## 🔧 Common Patterns

### Error Handling Pattern
```dart
try {
  final result = await crud.getById('some_id');
  // Handle success
} catch (e) {
  if (e.toString().contains('not found')) {
    // Handle missing record
  } else {
    // Handle other errors
  }
}
```

### Pagination Pattern
```dart
const pageSize = 10;
int currentPage = 1;

while (true) {
  final page = await crud.getRecord(currentPage, pageSize);
  if (page.isEmpty) break;
  
  // Process page
  for (final item in page) {
    print('${item.foo}: ${item.bar}');
  }
  
  currentPage++;
}
```

### Backup Pattern
```dart
// Regular backup routine
final timestamp = DateTime.now().millisecondsSinceEpoch;
final backupPath = await utility.backupDatabase('backups/');
print('Backup created: $backupPath');

// Restore if needed
// await utility.importFromJsonFile(backupPath);
```

## 🎓 Key Takeaways

1. **Separation of Concerns**: Each module has a specific responsibility
   - Model: Data structure
   - Setup: Database configuration  
   - CRUD: Basic operations
   - Utility: Advanced features

2. **Type Safety**: Dart's type system helps catch errors at compile time

3. **Async/Await**: Database operations are asynchronous and must be awaited

4. **Error Handling**: Always wrap database operations in try-catch blocks

5. **Testing**: Write tests to verify your code works correctly

## 📚 Next Steps

1. **Add Validation**: Enhance the FooBar model with field validation
2. **Add More Fields**: Extend the model with additional properties
3. **Add Relationships**: Link FooBar records to other collections
4. **Add Authentication**: Implement user-specific data access
5. **Add UI**: Create a Flutter app that uses these modules

## 🔗 Module Documentation

- [Data Model (foobar.dart)](./foobar.md)
- [Collection Setup (foobar_create_collection.dart)](./foobar_create_collection.md)
- [CRUD Operations (foobar_crud.dart)](./foobar_crud.md)
- [Utility Functions (foobar_utility.dart)](./foobar_utility.md)
