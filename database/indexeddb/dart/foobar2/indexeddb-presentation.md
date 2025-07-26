---
marp: true
theme: default
paginate: true
title: Dart IndexedDB Web Application
---

# Dart IndexedDB Web Application
## Understanding Web Development with Dart and Browser Storage

---

## Project Overview

This project demonstrates a **Dart web application** that uses **IndexedDB** for browser-based data storage.

### Key Components:
- **HTML file**: Entry point for the web application
- **Dart file**: Business logic with CRUD operations
- **Build system**: webdev for development and compilation
- **Dependencies**: idb_shim package for IndexedDB compatibility

---

## Project Structure

```
foobar2/
├── pubspec.yaml          # Project configuration & dependencies
├── run.sh               # Build and serve script
└── web/
    ├── index.html       # HTML entry point
    └── main.dart        # Dart application logic
```

### Why this structure?
- `web/` directory: Standard for Dart web applications
- Separates configuration, build scripts, and source code
- Follows Dart conventions for maintainability

---

## HTML File Analysis

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Dart IndexedDB Example</title>
  </head>
  <body>
    <h2>Check the browser console for output.</h2>
    <script defer src="main.dart.js"></script>
  </body>
</html>
```

### Key Points:
- **Minimal HTML structure** - focuses on functionality
- **`main.dart.js`** - Compiled JavaScript from Dart source
- **`defer` attribute** - Ensures script runs after DOM is loaded

---

## Dart Application: Dependencies

```dart
import 'dart:html';                    // Browser DOM manipulation
import 'package:idb_shim/idb.dart';   // IndexedDB types/interfaces
import 'package:idb_shim/idb_browser.dart'; // Browser implementation
```

### Why idb_shim?
- **Cross-platform compatibility**: Works in browsers and Dart VM
- **Type safety**: Provides Dart-style APIs for IndexedDB
- **Simplified API**: Easier than raw JavaScript IndexedDB

---

## Database Configuration

```dart
const dbName = 'my_db';
const storeName = 'my_store';

Future<Database> openDb() async {
  var dbFactory = idbFactoryBrowser;
  return await dbFactory.open(dbName, version: 1, onUpgradeNeeded: (e) {
    var db = e.database;
    if (!db.objectStoreNames.contains(storeName)) {
      db.createObjectStore(storeName, autoIncrement: true);
    }
  });
}
```

### Database Setup Concepts:
- **Version control**: Database schema versioning
- **Object Store**: Similar to a table in relational databases
- **Auto-increment**: Automatic key generation

---

## CRUD Operations: CREATE

```dart
Future<int> addItem(Database db, Map<String, dynamic> item) async {
  var txn = db.transaction(storeName, idbModeReadWrite);
  var store = txn.objectStore(storeName);
  var key = await store.add(item);
  await txn.completed;
  return key as int;
}
```

### Key Concepts:
- **Transactions**: ACID properties for data consistency
- **Read-Write mode**: Required for data modification
- **Async/await**: Non-blocking database operations
- **Auto-generated keys**: Returns the created item's ID

---

## CRUD Operations: READ

```dart
Future<List<Map<String, dynamic>>> getAllItems(Database db) async {
  var txn = db.transaction(storeName, idbModeReadOnly);
  var store = txn.objectStore(storeName);
  var items = await store.getAll();
  await txn.completed;
  return List<Map<String, dynamic>>.from(items);
}
```

### Key Concepts:
- **Read-only mode**: Optimized for data retrieval
- **Type casting**: Converting to Dart's type system
- **getAll()**: Retrieves all records from object store

---

## CRUD Operations: UPDATE & DELETE

```dart
// UPDATE
Future<void> updateItem(Database db, int key, Map<String, dynamic> updated) async {
  var txn = db.transaction(storeName, idbModeReadWrite);
  var store = txn.objectStore(storeName);
  await store.put(updated, key);  // put() updates existing records
  await txn.completed;
}

// DELETE
Future<void> deleteItem(Database db, int key) async {
  var txn = db.transaction(storeName, idbModeReadWrite);
  var store = txn.objectStore(storeName);
  await store.delete(key);
  await txn.completed;
}
```

---

## Main Function: Application Flow

```dart
void main() async {
  var db = await openDb();
  
  // CREATE: Add new item
  int key = await addItem(db, {"foo": "Alice", "bar": 42});
  showOutput('Item added with key: $key');
  
  // READ: Retrieve all items
  var items = await getAllItems(db);
  showOutput('All items: $items');
  
  // UPDATE: Modify existing item
  await updateItem(db, key, {"foo": "Alice Updated", "bar": 99});
  showOutput('Item updated.');
  
  // DELETE: Remove item
  await deleteItem(db, key);
  showOutput('Item deleted.');
}
```

---

## Build Script Analysis

```bash
#!/bin/bash
set -e

