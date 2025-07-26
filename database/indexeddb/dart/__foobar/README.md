# FooBar IndexedDB Demo

A comprehensive Dart application demonstrating **IndexedDB** usage for client-side data storage in web browsers. This project showcases CRUD operations, data import/export, and utility functions using IndexedDB as the database backend.

## 🌟 Features

- **Complete CRUD Operations**: Create, Read, Update, Delete FooBar records
- **Search & Filter**: Find records by content
- **Data Import/Export**: JSON file handling with browser download/upload
- **Pagination**: Efficient handling of large datasets
- **Statistics**: Database analytics and insights
- **Browser-based**: Runs entirely in the browser using IndexedDB

## 🏗️ Project Structure

```
foobar/
├── lib/
│   ├── foobar.dart              # Data model class
│   ├── foobar_crud.dart         # CRUD operations with IndexedDB
│   └── foobar_utility.dart      # Import/export and utility functions
├── web/
│   ├── index.html               # Demo web page
│   └── main.dart                # Main application entry point
├── test/
│   └── foobar_crud_test.dart    # Unit tests
├── doc/                         # Documentation (Marp presentations)
├── pubspec.yaml                 # Dart dependencies
├── build_and_run.sh            # Build and run script
└── run_tests.sh                # Test runner script
```

## 🔥 **CIRCULAR REFERENCE FIX**

**Issue Found**: `LinkedHashMapCell` with circular `_next`/`_previous` references
**Error**: `Converting circular structure to JSON`

**Solution Applied**: Avoid `JSON.stringify()` completely, use direct property extraction

### 🚀 **Quick Fix Test**

```bash
chmod +x fix_circular_reference.sh
./fix_circular_reference.sh
```

**Expected Result**: Real data instead of empty records:
```
📋 Found 5 records:
1. ID: 123_456, foo: "Hello World", bar: 42
2. ID: 789_012, foo: "Dart Programming", bar: 100
...
```

---

## 🐛 **Previous Issue Investigation** (SOLVED)

**Problem**: Sample data appears as empty records (all null/empty values)

**Status**: Enhanced debugging added to isolate the JavaScript↔Dart conversion issue

### 🔍 **Debug Steps**

1. **Rebuild with enhanced debugging**:
```bash
chmod +x debug_rebuild.sh
./debug_rebuild.sh
```

2. **Test with detailed logging**:
   - Open http://localhost:8000
   - Open browser Developer Tools (F12) → Console tab
   - Try: Initialize Database → Add Sample Data → Show All Records
   - Watch console for detailed conversion logs

3. **Use specialized debug tool**:
   - Navigate to: http://localhost:8000/debug_indexeddb.html
   - Test each step: Initialize → Add Test Data → List Raw Data → Test Storage/Retrieval
   - This shows exactly what IndexedDB stores vs. what Dart retrieves

4. **Check IndexedDB directly**:
   - Browser Developer Tools → Application tab → IndexedDB → FooBarDB → foobar
   - Verify data is actually stored with correct values

### 🎯 **Expected Debugging Output**

The console should show:
```
📝 Creating FooBar: FooBar(id: 123_456, foo: Hello World, bar: 42)
📄 JSON to store: {id: 123_456, foo: Hello World, bar: 42}
✅ Created FooBar with ID: 123_456

🔍 Received JS object type: JsLinkedHashMap<dynamic, dynamic>
✅ JSON conversion successful: {id: 123_456, foo: Hello World, bar: 42}
```

---

## 🔧 Troubleshooting

### JSNull Type Conversion Errors

**Error**: `TypeError: null: type 'JSNull' is not a subtype of type 'String'`

**Cause**: IndexedDB returns JavaScript objects that need careful type conversion to Dart types.

**Fixed in this version**: The `_jsObjectToDartMap` function now handles null values safely:

```dart
// Before (causes errors)
final data = cursor.value as Map<String, dynamic>;

// After (safe conversion)
final dartMap = _jsObjectToDartMap(cursor.value);
final foobar = FooBar.fromJson(dartMap);
```

**Debug steps**:
1. Open browser Developer Tools (F12)
2. Check Console for detailed error logs
3. Use `web/debug_indexeddb.html` to test IndexedDB operations
4. Check Application tab > IndexedDB to see stored data structure

### Newline Display Issues

**Problem**: Status messages show `\n` instead of line breaks

**Solution**: Use CSS `white-space: pre-wrap` and proper string concatenation:

```dart
// HTML setup
final statusDiv = html.DivElement()
  ..style.whiteSpace = 'pre-wrap';

// String handling
final newText = currentText + '[$timestamp] $message\n';
statusDiv.text = newText;
```

