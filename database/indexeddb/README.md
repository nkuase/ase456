# IndexedDB Student Management System

A comprehensive example of using IndexedDB for browser-based student data management with a consistent database service interface.

## 🌟 Features

- **Browser-native storage** - No server required
- **Offline-first** - Works without internet connection
- **Transaction support** - Ensures data consistency
- **Index-based queries** - Fast searches on non-key fields
- **Consistent API** - Same interface as SQLite and Firebase implementations

## 🚀 Quick Start

### Prerequisites

- Dart SDK 3.0.0 or higher
- A modern web browser that supports IndexedDB

### Installation

1. Navigate to the IndexedDB directory:
```bash
cd database/indexeddb
```

2. Get dependencies:
```bash
dart pub get
```

3. Run the example:
```bash
dart run example_usage.dart
```

## 📁 Project Structure

```
indexeddb/
├── indexeddb_service.dart    # Main IndexedDB implementation
├── example_usage.dart        # Usage examples and demos
├── pubspec.yaml             # Dependencies
└── README.md               # This file
```

## 🔧 Usage Example

```dart
import 'indexeddb_service.dart';
import '../common/database_service.dart';
import '../common/student.dart';

Future<void> main() async {
  // Create database service
  DatabaseService db = IndexedDBStudentService();
  
  // Initialize database
  await db.initialize();
  
  // Create a student
  final student = Student(
    id: 'S001',
    name: 'Alice Johnson',
    age: 20,
    major: 'Computer Science',
    createdAt: DateTime.now(),
  );
  
  // CRUD operations
  await db.createStudent(student);           // Create
  Student? found = await db.readStudent('S001');  // Read
  await db.updateStudent('S001', {'age': 21});    // Update
  await db.deleteStudent('S001');           // Delete
  
  // Close connection
  await db.close();
}
```

## 🎯 Key Concepts

### Database Operations

| Operation | Method | Description |
|-----------|--------|-------------|
| **Create** | `createStudent(student)` | Add new student to database |
| **Read** | `readStudent(id)` | Get student by ID |
| **Read All** | `readAllStudents()` | Get all students |
| **Update** | `updateStudent(id, updates)` | Update student fields |
| **Delete** | `deleteStudent(id)` | Remove student |
| **Query** | `getStudentsByMajor(major)` | Find students by major |
| **Search** | `searchStudentsByName(name)` | Search by name |

### IndexedDB Specific Features

1. **Object Stores**: Similar to tables in SQL databases
2. **Indexes**: Enable fast searches on non-key fields
3. **Transactions**: Ensure data consistency across operations
4. **Cursors**: Efficiently iterate through large datasets

### Data Conversion

IndexedDB requires conversion between Dart and JavaScript objects:

```dart
// Dart → JavaScript (for storage)
final jsData = jsify(student.toMap());
store.put(jsData, student.id);

// JavaScript → Dart (for retrieval)
final dartData = dartify(result);
final studentMap = Map<String, dynamic>.from(dartData as Map);
final student = Student.fromMap(studentMap);
```

## 🌐 Browser Support

IndexedDB is supported in all modern browsers:

- ✅ Chrome 24+
- ✅ Firefox 16+
- ✅ Safari 7+
- ✅ Edge 12+
- ✅ Mobile browsers

## ⚡ Performance Tips

1. **Use transactions** for multiple operations
2. **Create indexes** on frequently queried fields
3. **Batch operations** when possible
4. **Close cursors** to free up resources

## 🔄 Database Switching

This implementation follows the common `DatabaseService` interface, making it easy to switch between different database technologies:

```dart
// Switch from IndexedDB to SQLite or Firebase
DatabaseService db = IndexedDBStudentService();  // Browser
// DatabaseService db = SQLiteStudentService();     // Desktop/Mobile
// DatabaseService db = FirebaseStudentService();   // Cloud

// Same code works with any implementation!
await db.initialize();
await db.createStudent(student);
```

## 🚧 Limitations

- **Browser only** - Cannot be used in desktop/mobile apps
- **Same-origin policy** - Data isolated per domain
- **Limited queries** - No complex joins or aggregations
- **Storage quotas** - Browser may limit storage size

## 📚 Learn More

- [IndexedDB API Documentation](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
- [IndexedDB Dart Package](https://pub.dev/packages/indexed_db)
- [Browser Storage Comparison](https://web.dev/storage-for-the-web/)

## 🎓 Educational Value

This example demonstrates:

- **Browser database concepts** with IndexedDB
- **Asynchronous programming** with Future/Stream
- **Data serialization** between Dart and JavaScript
- **Transaction management** for data consistency
- **Interface-based design** for code flexibility