# Install dependencies
dart pub get

# Activate webdev if not already
dart pub global activate webdev

# Generate build files (Dart 2.6+; webdev builds main.dart.js)
dart pub global run webdev build

# Serve (for development, starts a localhost server)
dart pub global run webdev serve
```

### Script Breakdown:
- **`set -e`**: Exit on any error
- **`dart pub get`**: Download dependencies
- **`webdev`**: Official Dart web development tool

---

## Why webdev instead of `dart compile js`?

### webdev Advantages:
1. **Development Server**: Hot reload, live reloading
2. **Build Optimization**: Automatic dependency management
3. **Module System**: Better handling of package imports
4. **Development Tools**: Debugging support, source maps
5. **Asset Management**: Handles static files automatically

### dart compile js Limitations:
- **Manual process**: No built-in development server
- **No hot reload**: Must manually refresh browser
- **Complex dependencies**: Manual handling of package imports
- **Limited tooling**: Less integrated development experience

---

## Dependencies Explained

```yaml
dependencies:
  idb_shim: any              # IndexedDB abstraction layer

dev_dependencies:
  build_runner: ^2.4.0       # Build system foundation
  build_web_compilers: ^4.0.4 # Dart-to-JS compilation
```

### Why these dependencies?
- **idb_shim**: Cross-platform IndexedDB compatibility
- **build_runner**: Coordinates build process
- **build_web_compilers**: Compiles Dart to optimized JavaScript

---

## IndexedDB vs Other Storage Options

| Storage Type | Size Limit | Persistence | Complexity |
|-------------|-------------|-------------|------------|
| **IndexedDB** | ~50-100MB+ | Yes | Medium |
| localStorage | ~5-10MB | Yes | Low |
| sessionStorage | ~5-10MB | No | Low |
| WebSQL | Deprecated | - | - |

### When to use IndexedDB:
- Large amounts of structured data
- Complex queries and indexing
- Offline-first applications
- Performance-critical applications

---

## Real-World Applications

### IndexedDB is ideal for:
- **Progressive Web Apps (PWAs)**: Offline data caching
- **Note-taking apps**: Local document storage
- **Gaming**: Save game states and user progress
- **Media apps**: Caching images, videos, audio files
- **Business apps**: Local data synchronization

### Example Use Cases:
- Google Drive offline editing
- Spotify offline playlists
- WhatsApp Web message history

---

## Development Workflow

```bash
# 1. Install dependencies
dart pub get

# 2. Start development server
dart pub global run webdev serve

# 3. Open browser to localhost:8080
# 4. Edit code - see changes immediately
# 5. Build for production
dart pub global run webdev build
```

### Benefits:
- **Fast iteration**: Immediate feedback
- **Built-in server**: No additional setup required
- **Automatic compilation**: Dart → JavaScript seamlessly

---

## Best Practices

### Error Handling:
```dart
try {
  var db = await openDb();
  var items = await getAllItems(db);
  showOutput('Success: $items');
} catch (e) {
  showOutput('Error: $e');
}
```

### Transaction Management:
- Always wait for `txn.completed`
- Use appropriate transaction modes
- Keep transactions short-lived

### Performance:
- Batch operations when possible
- Use indexes for frequent queries
- Consider data size and structure

---

## Common Pitfalls & Solutions

### Problem: Transaction inactive errors
**Solution**: Complete operations before transaction timeout

### Problem: Browser compatibility
**Solution**: Use idb_shim for consistent behavior

### Problem: Large data performance
**Solution**: Implement pagination and lazy loading

### Problem: Data loss on browser clear
**Solution**: Implement backup/sync mechanisms

---

## Summary

### What we learned:
1. **Dart web development** with modern tooling
2. **IndexedDB** for browser-based data storage
3. **webdev** as a complete development solution
4. **CRUD operations** with proper async handling
5. **Project structure** for maintainable web applications

### Key takeaways:
- IndexedDB provides powerful client-side storage
- webdev simplifies Dart web development
- Proper async/await usage is crucial
- Transaction management ensures data consistency

---

## Next Steps

### Try these extensions:
1. Add **error handling** to all operations
2. Implement **data validation** before storage
3. Create a **user interface** instead of console output
4. Add **search and filtering** capabilities
5. Implement **data export/import** features
6. Add **offline synchronization** with a server

### Resources:
- [Dart web development guide](https://dart.dev/web)
- [IndexedDB MDN documentation](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
- [idb_shim package documentation](https://pub.dev/packages/idb_shim)

---

## Questions?

### Discussion Topics:
- When would you choose IndexedDB over other storage options?
- How would you handle data synchronization between devices?
- What security considerations apply to client-side storage?
- How would you implement data migration for schema changes?

**Thank you for your attention!** 🎯