---
marp: true
theme: default
class: invert
paginate: true
backgroundColor: #1e1e1e
color: #ffffff
---

# 🗄️ IndexedDB with Dart
## Client-Side Database Programming

**ASE456 - Database Systems**  
**University Course - 2025**

**Professor: How to use IndexedDB with Dart**  
*Compile Dart to JavaScript and deploy to browsers*

---

# 📋 Today's Learning Objectives

By the end of this session, you will understand:

✅ **What is IndexedDB** and when to use it  
✅ **How to set up** IndexedDB in Dart applications  
✅ **CRUD operations** with IndexedDB  
✅ **JavaScript interop** and type conversion issues  
✅ **Compile Dart to JavaScript** for web deployment  
✅ **Common problems** and their solutions  
✅ **Best practices** for client-side data storage

---

# 🤔 What is IndexedDB?

## A **NoSQL database** built into web browsers

- 🌐 **Client-side storage** - data stays in the browser
- 📊 **Structured data** - supports objects, not just key-value pairs
- 🔄 **Asynchronous** - non-blocking operations
- 💾 **Persistent** - data survives browser restarts
- 🔍 **Indexable** - fast queries with indexes
- 📏 **Large capacity** - much more than localStorage

**Perfect for offline web applications!**

---

# 🆚 Storage Options Comparison

| Feature | localStorage | sessionStorage | IndexedDB | Server DB |
|---------|-------------|----------------|-----------|-----------|
| **Capacity** | 5-10MB | 5-10MB | 250MB+ | Unlimited |
| **Data Types** | Strings only | Strings only | Objects | Any |
| **Persistence** | Yes | Session only | Yes | Yes |
| **Querying** | Key only | Key only | Indexes | SQL/NoSQL |
| **Performance** | Fast | Fast | Very Fast | Network dependent |
| **Offline** | ✅ | ✅ | ✅ | ❌ |

---

# 🏗️ Project Architecture

```
🗂️ FooBar IndexedDB Project
├── 📁 lib/
│   ├── 📄 foobar.dart              # Data model
│   ├── 📄 foobar_crud.dart         # Database operations
│   └── 📄 foobar_utility.dart      # Import/export utilities
├── 📁 web/
│   ├── 📄 index.html               # Web interface
│   ├── 📄 main.dart                # Application entry point
│   └── 📄 main.dart.js             # ⭐ Compiled JavaScript
├── 📁 test/
│   └── 📄 foobar_crud_test.dart    # Unit tests
└── 📄 pubspec.yaml                 # Dependencies
```

**Key Point**: Dart compiles to JavaScript for browser execution!

---

# 🎯 Data Model: FooBar Class

```dart
class FooBar {
  String? id;     // Primary key (optional for new records)
  String foo;     // Text field
  int bar;        // Number field
  
  FooBar({this.id, required this.foo, required this.bar});
  
  // JSON serialization for IndexedDB storage
  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'foo': foo,
    'bar': bar,
  };
  
  factory FooBar.fromJson(Map<String, dynamic> json) => FooBar(
    id: json['id'],
    foo: json['foo'],
    bar: json['bar'],
  );
}
```

**Educational Point**: Same model works with any database backend!

---

# ⚡ Key Insight: JavaScript Interop Challenge

## 🚨 **Common Error Students Encounter**

```dart
// ❌ This FAILS at runtime!
final result = await store.getObject(id);
return FooBar.fromJson(result as Map<String, dynamic>);

// Error: JsLinkedHashMap<dynamic, dynamic> is not a subtype 
// of type Map<String, dynamic>
```

## ✅ **Solution: Safe Type Conversion**

```dart
Map<String, dynamic> _jsObjectToDartMap(dynamic jsObject) {
  if (jsObject == null) return {};
  
  // Use JSON for safe conversion
  final jsonString = js_util.callMethod(html.window, 'JSON.stringify', [jsObject]);
  return jsonDecode(jsonString as String) as Map<String, dynamic>;
}

// ✅ Now this WORKS!
final dartMap = _jsObjectToDartMap(result);
return FooBar.fromJson(dartMap);
```

