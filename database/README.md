# Database Implementations for ASE456

A comprehensive collection of database implementations demonstrating consistent APIs across different storage technologies. This project showcases how to design database-agnostic applications using interface-based programming.

## 🎯 Learning Objectives

Students will learn:
- **Interface-based design** for database abstraction
- **Different database technologies** and their use cases
- **Consistent API design** across platforms
- **Database switching** without code changes
- **Platform-specific optimizations** while maintaining compatibility

## 🏗️ Project Structure

```
database/
├── common/                          # Shared interfaces and models
│   ├── database_service.dart        # Common database interface
│   └── student.dart                 # Shared student model
├── indexeddb/                       # Browser-based implementation
│   ├── indexeddb_service.dart       # IndexedDB implementation
│   ├── example_usage.dart           # Usage examples
│   ├── pubspec.yaml                 # Dependencies
│   └── README.md                    # IndexedDB-specific docs
├── sqlite/                          # Desktop/mobile implementation  
│   ├── sqlite_service.dart          # SQLite implementation
│   ├── example_usage.dart           # Usage examples
│   ├── pubspec.yaml                 # Dependencies
│   └── README.md                    # SQLite-specific docs
├── firebase/                        # Cloud-based implementation (from lecture)
│   └── ...                          # Firebase implementation files
├── database_switching_demo.dart     # Main switching demonstration
└── README.md                        # This file
```

## 🚀 Quick Start

### Prerequisites

- Dart SDK 3.0.0 or higher
- Choose platform based on database:
  - **SQLite**: Desktop/mobile platforms
  - **IndexedDB**: Web browser
  - **Firebase**: Any platform with internet

### Running Examples

1. **SQLite Example** (Desktop/Mobile):
```bash
cd database/sqlite
dart pub get
dart run example_usage.dart
```

2. **IndexedDB Example** (Browser):
```bash
cd database/indexeddb
dart pub get
dart compile js example_usage.dart
# Open in browser with generated HTML
```

3. **Database Switching Demo**:
```bash
cd database
dart run database_switching_demo.dart
```

## 🔄 The Power of Database Switching

### Same Business Logic, Different Storage

```dart
// Business logic that works with ANY database
Future<void> manageStudents(DatabaseService db) async {
  await db.initialize();
  
  // Create student
  final student = Student(
    id: 'S001',
    name: 'Alice Johnson',
    age: 20,
    major: 'Computer Science',
    createdAt: DateTime.now(),
  );
  await db.createStudent(student);
  
  // Query students
  final csStudents = await db.getStudentsByMajor('Computer Science');
  
  // Update student
  await db.updateStudent('S001', {'age': 21});
  
  await db.close();
}

// Switch databases by changing ONE line!
await manageStudents(SQLiteStudentService());     // Desktop/Mobile
await manageStudents(IndexedDBStudentService());  // Browser
await manageStudents(FirebaseStudentService());   // Cloud
```

## 📊 Database Comparison

| Feature | **SQLite** | **IndexedDB** | **Firebase** |
|---------|------------|---------------|--------------|
| **Platform** | Desktop/Mobile | Browser | Cross-platform |
| **Network** | Local file | Browser storage | Cloud service |
| **Queries** | Full SQL | Key-value + indexes | NoSQL queries |
| **Real-time** | No | No | Yes |
| **Offline** | Always | Always | Smart sync |
| **Complexity** | Low | Medium | Low |
| **Scalability** | Single user | Single user | Multi-user |

## 🎯 When to Use Each Database

### SQLite
**Perfect for:**
- ✅ Desktop applications
- ✅ Mobile applications  
- ✅ Single-user systems
- ✅ Development/prototyping
- ✅ Embedded systems

**Avoid for:**
- ❌ Web browsers
- ❌ Multi-user real-time apps
- ❌ High-concurrency systems

### IndexedDB
**Perfect for:**
- ✅ Browser-only applications
- ✅ Progressive Web Apps (PWAs)
- ✅ Offline-first web apps
- ✅ Client-side caching
- ✅ Browser games

**Avoid for:**
- ❌ Desktop/mobile native apps
- ❌ Server-side applications
- ❌ Complex relational queries

### Firebase
**Perfect for:**
- ✅ Real-time collaborative apps
- ✅ Cross-platform applications
- ✅ Rapid prototyping
- ✅ Apps needing authentication
- ✅ Global scale applications

**Avoid for:**
- ❌ Offline-only applications
- ❌ Complex SQL requirements
- ❌ Cost-sensitive high-volume apps

## 🔧 Common Interface

All database implementations follow the same interface:

```dart
abstract class DatabaseService {
  Future<void> initialize();
  Future<String> createStudent(Student student);
  Future<Student?> readStudent(String id);
  Future<List<Student>> readAllStudents();
  Future<bool> updateStudent(String id, Map<String, dynamic> updates);
  Future<bool> deleteStudent(String id);
  Future<void> clearAllStudents();
  Future<List<Student>> getStudentsByMajor(String major);
  Future<List<Student>> searchStudentsByName(String name);
  Future<void> close();
}
```

## 🎓 Educational Concepts

### 1. Interface-Based Programming
- **Abstraction**: Hide implementation details behind common interface
- **Polymorphism**: Same code works with different implementations
- **Dependency Injection**: Switch implementations easily

### 2. Database Design Patterns
- **Repository Pattern**: Encapsulate data access logic
- **Adapter Pattern**: Make incompatible interfaces work together
- **Strategy Pattern**: Switch algorithms (databases) at runtime

### 3. Platform-Specific Optimizations
- **SQLite**: Prepared statements, transactions, indexes
- **IndexedDB**: Object stores, indexes, cursors
- **Firebase**: Real-time listeners, offline caching, batch operations

## 🚀 Advanced Examples

### 1. Database Factory Pattern

```dart
class DatabaseFactory {
  static DatabaseService createDatabase(String type) {
    switch (type.toLowerCase()) {
      case 'sqlite':
        return SQLiteStudentService();
      case 'indexeddb':
        return IndexedDBStudentService();
      case 'firebase':
        return FirebaseStudentService();
      default:
        throw ArgumentError('Unknown database type: $type');
    }
  }
}

// Usage
final db = DatabaseFactory.createDatabase('sqlite');
```

### 2. Database Configuration

```dart
class DatabaseConfig {
  static Future<DatabaseService> createConfiguredDatabase() async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isDesktop) {
      return SQLiteStudentService();
    } else if (Platform.isBrowser) {
      return IndexedDBStudentService();
    } else {
      return FirebaseStudentService(); // Fallback to cloud
    }
  }
}
```

### 3. Database Migration

```dart
class DatabaseMigrator {
  static Future<void> migrateData(
    DatabaseService source,
    DatabaseService target,
  ) async {
    final students = await source.readAllStudents();
    await target.clearAllStudents();
    
    for (final student in students) {
      await target.createStudent(student);
    }
  }
}
```

## 📚 Learning Resources

### Official Documentation
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [IndexedDB MDN Guide](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
- [Firebase Documentation](https://firebase.google.com/docs)

### Dart Packages
- [sqlite3](https://pub.dev/packages/sqlite3) - SQLite for Dart
- [indexed_db](https://pub.dev/packages/indexed_db) - IndexedDB for Dart web
- [cloud_firestore](https://pub.dev/packages/cloud_firestore) - Firebase for Flutter

### Design Patterns
- [Repository Pattern](https://docs.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/infrastructure-persistence-layer-design)
- [Adapter Pattern](https://refactoring.guru/design-patterns/adapter)
- [Strategy Pattern](https://refactoring.guru/design-patterns/strategy)

## 🔍 Troubleshooting

### Common Issues

1. **Platform Compatibility**
   - SQLite: Not available in browsers
   - IndexedDB: Only available in browsers
   - Firebase: Requires internet connection

2. **Async/Await Issues**
   - Always use `await` with database operations
   - Handle exceptions with try-catch blocks
   - Dispose resources properly

3. **Data Serialization**
   - IndexedDB: Use `jsify`/`dartify` for JS interop
   - SQLite: Handle type conversions manually
   - Firebase: Built-in JSON serialization

### Performance Tips

1. **Use appropriate database for platform**
2. **Create indexes on queried fields**
3. **Batch operations when possible**
4. **Close connections properly**
5. **Handle errors gracefully**

## 🎯 Assessment Questions

1. **Conceptual**: Why is interface-based design important for database applications?

2. **Practical**: How would you add a new database implementation (e.g., MongoDB) to this system?

3. **Design**: What are the trade-offs between the three database approaches shown?

4. **Implementation**: How would you implement caching across different database types?

## 🚀 Extension Ideas

1. **Add more databases**: MongoDB, PostgreSQL, Redis
2. **Implement caching layer**: Add LRU cache between interface and database
3. **Add database pooling**: Manage multiple database connections
4. **Create migration tools**: Move data between different database types
5. **Add query builder**: Create SQL/NoSQL queries programmatically
6. **Implement data validation**: Add schema validation layer
7. **Add audit logging**: Track all database operations
8. **Create backup/restore**: Export/import data across databases

---

**🎓 This project demonstrates enterprise-level database abstraction patterns in an educational context, showing students how to build scalable, maintainable database applications.**
