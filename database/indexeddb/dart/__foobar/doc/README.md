# FooBar IndexedDB Dart Documentation

This documentation explains how to use IndexedDB with Dart for client-side data storage, including common issues and solutions.

## 📁 Project Structure

```
foobar/
├── lib/
│   ├── foobar.dart              # Data model class
│   ├── foobar_crud.dart         # CRUD operations with IndexedDB
│   └── foobar_utility.dart      # Import/export and utility functions
├── web/
│   ├── index.html               # Demo web page
│   ├── main.dart                # Main application entry point
│   ├── newline_test.html        # Test for proper newline display
│   └── test_direct_open.html    # Test file vs web server access
├── test/
│   └── foobar_crud_test.dart    # Unit tests
├── doc/                         # Documentation (Marp presentations)
├── pubspec.yaml                 # Dart dependencies
├── build_and_run.sh            # Build and run script
├── run_tests.sh                # Test runner script
└── README.md                   # Project overview
```

## 🚀 Quick Start

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

# Start a local web server (REQUIRED for IndexedDB)
cd web && python3 -m http.server 8000

# Open browser to http://localhost:8000
```

## 🔧 Technical Implementation

### JavaScript Interop Issues

**Problem**: IndexedDB returns JavaScript objects that Dart sees as `JsLinkedHashMap` instead of `Map<String, dynamic>`.

**Solution**: Use JSON serialization for safe type conversion:

```dart
Map<String, dynamic> _jsObjectToDartMap(dynamic jsObject) {
  if (jsObject == null) return {};
  
  // Use JSON encode/decode for safe conversion
  try {
    final jsonString = js_util.callMethod(html.window, 'JSON.stringify', [jsObject]);
    return jsonDecode(jsonString as String) as Map<String, dynamic>;
  } catch (e) {
    // Fallback: manual conversion
    final map = <String, dynamic>{};
    try {
      final keys = js_util.objectKeys(jsObject);
      for (final key in keys) {
        if (key != null) {
          final value = js_util.getProperty(jsObject, key);
          map[key.toString()] = value;
        }
      }
    } catch (e2) {
      print('Warning: Failed to convert JS object to Dart map: $e2');
    }
    return map;
  }
}
```

### Displaying Newlines in HTML

**Problem**: `\\n` characters display as literal text instead of line breaks.

**Solution**: Use CSS `white-space: pre-wrap` and proper string handling:

```dart
// HTML Setup
final statusDiv = html.DivElement()
  ..style.whiteSpace = 'pre-wrap'  // Preserve whitespace and line breaks
  ..style.lineHeight = '1.4';

// Dart String Handling
void addStatus(String message) {
  final statusDiv = html.document.getElementById('status');
  final timestamp = DateTime.now().toString().substring(11, 19);
  
  // Get current content and add new line
  final currentText = statusDiv?.text ?? '';
  final newText = currentText + '[$timestamp] $message\n';  // Use \n not \\n
  
  if (statusDiv != null) {
    statusDiv.text = newText;
    statusDiv.scrollTop = statusDiv.scrollHeight;
  }
}
```

### File Import Paths

**Important**: When compiling Dart to JavaScript, use relative imports from the web directory:

```dart
// In web/main.dart - CORRECT
import '../lib/foobar.dart';
import '../lib/foobar_crud.dart';
import '../lib/foobar_utility.dart';

// NOT this - INCORRECT
import 'lib/foobar.dart';
```

## 🌐 Web Server Requirements

### Why You Need a Web Server

IndexedDB **requires** HTTP/HTTPS protocol and will **not work** with `file://` protocol:

```javascript
// ❌ FAILS with file:///path/to/file.html
indexedDB.open('MyDB')  // SecurityError: The operation is insecure

// ✅ WORKS with http://localhost:8000/file.html
indexedDB.open('MyDB')  // Success!
```

### Browser Security Restrictions

