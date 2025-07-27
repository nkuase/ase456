# SQLite Student Management System

A comprehensive example of using SQLite for desktop and mobile student data management with a consistent database service interface.

## 🌟 Features

- **File-based database** - Single file contains entire database
- **Full SQL support** - Complete relational database capabilities
- **ACID transactions** - Ensures data integrity
- **Zero configuration** - No server setup required
- **Cross-platform** - Works on desktop and mobile
- **Consistent API** - Same interface as IndexedDB and Firebase implementations

## 🚀 Quick Start

### Prerequisites

- Dart SDK 3.0.0 or higher
- Desktop or mobile platform (Linux, macOS, Windows, Android, iOS)

### Installation

1. Navigate to the SQLite directory:
```bash
cd database/sqlite
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
sqlite/
├── sqlite_service.dart      # Main SQLite implementation
├── example_usage.dart       # Usage examples and demos
├── pubspec.yaml            # Dependencies
└── README.md              # This file
```

## 🔧 Usage Example

```dart
import 'sqlite_service.dart';
import '../common/database_service.dart';
import '../common/student.dart';

Future<void> main() async {
  // Create database service
  DatabaseService db = SQLiteStudentService();
  
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
| **Search** | `searchStudentsByName(name)` | Search by name with LIKE |

### SQLite Execution Methods

| Method | Purpose | Safety | Performance |
|--------|---------|--------|-------------|
| `db.execute` | INSERT/UPDATE/DELETE | ⚠️ Manual | Fast |
| `db.select` | SELECT queries | ⚠️ Manual | Fast |
| `db.prepare + execute` | Any operation | ✅ Safe | Best |

### Safe SQL with Prepared Statements

```dart
// ❌ Unsafe - SQL injection risk
db.execute("INSERT INTO students (name) VALUES ('$userInput')");

// ✅ Safe - Uses parameterized queries
final stmt = db.prepare("INSERT INTO students (name) VALUES (?)");
stmt.execute([userInput]);
stmt.dispose();
```

## 🗃️ Database Schema

```sql
CREATE TABLE students (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  age INTEGER NOT NULL,
  major TEXT NOT NULL,
  createdAt TEXT NOT NULL
);

-- Indexes for better performance
CREATE INDEX idx_name ON students(name);
CREATE INDEX idx_major ON students(major);
CREATE INDEX idx_age ON students(age);
```

## ⚡ Advanced Features

### Batch Operations

```dart
// Insert multiple students efficiently
SQLiteStudentService.performBatchInsert([student1, student2, student3]);
```

### Database Maintenance

```dart
// Optimize database performance
SQLiteStudentService.optimizeDatabase();
```

### Transaction Management

```dart
db.execute('BEGIN TRANSACTION');
try {
  // Multiple operations
  db.execute('INSERT ...');
  db.execute('UPDATE ...');
  db.execute('COMMIT');
} catch (e) {
  db.execute('ROLLBACK');
  rethrow;
}
```

## 🔍 Query Examples

### Basic Queries

```sql
-- Get all students, ordered by creation date
SELECT * FROM students ORDER BY createdAt DESC;

-- Get students by major
SELECT * FROM students WHERE major = 'Computer Science';

-- Search by partial name match
SELECT * FROM students WHERE name LIKE '%John%';

-- Get students in age range
SELECT * FROM students WHERE age BETWEEN 18 AND 25;
```

### Advanced Queries

```sql
-- Count students by major
SELECT major, COUNT(*) as count 
FROM students 
GROUP BY major;

-- Get average age by major
SELECT major, AVG(age) as avg_age 
FROM students 
GROUP BY major;

-- Multiple conditions with ordering and limiting
SELECT * FROM students 
WHERE age > 20 AND major = 'Computer Science'
ORDER BY age DESC, name ASC 
LIMIT 10;
```

## 🏗️ Architecture Benefits

### Single File Database
- Easy backup and deployment
- Portable across platforms
- No network configuration needed

### ACID Compliance
- **Atomicity**: All operations in transaction succeed or fail together
- **Consistency**: Database remains in valid state
- **Isolation**: Concurrent operations don't interfere
- **Durability**: Committed changes are persistent

## 🔄 Database Switching

This implementation follows the common `DatabaseService` interface, making it easy to switch between different database technologies:

```dart
// Switch between different databases
DatabaseService db = SQLiteStudentService();     // Desktop/Mobile
// DatabaseService db = IndexedDBStudentService();  // Browser
// DatabaseService db = FirebaseStudentService();   // Cloud

// Same code works with any implementation!
await db.initialize();
await db.createStudent(student);
```

## 🎯 Use Cases

### Perfect For:
- ✅ Desktop applications
- ✅ Mobile applications
- ✅ Embedded systems
- ✅ Development and prototyping
- ✅ Single-user applications
- ✅ Local data caching

### Not Ideal For:
- ❌ Web browsers (use IndexedDB instead)
- ❌ High-concurrency multi-user applications
- ❌ Real-time collaborative features
- ❌ Applications requiring built-in user authentication

## 📊 Performance Tips

1. **Use indexes** on frequently queried columns
2. **Prepare statements** for repeated queries
3. **Batch operations** in transactions
4. **Run VACUUM** periodically to reclaim space
5. **Use ANALYZE** to update query statistics

## 🚧 Limitations

- **Single writer** at a time (multiple readers OK)
- **No built-in networking** (file-based)
- **Limited concurrency** compared to server databases
- **No user management** or access control
- **Database size** practical limit around several GB

## 📚 Learn More

- [SQLite Official Documentation](https://www.sqlite.org/docs.html)
- [SQLite3 Dart Package](https://pub.dev/packages/sqlite3)
- [SQL Tutorial](https://www.w3schools.com/sql/)
- [Database Design Principles](https://www.geeksforgeeks.org/database-design/)

## 🎓 Educational Value

This example demonstrates:

- **Relational database concepts** with SQL
- **Database design** with tables, indexes, and relationships
- **Transaction management** for data consistency
- **SQL injection prevention** with prepared statements
- **Performance optimization** techniques
- **Interface-based design** for code flexibility

## 🔧 Troubleshooting

### Common Issues

1. **Database locked error**
   - Ensure you dispose prepared statements
   - Close database connection properly

2. **SQL syntax errors**
   - Use prepared statements with placeholders
   - Check SQL syntax carefully

3. **Performance issues**
   - Add indexes on queried columns
   - Use transactions for batch operations
   - Run VACUUM and ANALYZE regularly