---

# 🔧 Setting Up IndexedDB

## Step 1: Database Initialization

```dart
class FooBarCrudService {
  static const String _databaseName = 'FooBarDB';
  static const String _storeName = 'foobar';
  static const int _version = 1;
  Database? _db;

  Future<void> initialize() async {
    _db = await html.window.indexedDB!.open(
      _databaseName,
      version: _version,
      onUpgradeNeeded: (VersionChangeEvent event) {
        final Database db = event.target.result;
        
        // Create object store (like a table)
        final store = db.createObjectStore(
          _storeName,
          keyPath: 'id',           // Primary key
          autoIncrement: false,    // We generate our own IDs
        );
        
        // Create indexes for fast searching
        store.createIndex('foo_index', 'foo', unique: false);
        store.createIndex('bar_index', 'bar', unique: false);
      },
    );
  }
}
```

---

# ✨ CREATE Operation

```dart
Future<FooBar> create(FooBar foobar) async {
  // Generate ID if not provided
  final newFoobar = FooBar(
    id: foobar.id ?? _generateId(),
    foo: foobar.foo,
    bar: foobar.bar,
  );

  // Create transaction
  final transaction = _db!.transaction(_storeName, 'readwrite');
  final store = transaction.objectStore(_storeName);

  // Store the record
  await store.put(newFoobar.toJson());
  await transaction.completed;

  return newFoobar;
}

String _generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString() + 
         '_' + (DateTime.now().microsecond % 1000).toString();
}
```

**Teaching Point**: Transaction-based operations ensure data consistency!

---

# 📖 READ Operations

## Get All Records

```dart
Future<List<FooBar>> getAll() async {
  final transaction = _db!.transaction(_storeName, 'readonly');
  final store = transaction.objectStore(_storeName);
  
  final List<FooBar> results = [];
  
  // Use cursor to iterate through all records
  await for (final cursor in store.openCursor(autoAdvance: true)) {
    // ⭐ Safe type conversion - this is crucial!
    final dartMap = _jsObjectToDartMap(cursor.value);
    results.add(FooBar.fromJson(dartMap));
  }
  
  return results;
}
```

## Search with Filtering

```dart
Future<List<FooBar>> searchByFoo(String searchTerm) async {
  final allRecords = await getAll();
  
  return allRecords
      .where((foobar) => foobar.foo
          .toLowerCase()
          .contains(searchTerm.toLowerCase()))
      .toList();
}
```

---

# ✏️ UPDATE and 🗑️ DELETE Operations

## Update Record

```dart
Future<FooBar> update(String id, FooBar updatedFoobar) async {
  final foobarToUpdate = FooBar(
    id: id,  // Preserve the ID
    foo: updatedFoobar.foo,
    bar: updatedFoobar.bar,
  );

  final transaction = _db!.transaction(_storeName, 'readwrite');
  final store = transaction.objectStore(_storeName);

  await store.put(foobarToUpdate.toJson());
  await transaction.completed;
  
  return foobarToUpdate;
}
```

## Delete Record

```dart
Future<bool> delete(String id) async {
  final transaction = _db!.transaction(_storeName, 'readwrite');
  final store = transaction.objectStore(_storeName);

  await store.delete(id);
  await transaction.completed;
  
  return true;
}
```

---

# 📁 File Import/Export Features

## Export to JSON (Browser Download)

```dart
Future<int> exportToJsonFile(String fileName) async {
  // Get all records
  final allFoobars = await crudService.getAll();
  
  // Convert to JSON
  final jsonList = allFoobars.map((f) => f.toJson()).toList();
  final jsonString = JsonEncoder.withIndent('  ').convert(jsonList);
  
  // Trigger browser download
  final blob = html.Blob([jsonString], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
    
  html.Url.revokeObjectUrl(url);
  return allFoobars.length;
}
```

