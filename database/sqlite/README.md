# SQLite CRUD Operations in Dart
## Educational Project for ASE456

This project demonstrates fundamental database operations (CRUD) using SQLite in Dart, designed for university students learning database programming concepts.

## 📚 What You'll Learn

- **CRUD Operations**: Create, Read, Update, Delete
- **SQLite Integration**: Database management in Dart applications
- **Model-Service Architecture**: Separation of concerns
- **Unit Testing**: Testing database operations
- **Best Practices**: Safe, efficient database programming

## 🏗️ Project Structure

```
sqlite/
├── lib/
│   ├── models/
│   │   └── foobar.dart              # Data model definition
│   ├── services/
│   │   └── foobar_crud_sqlite.dart  # CRUD operations service
│   └── examples/
│       └── crud_demo.dart           # Practical usage examples
├── test/
│   └── foobar_crud_test.dart        # Comprehensive unit tests
├── data/
│   └── .gitignore                   # Database files (auto-generated)
├── doc/
│   └── crud_tutorial.md             # Marp presentation (theory + practice)
└── README.md                        # This file
```

### Database File Location

The SQLite database file (`foobar.db`) is automatically created in the `data/` directory when you run the application. This keeps the project organized and separates generated files from source code.

**Path**: `data/foobar.db`

## 🚀 Quick Start

### 1. Run the Demo
```bash
dart run lib/examples/crud_demo.dart
```

### 2. Run the Tests
```bash
dart test
```

### 3. View the Database File
After running the demos, check the generated database:
```bash
# If you have SQLite CLI installed
sqlite3 data/foobar.db

# View table structure
.schema foobars

# View all records
SELECT * FROM foobars;

# Exit
.quit
```

### 4. View the Presentation
Open `doc/crud_tutorial.md` in a Marp-compatible viewer or convert to slides.

## 📖 Learning Path

### Beginner (Start Here)
1. **Read the model**: `lib/models/foobar.dart`
2. **Study the presentation**: `doc/crud_tutorial.md`
3. **Run the demo**: `lib/examples/crud_demo.dart`

### Intermediate
1. **Examine the CRUD service**: `lib/services/foobar_crud_sqlite.dart`
2. **Understand the tests**: `test/foobar_crud_test.dart`
3. **Modify and experiment** with the code

### Advanced
1. **Add new features** (pagination, sorting, etc.)
2. **Implement relationships** between models
3. **Optimize performance** with indexes and queries

## 🔧 Key Components

### FooBar Model (`lib/models/foobar.dart`)
Simple data model with:
- `String foo` - text field
- `int bar` - number field
- Conversion methods for database integration

### CRUD Service (`lib/services/foobar_crud_sqlite.dart`)
Complete database operations:
- ✅ **Create**: Insert new records
- ✅ **Read**: Retrieve records (all, by ID, search)
- ✅ **Update**: Modify existing records
- ✅ **Delete**: Remove records (single, all)
- ✅ **Utility**: Count, exists, etc.

### Tests (`test/foobar_crud_test.dart`)
Comprehensive testing covering:
- All CRUD operations
- Error handling
- Edge cases
- Integration workflows

## 📋 Available Operations

| Operation | Method | Description |
|-----------|--------|-------------|
| Create | `create(foobar)` | Insert new record |
| Read All | `readAll()` | Get all records |
| Read by ID | `readById(id)` | Get specific record |
| Search | `findByFoo(text)` | Find by text content |
| Update | `update(id, foobar)` | Modify existing record |
| Delete | `delete(id)` | Remove specific record |
| Delete All | `deleteAll()` | Remove all records |
| Count | `count()` | Get total record count |
| Exists | `exists(id)` | Check if record exists |

## 🛡️ Best Practices Demonstrated

### Security
- ✅ Prepared statements (prevents SQL injection)
- ✅ Input validation
- ✅ Safe null handling

### Performance
- ✅ Connection reuse
- ✅ Proper resource disposal
- ✅ Efficient queries

### Maintainability
- ✅ Clear separation of concerns
- ✅ Comprehensive documentation
- ✅ Consistent error handling

## 🧪 Testing

Run all tests:
```bash
dart test
```

Run specific test file:
```bash
dart test test/foobar_crud_test.dart
```

Run with detailed output:
```bash
dart test --reporter=expanded
```

## 📊 Database Schema

```sql
CREATE TABLE IF NOT EXISTS foobars (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  foo TEXT NOT NULL,
  bar INTEGER NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 🎯 Assignment Ideas

### Beginner Level
- Modify the FooBar model to add more fields
- Create a simple console application using the CRUD service
- Add validation to ensure bar is positive

### Intermediate Level
- Implement pagination (limit/offset)
- Add sorting options to readAll()
- Create a backup/restore feature

### Advanced Level
- Add database relationships (foreign keys)
- Implement database migrations
- Add performance monitoring

## 🔍 Common Issues & Solutions

### Memory Management
```dart
// Ensure the data directory exists and is writable
final dataDir = Directory('data');
if (!await dataDir.exists()) {
  await dataDir.create(recursive: true);
}
```

### Memory Management
```dart
// Always close database connections
try {
  // ... database operations
} finally {
  await crudService.close();
}
```

### Testing Isolation
```dart
// Clean up between tests
setUp(() async {
  await crudService.deleteAll();
});
```

## 📚 Additional Resources

- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Dart sqlite3 Package](https://pub.dev/packages/sqlite3)
- [Database Design Principles](https://en.wikipedia.org/wiki/Database_design)
- [SQL Injection Prevention](https://owasp.org/www-community/attacks/SQL_Injection)

## 🤝 Contributing

This is an educational project. Students are encouraged to:
1. Fork the project
2. Experiment with modifications
3. Share improvements
4. Ask questions during class

## 📝 License

This project is for educational purposes in ASE456 - Advanced Software Engineering course.

---

**Happy Learning! 🎓**

For questions or issues, please discuss during class or office hours.
