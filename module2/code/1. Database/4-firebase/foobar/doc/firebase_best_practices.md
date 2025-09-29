---
marp: true
theme: default
paginate: true
size: 16:9
header: 'Firebase Best Practices - Technical Guide'
footer: 'Database Programming Course - Advanced'
style: |
  .columns {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
  }
  .three-columns {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 0.5rem;
  }
  .code-small {
    font-size: 0.7em;
  }
---

# Firebase Best Practices
## Technical Deep Dive

**Advanced Database Programming Concepts**
*Error Handling, Testing, and Production Considerations*

---

# 🎯 Best Practices Overview

<div class="three-columns">

<div>

**🏗️ Code Structure**
- Separation of concerns
- Clear naming conventions
- Consistent error handling
- Proper abstraction layers

</div>

<div>

**🔒 Data Safety**
- Input validation
- Transaction safety
- Backup strategies
- Security rules

</div>

<div>

**⚡ Performance**
- Query optimization
- Connection management
- Caching strategies
- Batch operations

</div>

</div>

---

# 🛡️ Error Handling Patterns

<div class="columns">

<div class="code-small">

**❌ Poor Error Handling:**
```dart
Future<FooBar> create(FooBar foobar) async {
  // No try-catch - app crashes!
  Document doc = await _firestore
      .collection(_collectionName)
      .add(foobar.toMap());
  
  return foobar.copyWith(id: doc.id);
}
```

</div>

<div class="code-small">

**✅ Good Error Handling:**
```dart
Future<FooBar?> create(FooBar foobar) async {
  try {
    Document doc = await _firestore
        .collection(_collectionName)
        .add(foobar.toMap());
    
    return foobar.copyWith(id: doc.id);
  } catch (e) {
    _logError('create', e);
    return null; // Graceful failure
  }
}
```

</div>

</div>

**Key Principles:**
- Always use try-catch for async operations
- Return nullable types for operations that can fail
- Log errors with context for debugging

---

# 🔍 Input Validation

<div class="columns">

<div class="code-small">

**Model-Level Validation:**
```dart
class FooBar {
  final String foo;
  final int bar;

  FooBar({required this.foo, required this.bar}) {
    if (foo.isEmpty) {
      throw ArgumentError('foo cannot be empty');
    }
    if (bar < 0) {
      throw ArgumentError('bar must be non-negative');
    }
  }
}
```

</div>

<div class="code-small">

**Service-Level Validation:**
```dart
Future<FooBar?> create(FooBar foobar) async {
  // Validate before sending to Firebase
  if (!_isValidFooBar(foobar)) {
    print('❌ Invalid FooBar data');
    return null;
  }
  
  try {
    // Proceed with creation...
  } catch (e) {
    // Handle errors...
  }
}

bool _isValidFooBar(FooBar foobar) {
  return foobar.foo.isNotEmpty && 
         foobar.bar >= 0;
}
```

</div>

</div>

---

# 🔄 Connection Management

<div class="columns">

<div class="code-small">

**❌ Poor Connection Handling:**
```dart
class BadService {
  Future<void> doSomething() async {
    // Initialize every time - inefficient!
    Firestore.initialize("project-id");
    final firestore = Firestore.instance;
    
    // Do work...
    
    // Never close - resource leak!
  }
}
```

</div>

<div class="code-small">

**✅ Good Connection Handling:**
```dart
class GoodService {
  late Firestore _firestore;
  bool _initialized = false;

  Future<void> initialize() async {
    if (!_initialized) {
      Firestore.initialize("project-id");
      _firestore = Firestore.instance;
      _initialized = true;
    }
  }

  void close() {
    if (_initialized) {
      _firestore.close();
      _initialized = false;
    }
  }
}
```

</div>

</div>

---

# 🧪 Testing Strategies

## 1. Unit Testing (Models)

```dart
group('FooBar Model Tests', () {
  test('should validate required fields', () {
    expect(() => FooBar(foo: '', bar: -1), throwsArgumentError);
  });

  test('should serialize correctly', () {
    final foobar = FooBar(foo: 'test', bar: 42);
    final map = foobar.toMap();
    
    expect(map['foo'], equals('test'));
    expect(map['bar'], equals(42));
  });
});
```