**Student Activity**: Try this - it creates actual downloadable files!

---

# 📥 Import from JSON (File Upload)

```dart
Future<int> importFromJsonFile() async {
  // Create file input element
  final uploadInput = html.FileUploadInputElement()..accept = '.json';
  final completer = Completer<int>();

  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;
    if (files!.isEmpty) return;

    final file = files[0];
    final reader = html.FileReader();
    reader.readAsText(file);

    reader.onLoadEnd.listen((e) async {
      final jsonString = reader.result as String;
      
      // Parse and import records
      final List<dynamic> jsonList = jsonDecode(jsonString);
      int count = 0;
      
      for (final json in jsonList) {
        final foobar = FooBar.fromJson(json);
        await crudService.create(foobar);
        count++;
      }
      
      completer.complete(count);
    });
  });

  uploadInput.click(); // Open file dialog
  return await completer.future;
}
```

---

# 🌐 Why Web Server is Required

## 🚨 **Critical Understanding**

### ❌ Direct File Access (file://) FAILS

```javascript
// Opening index.html by double-clicking
file:///Users/student/project/index.html

// IndexedDB operations FAIL with:
// SecurityError: The operation is insecure
```

### ✅ Web Server Access (http://) WORKS

```javascript
// Serving via web server
http://localhost:8000/index.html

// IndexedDB operations SUCCEED
```

**Teaching Moment**: This mimics real-world deployment where websites are served via HTTP/HTTPS!

---

# 🔒 Browser Security Model

## Same-Origin Policy Enforcement

| Protocol | IndexedDB | Fetch API | ES6 Modules | Web Workers |
|----------|-----------|-----------|-------------|-------------|
| **file://** | ❌ Blocked | ❌ CORS errors | ❌ Blocked | ❌ Restricted |
| **http://** | ✅ Works | ✅ Works | ✅ Works | ✅ Works |
| **https://** | ✅ Works | ✅ Works | ✅ Works | ✅ Works |

## Simple Local Server Setup

```bash
# Python (built-in on most systems)
cd web && python3 -m http.server 8000

# Then open: http://localhost:8000
```

**Security Context**: Browsers trust HTTP-served content more than file system access!

---

# 🛠️ Dart to JavaScript Compilation

## Build Process

```bash
# 1. Write Dart code
# Files: lib/*.dart, web/main.dart

# 2. Compile to JavaScript
dart compile js web/main.dart -o web/main.dart.js

# 3. Serve via web server
cd web && python3 -m http.server 8000

# 4. Open in browser
# http://localhost:8000
```

## What Happens During Compilation

- 🔄 **Dart → JavaScript** conversion
- 📦 **Tree shaking** - removes unused code
- ⚡ **Optimization** - minification and performance tuning
- 🔗 **Library linking** - includes required dependencies

**Result**: Single `.js` file that runs in any modern browser!

---

# 🖥️ UI and Display Issues

## 🚨 **Common Student Problem**: Newlines Don't Display

### ❌ Wrong Approach

```dart
// This shows literal \n characters!
statusDiv.text = 'Line 1\\nLine 2\\nLine 3';
```

### ✅ Correct Solution

```dart
// HTML Setup with proper CSS
final statusDiv = html.DivElement()
  ..style.whiteSpace = 'pre-wrap'    // ⭐ Key CSS property!
  ..style.lineHeight = '1.4';

// Dart code with proper string handling
void addStatus(String message) {
  final currentText = statusDiv.text ?? '';
  final newText = currentText + '[$timestamp] $message\n';  // \n not \\n!
  statusDiv.text = newText;
}
```

**CSS Property**: `white-space: pre-wrap` preserves whitespace and newlines!

---

# 🧪 Testing Strategy

## Three Levels of Testing

### 1. **Unit Tests** (No Browser)
```bash
dart test  # Tests class structures and interfaces
```

### 2. **Compilation Test**
```bash
dart compile js web/main.dart -o web/main.dart.js
# Ensures code compiles without errors
```

