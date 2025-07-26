---
marp: true
theme: gaia
paginate: true
backgroundColor: #fff
---

# IndexedDB with Dart
## Browser-Based Database for Web Applications

**Professor's Guide to Teaching IndexedDB**

---

# What is IndexedDB?

- **Client-side database** built into modern browsers
- Stores data **locally** on user's device
- **NoSQL** key-value database
- Supports **large amounts** of structured data
- Works **offline** - no server required!

---

# Why Use IndexedDB?

## Real-World Examples:
- 📧 **Gmail Offline** - Read emails without internet
- 📝 **Google Docs** - Edit documents offline
- 🎮 **Web Games** - Save game progress locally
- 📊 **Analytics Apps** - Store data before syncing

---

# IndexedDB vs Other Storage

| Feature | LocalStorage | IndexedDB | 
|---------|--------------|-----------|
| Size Limit | ~5-10MB | GBs |
| Data Types | Strings only | Any JavaScript type |
| Search | No | Yes (indexes) |
| Async | No | Yes |
| Complex Data | No | Yes |

---

# Core Concepts

1. **Database** - Container for object stores
2. **Object Store** - Like a table in SQL
3. **Transaction** - All operations need transactions
4. **Index** - For efficient searching
5. **Key** - Unique identifier for records

---

# Setting Up Dart for Web

## 1. Create Project Structure
```bash
project/
├── lib/          # Dart library files
├── web/          # Web-specific files
├── test/         # Test files
└── pubspec.yaml  # Dependencies
```

---

# pubspec.yaml Configuration

```yaml
name: foobar_indexeddb
description: IndexedDB demo application

environment:
  sdk: '>=2.17.0 <4.0.0'

dependencies:
  js: ^0.6.5      # JavaScript interop
  web: ^0.4.0     # Web APIs

dev_dependencies:
  test: ^1.24.0
  build_runner: ^2.4.0
  build_web_compilers: ^4.0.0
```

---

# JavaScript Interop

## Why needed?
- IndexedDB is a **JavaScript API**
- Dart needs to **communicate** with JavaScript
- Use `@JS()` annotations for binding

```dart
@JS()
library indexeddb_js;

import 'package:js/js.dart';
```

---

# Basic IndexedDB Operations

## 1. Open Database
```dart
final db = await openDatabase('myDB', 1);
```

## 2. Create Object Store
```dart
db.createObjectStore('foobar', {
  'keyPath': 'id',
  'autoIncrement': true
});
```

---

# CRUD Operations

## Create
```dart
final transaction = db.transaction(['foobar'], 'readwrite');
final store = transaction.objectStore('foobar');
final request = store.add({'foo': 'Hello', 'bar': 42});
```

## Read
```dart
final request = store.get(id);
final result = await requestToFuture(request);
```

---

# Model Class Design

```dart
class FooBar {
  String? id;
  String foo;
  int bar;

  FooBar({this.id, required this.foo, required this.bar});

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'foo': foo,
    'bar': bar,
  };
}
```

---

# Service Pattern

```dart
class FooBarCrudService {
  IDBDatabase? _database;
  
  Future<void> init() async {
    _database = await openDatabase('foobar_db', 1);
  }
  
  Future<FooBar> create(FooBar item) async {
    // Implementation
  }
}
```

---

# Handling Async Operations

## Convert Callbacks to Futures
```dart
Future<T> requestToFuture<T>(IDBRequest request) {
  final completer = Completer<T>();
  
  request.onsuccess = (_) {
    completer.complete(request.result);
  };
  
  request.onerror = (_) {
    completer.completeError(request.error);
  };
  
  return completer.future;
}
```

---

# Building for Web

## Development Mode
```bash
# Hot reload enabled
dart run build_runner serve web:8080
```

## Production Build
```bash
# Optimized JavaScript output
dart run build_runner build --release -o web:build
```

---

# File Structure After Build

```
build/
├── index.html
├── main.dart.js         # Your Dart code compiled
├── main.dart.js.map     # Source maps
└── packages/           # Dependencies
```

---

# HTML Integration

```html
<!DOCTYPE html>
<html>
<head>
    <title>FooBar App</title>
</head>
<body>
    <div id="app"></div>
    
    <!-- Dart compiled to JavaScript -->
    <script defer src="main.dart.js"></script>
</body>
</html>
```

---

# Import/Export Pattern

## Export to JSON
```dart
Future<void> exportData() async {
  final records = await getAllRecords();
  final json = jsonEncode(records);
  
  // Create download link
  final blob = Blob([json], 'application/json');
  final url = Url.createObjectUrlFromBlob(blob);
  // Trigger download...
}
```

---

# Error Handling

```dart
try {
  await crudService.create(item);
  showMessage('Success!');
} catch (e) {
  showMessage('Error: $e', isError: true);
  print('Detailed error: $e');
}
```

---

# Testing Strategies

## Unit Tests
```dart
test('should create FooBar instance', () {
  final foobar = FooBar(foo: 'test', bar: 123);
  expect(foobar.foo, equals('test'));
});
```

## Integration Tests (Browser)
```bash
dart test -p chrome
```

---

# Best Practices

1. **Always handle errors** - Network/browser issues
2. **Use transactions** - Ensure data consistency  
3. **Create indexes** - For search performance
4. **Limit data size** - Browser storage limits
5. **Version your schema** - Handle upgrades

---

# Common Pitfalls

❌ **Don't forget to close transactions**
❌ **Don't store sensitive data** (passwords)
❌ **Don't assume unlimited storage**
❌ **Don't use synchronous operations**

✅ **Do use proper error handling**
✅ **Do test across browsers**

---

# Performance Tips

1. **Batch operations** in single transaction
2. **Use indexes** for frequently searched fields
3. **Paginate** large result sets
4. **Clean up** old data periodically
5. **Monitor** storage usage

---

# Browser DevTools

## Chrome/Edge DevTools
1. Press **F12**
2. Go to **Application** tab
3. Find **IndexedDB** in sidebar
4. Inspect your data!

![bg right:40% 80%](https://developers.google.com/web/tools/chrome-devtools/storage/imgs/indexeddb.png)

---

# Real Example: Todo App

```dart
class Todo {
  String? id;
  String title;
  bool completed;
  DateTime created;
  
  // Store todos locally
  // Sync with server when online
  // Work completely offline!
}
```

---

# Deployment Options

1. **GitHub Pages** - Free static hosting
2. **Netlify/Vercel** - Auto-deploy from Git
3. **Firebase Hosting** - Google's platform
4. **Any static server** - Just HTML/JS files!

---

# Summary

## What We Learned:
- ✅ IndexedDB for browser storage
- ✅ Dart-JavaScript interop
- ✅ CRUD operations pattern
- ✅ Build and deployment process
- ✅ Real-world applications

---

# Assignment Ideas

1. **Build a Note-Taking App**
   - Store notes in IndexedDB
   - Add search functionality
   - Export/Import features

2. **Create an Expense Tracker**
   - Track daily expenses
   - Generate reports
   - Work offline

---

# Resources

- 📚 [MDN IndexedDB Guide](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
- 📚 [Dart Web Documentation](https://dart.dev/web)
- 📚 [JavaScript Interop](https://dart.dev/web/js-interop)
- 💻 [Sample Code](github.com/your-repo)

---

# Questions?

## Try the Demo:
1. Clone the repository
2. Run `dart pub get`
3. Run `./dev_server.sh`
4. Open http://localhost:8080

**Happy Coding! 🚀**