**Focus**: Data integrity, serialization, business logic

---

# 🧪 Testing Strategies (continued)

## 2. Integration Testing (Services)

<div class="code-small">

```dart
group('Firebase Service Integration Tests', () {
  late FooBarCrudFirebase service;
  
  setUpAll(() async {
    service = FooBarCrudFirebase();
    await service.initialize(); // Use test Firebase project
  });
  
  tearDownAll(() {
    service.close();
  });

  test('should perform full CRUD workflow', () async {
    // CREATE
    final testFooBar = FooBar(foo: 'integration_test', bar: 999);
    final created = await service.create(testFooBar);
    expect(created, isNotNull);
    
    // READ
    final read = await service.read(created!.id!);
    expect(read?.foo, equals('integration_test'));
    
    // UPDATE
    await service.updateFields(created.id!, {'foo': 'updated'});
    final updated = await service.read(created.id!);
    expect(updated?.foo, equals('updated'));
    
    // DELETE
    final deleted = await service.delete(created.id!);
    expect(deleted, isTrue);
  });
});
```

</div>

---

# 📊 Query Optimization

<div class="columns">

<div class="code-small">

**❌ Inefficient Queries:**
```dart
// Gets ALL documents, filters in memory
Future<List<FooBar>> getActiveItems() async {
  final all = await readAll();
  return all.where((f) => f.bar > 0).toList();
}

// Multiple single reads
Future<List<FooBar>> getMultiple(List<String> ids) async {
  final results = <FooBar>[];
  for (final id in ids) {
    final item = await read(id);
    if (item != null) results.add(item);
  }
  return results;
}
```

</div>

<div class="code-small">

**✅ Optimized Queries:**
```dart
// Filter on server-side
Future<List<FooBar>> getActiveItems() async {
  final docs = await _firestore
      .collection(_collectionName)
      .where('bar', isGreaterThan: 0)
      .get();
  return docs.map((d) => FooBar.fromMap(d.map, d.id)).toList();
}

// Batch read (if supported) or limit concurrent reads
Future<List<FooBar>> getMultiple(List<String> ids) async {
  // Use Future.wait for concurrent reads
  final futures = ids.map((id) => read(id));
  final results = await Future.wait(futures);
  return results.whereType<FooBar>().toList();
}
```

</div>

</div>

---

# 🔒 Security Considerations

## Firebase Security Rules Example:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Only authenticated users can read/write foobars
    match /foobars/{document} {
      allow read, write: if request.auth != null;
      
      // Validate data structure
      allow create, update: if request.auth != null 
        && resource.data.keys().hasAll(['foo', 'bar'])
        && resource.data.foo is string
        && resource.data.bar is number;
    }
  }
}
```

**Key Points:**
- Authentication required
- Data structure validation
- Field type checking

---

# 🚨 Common Pitfalls

<div class="columns">

<div>

**❌ What NOT to Do:**

1. **No Error Handling**
   ```dart
   await firestore.collection('test').add(data);
   // What if network fails?
   ```

2. **Resource Leaks**
   ```dart
   Firestore.initialize(projectId);
   // Never call .close()
   ```

3. **Inefficient Queries**
   ```dart
   final all = await getAll();
   return all.where((x) => x.active);
   ```

</div>

<div>

**✅ Best Practices:**

1. **Always Handle Errors**
   ```dart
   try {
     await firestore.collection('test').add(data);
   } catch (e) {
     handleError(e);
   }
   ```

2. **Manage Resources**
   ```dart
   try {
     // use firestore
   } finally {
     firestore.close();
   }
   ```

3. **Server-Side Filtering**
   ```dart
   return await firestore
     .where('active', isEqualTo: true)
     .get();
   ```

</div>

</div>

---

# 📈 Performance Monitoring

<div class="code-small">

```dart
class PerformanceTracker {
  static Future<T> trackOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await operation();
      final duration = stopwatch.elapsedMilliseconds;
      