### 3. **Browser Integration Test**
```bash
# Serve and test manually in browser
cd web && python3 -m http.server 8000
# Open http://localhost:8000 and test all features
```

**Teaching Point**: Different test levels catch different types of issues!

---

# 🔍 Common Student Errors and Solutions

## Error 1: Type Conversion

```dart
// ❌ Error: JsLinkedHashMap is not Map<String, dynamic>
final data = cursor.value as Map<String, dynamic>;

// ✅ Solution: Use safe conversion function
final data = _jsObjectToDartMap(cursor.value);
```

## Error 2: Import Paths

```dart
// ❌ Wrong: From web/main.dart
import 'lib/foobar.dart';

// ✅ Correct: From web/main.dart
import '../lib/foobar.dart';
```

## Error 3: IndexedDB Not Working

```dart
// ❌ Problem: Opening file directly
file:///path/to/index.html

// ✅ Solution: Use web server
http://localhost:8000/index.html
```

---

# ⚡ Performance Best Practices

## 1. Transaction Optimization

```dart
// ✅ Efficient: Batch operations in single transaction
final transaction = _db.transaction(_storeName, 'readwrite');
final store = transaction.objectStore(_storeName);

for (final record in manyRecords) {
  await store.put(record.toJson());  // Same transaction
}

await transaction.completed;  // Commit once

// ❌ Inefficient: Multiple transactions
for (final record in manyRecords) {
  await create(record);  // New transaction each time!
}
```

## 2. Error Handling

```dart
try {
  // IndexedDB operations
} on DatabaseError catch (e) {
  print('Database specific error: ${e.message}');
} catch (e) {
  print('General error: $e');
}
```

---

# 📊 Real-World Applications

## ✅ **Perfect Use Cases for IndexedDB**

- 📱 **Offline-first apps** - Work without internet
- 🎮 **Browser games** - Save progress locally
- 📝 **Note-taking apps** - Local draft storage
- 🛒 **E-commerce** - Shopping cart persistence
- 📊 **Data visualization** - Cache large datasets
- 📋 **Forms** - Auto-save user input

## ❌ **Not Suitable For**

- 🤝 **Real-time collaboration** - Use WebSocket + server DB
- 🔐 **Sensitive data** - Use encrypted server storage
- 📈 **Analytics** - Use server-side databases
- 👥 **Multi-user systems** - Use centralized databases

---

# 🎯 Deployment Workflow

## Development to Production

```bash
# 1. Development Phase
dart run                    # Test locally

# 2. Build Phase  
dart compile js web/main.dart -o web/main.dart.js

# 3. Deployment Phase
# Copy these files to web server:
# ├── index.html
# ├── main.dart.js
# └── any CSS/assets

# 4. Production
# Upload to: GitHub Pages, Netlify, Vercel, etc.
```

**Result**: Your Dart IndexedDB app runs anywhere on the web!

---

# 📚 Extended Learning Path

## Next Steps for Students

### **Immediate Practice**
1. 🛠️ **Build the demo** - Follow setup instructions
2. 🧪 **Experiment** - Add new fields to FooBar class
3. 🔍 **Debug** - Intentionally break things and fix them
4. 🎨 **Customize** - Improve the UI and add features

### **Advanced Topics**
- 📈 **IndexedDB indexes** and query optimization
- 👷 **Web Workers** for background database operations
- 📱 **Service Workers** for offline functionality
- 🔄 **Database migrations** and schema evolution
- 🌐 **Progressive Web Apps** (PWAs)

---

# 🆚 Learning Comparison: IndexedDB vs PocketBase

| Aspect | IndexedDB (This Project) | PocketBase (Previous Project) |
|--------|--------------------------|-------------------------------|
| **Location** | Browser (client-side) | Server (backend) |
| **Language** | Dart → JavaScript | Dart → HTTP calls |
| **Storage** | Browser database | SQLite database |
| **Networking** | None (local) | HTTP API calls |
| **Deployment** | Static hosting | Server required |
| **Collaboration** | Single user | Multi-user |
| **Learning Focus** | Client-side storage | Server-client architecture |

