# JavaScript vs Dart PocketBase Implementation Comparison

This document compares the JavaScript and Dart implementations of PocketBase CRUD operations, showing how both use their respective official SDKs.

## 📦 SDK Dependencies

### JavaScript (Node.js)
```json
{
  "dependencies": {
    "pocketbase": "^0.22.0"
  }
}
```

### Dart
```yaml
dependencies:
  pocketbase: ^0.18.0
```

## 🔧 Initialization

### JavaScript
```javascript
import PocketBase from 'pocketbase';
const pb = new PocketBase('http://127.0.0.1:8090');
```

### Dart
```dart
import 'package:pocketbase/pocketbase.dart';
final pb = PocketBase('http://127.0.0.1:8090');
```

## 🔐 Authentication

### JavaScript
```javascript
await pb.collection('users').authWithPassword(email, password);
```

### Dart
```dart
await pb.collection('users').authWithPassword(email, password);
```

**Result:** Identical API!

## 📝 CRUD Operations Comparison

### CREATE

**JavaScript:**
```javascript
const record = { data: randomData() };
const created = await pb.collection('records').create(record);
```

**Dart:**
```dart
final record = { 'data': randomData() };
final created = await pb.collection('records').create(body: record);
```

**Key Difference:** Dart requires `body:` parameter name.

### READ

**JavaScript:**
```javascript
const result = await pb.collection('records').getList(number, blockSize);
```

**Dart:**
```dart
final result = await pb.collection('records').getList(
  page: number,
  perPage: blockSize,
);
```

**Key Difference:** Dart uses named parameters `page:` and `perPage:`.

### UPDATE

**JavaScript:**
```javascript
const updated = await pb.collection('records').update(firstRecord.id, data);
```

**Dart:**
```dart
final updated = await pb.collection('records').update(firstRecord.id, body: data);
```

**Key Difference:** Dart requires `body:` parameter name.

### DELETE

**JavaScript:**
```javascript
await pb.collection('records').delete(secondRecord.id);
```

**Dart:**
```dart
await pb.collection('records').delete(secondRecord.id);
```

**Result:** Identical API!

## 🏗️ Collection Creation

### JavaScript
```javascript
const newCollection = await pb.collections.create({
    name: 'records',
    type: 'base',
    fields: [
      {
        name: 'data',
        type: 'json',
        required: true,
        min: 3,
      }
    ],
    createRule: '@request.auth.id != ""',
    // ... other rules
});
```

### Dart
```dart
final collection = await pb.collections.create(body: {
  'name': 'records',
  'type': 'base', 
  'schema': [
    {
      'name': 'data',
      'type': 'json',
      'required': true,
      'options': {
        'maxSize': 2000000,
      }
    }
  ],
  'createRule': '@request.auth.id != ""',
  // ... other rules
});
```

**Key Differences:**
- Dart uses `body:` parameter
- Dart uses `'schema'` instead of `'fields'`
- Dart uses `'options'` for field configuration

## 📊 Data Types and Return Values

### JavaScript
- Returns plain JavaScript objects
- Dynamic typing
- Properties accessed with dot notation: `record.data.foo`

### Dart
- Returns `RecordModel` objects
- Static typing with compile-time checks  
- Properties accessed with bracket notation: `record.data['data']['foo']`

## 🔄 Random Data Generation

### JavaScript
```javascript
function randomData() {
    return {
        foo: Math.random().toString(36).substring(2, 10),
        bar: Math.floor(Math.random() * 1000)
    };
}
```

### Dart
```dart
Map<String, dynamic> randomData() {
  final random = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final randomString = String.fromCharCodes(
    Iterable.generate(8, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
  );
  final randomInt = random.nextInt(1000);
  return {
    'foo': randomString,
    'bar': randomInt,
  };
}
```

**Key Difference:** Dart requires manual implementation of base36 string generation.

## 📁 File Operations

### JavaScript
```javascript
import fs from 'fs/promises';
const fileContent = await fs.readFile(filePath, 'utf-8');
const records = JSON.parse(fileContent);
```

### Dart
```dart
import 'dart:io';
import 'dart:convert';
final file = File(filePath);
final fileContent = await file.readAsString();
final records = jsonDecode(fileContent) as List<dynamic>;
```

## ⚠️ Error Handling

### JavaScript
```javascript
try {
    const created = await pb.collection('records').create(record);
    console.log('Record uploaded:', created);
} catch (err) {
    console.error('Error uploading record:', err);
}
```

### Dart
```dart
try {
  final created = await pb.collection('records').create(body: record);
  print('Record uploaded: $created');
} catch (err) {
  print('Error uploading record: $err');
}
```

**Result:** Nearly identical patterns!

## 🎯 Summary of Key Differences

| Aspect | JavaScript | Dart |
|--------|------------|------|
| **Parameter Style** | Positional args | Named parameters (`body:`, `page:`, `perPage:`) |
| **Field Config** | `fields` array | `schema` array with `options` |
| **Return Types** | Plain objects | `RecordModel` objects |
| **Type Safety** | Runtime | Compile-time |
| **Data Access** | `record.data.foo` | `record.data['data']['foo']` |
| **Random Strings** | Built-in `toString(36)` | Manual implementation |
| **JSON Parsing** | `JSON.parse()` | `jsonDecode()` |

## 🔄 API Compatibility

Despite the differences in language syntax and some parameter naming, both implementations:

1. **Use official SDKs** - No raw HTTP calls needed
2. **Follow same patterns** - Authentication, CRUD, collection management
3. **Handle same data** - JSON structures, records, collections
4. **Provide same functionality** - All operations work identically
5. **Maintain type safety** - Each in their own language's style

The Dart implementation provides the **same functionality** as JavaScript with **better type safety** and **compile-time error checking**, while maintaining the **familiar PocketBase API patterns**.