      print('✅ $operationName completed in ${duration}ms');
      return result;
    } catch (e) {
      final duration = stopwatch.elapsedMilliseconds;
      print('❌ $operationName failed after ${duration}ms: $e');
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }
}

// Usage:
final result = await PerformanceTracker.trackOperation(
  'create_foobar',
  () => service.create(foobar),
);
```

</div>

---

# 🎯 Production Checklist

## Before Deploying:

- ✅ **Error Handling**: All async operations wrapped in try-catch
- ✅ **Input Validation**: Data validated before database operations
- ✅ **Resource Management**: Connections properly opened/closed
- ✅ **Security Rules**: Firestore rules configured and tested
- ✅ **Performance**: Queries optimized for expected load
- ✅ **Monitoring**: Logging and error tracking in place
- ✅ **Testing**: Unit and integration tests passing
- ✅ **Backup Strategy**: Data backup and recovery plan
- ✅ **Documentation**: Code documented for maintenance
- ✅ **Environment Config**: Development vs production settings

---

# 🔧 Development vs Production

<div class="columns">

<div>

**Development Environment:**
```dart
class DevConfig {
  static const projectId = 'foobar-dev-12345';
  static const enableLogging = true;
  static const strictValidation = true;
  
  static void setup() {
    // Enable verbose logging
    // Use test data
    // Skip some validations for testing
  }
}
```

</div>

<div>

**Production Environment:**
```dart
class ProdConfig {
  static const projectId = 'foobar-prod-67890';
  static const enableLogging = false;
  static const strictValidation = true;
  
  static void setup() {
    // Minimal logging (errors only)
    // Real data with backup
    // Full validation enabled
  }
}
```

</div>

</div>

**Key Differences:**
- Different Firebase projects
- Different logging levels
- Different error handling strategies
- Different performance requirements

---

# 📚 Advanced Topics

## For Further Learning:

1. **Real-time Updates**
   ```dart
   Stream<List<FooBar>> watchAll() {
     return _firestore.collection(_collectionName)
         .stream()
         .map((docs) => docs.map((d) => FooBar.fromMap(d.map, d.id)).toList());
   }
   ```

2. **Batch Operations**
   ```dart
   Future<void> createMultiple(List<FooBar> foobars) async {
     final batch = _firestore.batch();
     for (final foobar in foobars) {
       batch.create(_firestore.collection(_collectionName).document(), foobar.toMap());
     }
     await batch.commit();
   }
   ```

3. **Transactions**
   ```dart
   await _firestore.runTransaction((transaction) async {
     // Atomic operations here
   });
   ```

---

# 🎓 Summary

## What Makes Good Firebase Code:

1. **🛡️ Robust Error Handling**: Never let the app crash
2. **🔍 Input Validation**: Validate early and often
3. **⚡ Efficient Queries**: Filter on server, not client
4. **🧪 Comprehensive Testing**: Unit + integration tests
5. **📊 Performance Monitoring**: Track and optimize
6. **🔒 Security First**: Rules and authentication
7. **📚 Clear Documentation**: Code that explains itself

## Remember:
- Start simple, add complexity gradually
- Always think about edge cases
- Test with real data volumes
- Monitor performance in production

---

# 🚀 Practice Exercises

## For Students:

1. **Add Validation**: Extend FooBar with field validation
2. **Implement Pagination**: Add limit and offset to queries  
3. **Add Caching**: Implement in-memory caching layer
4. **Error Recovery**: Add retry logic for failed operations
5. **Performance Testing**: Measure query performance with large datasets
6. **Security Rules**: Write and test Firestore security rules
7. **Real-time Features**: Add live data updates using streams

## Bonus Challenge:
Create a complete Flutter app using this Firebase backend!

---

# 🎉 Questions & Discussion

## Topics for Discussion:

- When to use Firebase vs traditional SQL databases?
- How to handle offline scenarios?
- What are the cost implications of different query patterns?
- How to migrate data between different database structures?
- Best practices for team collaboration on Firebase projects?

**Remember**: The best way to learn is by building real projects!

**Keep experimenting and asking questions!** 🚀