### Build and Run

## 🚀 Quick Start

### Prerequisites
- [Dart SDK](https://dart.dev/get-dart) (3.0.0 or higher)
- Modern web browser (Chrome, Firefox, Safari, Edge)

### 1. Build and Run

```bash
# Make scripts executable
chmod +x build_and_run.sh run_tests.sh

# Build and run the demo
./build_and_run.sh
```

### 2. Manual Setup

```bash
# Get dependencies
dart pub get

# Compile Dart to JavaScript
dart compile js web/main.dart -o web/main.dart.js

# Start a local web server
cd web && python3 -m http.server 8000

# Open browser to http://localhost:8000
```

### 3. Run Tests

```bash
# Run unit tests
./run_tests.sh

# Or manually
dart test
```

## 🎯 How to Use the Demo

1. **Initialize Database**: Click to set up IndexedDB
2. **Add Sample Data**: Populate with test records
3. **Explore Operations**:
   - View all records
   - Search for specific content
   - Update existing records
   - Delete records
   - Export data to JSON
   - Import data from JSON files
   - View database statistics

## 📚 Learning Objectives

This project demonstrates:

### 🗄️ IndexedDB Concepts
- Database initialization and schema creation
- Object stores and indexes
- Transactions (read/write)
- Cursors for data iteration
- Asynchronous operations

### 🎨 Dart Web Programming
- Compiling Dart to JavaScript
- DOM manipulation with `dart:html`
- File API integration
- Event handling in browsers

### 📁 Data Management Patterns
- CRUD service pattern
- Utility class organization
- JSON serialization/deserialization
- Error handling strategies

## 🔍 Code Examples

### Basic CRUD Operations

```dart
// Initialize database
final crudService = FooBarCrudService();
await crudService.initialize();

// Create a record
final foobar = FooBar(foo: 'Hello World', bar: 42);
final created = await crudService.create(foobar);

// Read records
final allRecords = await crudService.getAll();
final specific = await crudService.getById(created.id!);

// Update a record
final updated = await crudService.update(created.id!, 
  FooBar(foo: 'Updated', bar: 100));

// Delete a record
await crudService.delete(created.id!);
```

### Data Import/Export

```dart
// Export to JSON file (triggers browser download)
final utility = FooBarUtility(crudService);
await utility.exportToJsonFile('my_data.json');

// Import from JSON file (opens file dialog)
await utility.importFromJsonFile();

// Import from JSON string
const jsonData = '[{"foo": "test", "bar": 123}]';
await utility.importFromJsonString(jsonData);
```

## 🆚 Comparison with PocketBase Version

| Feature | PocketBase | IndexedDB |
|---------|------------|-----------|
| **Runtime** | Server-side | Client-side (browser) |
| **Database** | SQLite | IndexedDB |
| **Network** | HTTP API calls | Local operations |
| **Persistence** | Server storage | Browser storage |
| **Scalability** | Multi-user | Single-user |
| **Setup** | Requires server | No server needed |

## 🏫 Educational Benefits

### For Students:
- **Database Concepts**: Learn NoSQL document storage
- **Web Development**: Understand client-side data persistence
- **Dart Programming**: Practice modern language features
- **Async Programming**: Master Future/async patterns
- **Software Architecture**: See clean separation of concerns

### For Instructors:
- **Hands-on Learning**: Interactive demo with immediate feedback
- **Progressive Complexity**: Start simple, add advanced features
- **Real-world Skills**: Technologies used in production apps
- **Cross-platform**: Works on any device with a browser

## 🛠️ Development Notes

### Browser Compatibility
- **Chrome/Edge**: Full support
- **Firefox**: Full support  
- **Safari**: Full support
- **Mobile browsers**: Generally supported

### Limitations
- Data is browser-specific (not shared across browsers)
- Storage quotas apply (varies by browser)
- No real-time sync between tabs/windows
- Requires JavaScript enabled

### Best Practices Demonstrated
- Error handling with try-catch
- Input validation and sanitization
- Consistent API interfaces
- Comprehensive logging
- User-friendly error messages

## 📖 Further Reading

- [IndexedDB API Documentation](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
- [Dart Web Programming](https://dart.dev/web)
- [Database Design Patterns](https://en.wikipedia.org/wiki/Database_design)

## 🤝 Contributing

This is an educational project. Feel free to:
- Add new features for learning
- Improve error handling
- Enhance the UI/UX
- Add more comprehensive tests
- Create additional utility functions

## 📄 License

This project is for educational purposes. Use freely for learning and teaching.

---

**Happy Learning! 🎓**