| Feature | file:// | http://localhost |
|---------|---------|------------------|
| IndexedDB | ❌ Blocked | ✅ Works |
| Fetch API | ❌ CORS errors | ✅ Works |
| ES6 Modules | ❌ Blocked | ✅ Works |
| Web Workers | ❌ Restricted | ✅ Works |
| Service Workers | ❌ Blocked | ✅ Works |

### Local Server Options

```bash
# Python (built-in)
python3 -m http.server 8000

# Node.js
npx serve .

# Dart
dart run build_runner serve

# VS Code Extension
# Install "Live Server" extension
# Right-click HTML file → "Open with Live Server"
```

## 🧪 Testing

### Unit Tests (No Browser Required)

```bash
# Run structure and interface tests
dart test
```

### Integration Tests (Browser Required)

1. Compile to JavaScript: `dart compile js web/main.dart -o web/main.dart.js`
2. Serve via web server: `python3 -m http.server 8000`
3. Open browser to: `http://localhost:8000`
4. Test all functionality interactively

### Test Files

- `test/foobar_crud_test.dart` - Unit tests for code structure
- `web/newline_test.html` - Test proper newline display
- `web/test_direct_open.html` - Test file:// vs http:// differences

## 🔍 Common Issues and Solutions

### 1. Compilation Errors

**Error**: `Object?` can't be assigned to `Object`

**Solution**: Use proper type handling in JavaScript interop (see code above)

### 2. Display Issues

**Error**: Newlines show as `\\n` instead of line breaks

**Solution**: Use `white-space: pre-wrap` CSS and proper string concatenation

### 3. Import Errors

**Error**: Cannot find module/library

**Solution**: Check import paths - use `../lib/` from web directory

### 4. IndexedDB Not Working

**Error**: Database operations fail silently

**Solution**: Ensure you're using a web server, not opening files directly

### 5. Type Conversion Errors

**Error**: `JsLinkedHashMap` type errors

**Solution**: Use the `_jsObjectToDartMap` function for safe conversion

## 📊 Performance Tips

### 1. Transaction Optimization

```dart
// ✅ Good: Reuse transactions
final transaction = _db!.transaction(_storeName, 'readwrite');
final store = transaction.objectStore(_storeName);

await store.put(record1.toJson());
await store.put(record2.toJson());
await store.put(record3.toJson());

await transaction.completed;

// ❌ Avoid: Multiple transactions
await store1.put(record1.toJson());  // New transaction
await store2.put(record2.toJson());  // New transaction
await store3.put(record3.toJson());  // New transaction
```

### 2. Error Handling

```dart
try {
  // IndexedDB operations
} on DatabaseError catch (e) {
  throw Exception('Database error: ${e.message}');
} catch (e) {
  throw Exception('Unexpected error: $e');
}
```

### 3. Memory Management

```dart
// Always close database connections when done
void dispose() {
  _db?.close();
  _db = null;
}
```

## 🎓 Educational Value

This project teaches:

1. **Client-side databases** - IndexedDB concepts and usage
2. **JavaScript interop** - Calling browser APIs from Dart
3. **Web compilation** - Dart to JavaScript workflow
4. **Async programming** - Futures and error handling
5. **File operations** - Import/export in browsers
6. **Security concepts** - Same-origin policy and secure contexts

## 🔗 Resources

- [Dart IndexedDB API](https://api.dart.dev/stable/dart-indexed_db/dart-indexed_db-library.html)
- [MDN IndexedDB Guide](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
- [Dart Web Development](https://dart.dev/web)
- [JavaScript Interop](https://dart.dev/web/js-interop)

## 🆚 Comparison with PocketBase

| Aspect | IndexedDB | PocketBase |
|--------|-----------|------------|
| **Location** | Browser (client-side) | Server (backend) |
| **Network** | No network calls | HTTP API calls |
| **Scalability** | Single user | Multi-user |
| **Persistence** | Browser storage | Server database |
| **Offline** | Full offline support | Requires connection |
| **Setup** | No server needed | Requires server setup |
| **Data Sharing** | Browser-specific | Shared across users |

Both approaches are valuable for different use cases and provide excellent learning opportunities for database concepts and web development patterns.