**Educational Value**: Both approaches teach different but complementary concepts!

---

# 🎓 Key Takeaways

## 🧠 **Technical Skills Learned**

✅ **Client-side databases** - IndexedDB API and concepts  
✅ **JavaScript interop** - Dart ↔ Browser API communication  
✅ **Web compilation** - Dart to JavaScript workflow  
✅ **Type safety** - Handling dynamic JavaScript objects  
✅ **Browser security** - Same-origin policy and secure contexts  
✅ **File operations** - Import/export in web browsers  

## 🎨 **Software Design Patterns**

✅ **Service layer** - Clean separation of database logic  
✅ **Data models** - Consistent object representation  
✅ **Error handling** - Robust exception management  
✅ **Transaction patterns** - Database consistency techniques  

---

# 🚀 Demo Time!

## Let's Build and Run Together

```bash
# 1. Clone or create the project
cd /path/to/foobar-indexeddb

# 2. Make scripts executable
chmod +x build_and_run.sh

# 3. Build and serve
./build_and_run.sh

# 4. Open browser to http://localhost:8000
# 5. Try all the features!
```

## What to Explore

1. 🔧 **Initialize Database** - Set up IndexedDB
2. 📝 **Add Sample Data** - Create test records
3. 👀 **View Records** - See all data
4. 🔍 **Search** - Filter by content
5. 📤 **Export JSON** - Download data file
6. 📥 **Import JSON** - Upload data file

---

# 🤝 Resources and Next Steps

## 📖 **Essential Documentation**

- [Dart IndexedDB API](https://api.dart.dev/stable/dart-indexed_db/dart-indexed_db-library.html)
- [MDN IndexedDB Guide](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
- [Dart Web Development](https://dart.dev/web)
- [JavaScript Interop](https://dart.dev/web/js-interop)

## 🛠️ **Development Tools**

- [VS Code Dart Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
- [Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools)
- [DartPad Online](https://dartpad.dev/)

## 💬 **Community Support**

- [Stack Overflow - Dart](https://stackoverflow.com/questions/tagged/dart)
- [Reddit r/dartlang](https://www.reddit.com/r/dartlang/)
- [Dart Discord](https://discord.gg/Qt6DgfAWWx)

---

# 🎯 Assignment Ideas

## 📝 **Beginner Level**
- Add a new field to FooBar (e.g., `date` or `category`)
- Implement search by the new field
- Add data validation (e.g., `bar` must be positive)

## 🚀 **Intermediate Level**
- Implement pagination for large datasets
- Add sorting functionality (by `foo` or `bar`)
- Create a backup/restore feature with timestamps

## 🏆 **Advanced Level**
- Build a complete task management app using IndexedDB
- Implement offline synchronization with a server
- Add data encryption for sensitive information
- Create a dashboard with statistics and charts

---

# 🎉 Conclusion

## What We've Accomplished Today

🎓 **Learned IndexedDB** - A powerful client-side database  
🔧 **Mastered compilation** - Dart to JavaScript workflow  
🐛 **Solved common issues** - Type conversion and display problems  
🌐 **Understood web deployment** - From development to production  
💡 **Gained practical skills** - Real-world web development patterns  

## Why This Matters

- 📱 **Modern web development** - Essential skill for 2025+
- 🏢 **Career relevance** - High demand for offline-capable apps
- 🧠 **Database concepts** - Transferable to other technologies
- 🔄 **Full-stack understanding** - Complements server-side knowledge

**Remember**: The best way to learn is by building!

---

# 🙏 Thank You!

## Questions & Discussion

**Ready to build amazing offline web applications!**

🌟 **Next class**: Advanced database patterns and performance optimization  
🤝 **Office hours**: Available for individual project help  
📚 **Assignment**: Complete the demo and extend it with one new feature  

**Keep coding, keep learning!** 🚀

---