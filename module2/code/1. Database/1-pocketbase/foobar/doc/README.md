# FooBar Dart Modules Documentation

This directory contains four Dart modules that demonstrate database operations with PocketBase. Each module serves a specific purpose in the data management workflow.

## 📁 Module Overview

| Module | Purpose | Usage |
|--------|---------|-------|
| **[foobar.dart](./foobar.md)** | Data Model | Define data structure and JSON serialization |
| **[foobar_create_collection.dart](./foobar_create_collection.md)** | Database Setup | Create PocketBase collection schema |
| **[foobar_crud.dart](./foobar_crud.md)** | CRUD Operations | Basic database operations (Create, Read, Update, Delete) |
| **[foobar_utility.dart](./foobar_utility.md)** | Advanced Operations | Import/Export, bulk operations, utility functions |

## 🚀 Quick Start

```dart
// 1. Create collection (run once)
dart run lib/foobar_create_collection.dart

// 2. Use in your application
final pb = PocketBase('http://127.0.0.1:8090');
final crudService = FooBarCrudService(pb);
final utility = FooBarUtility(crudService);

// Create data
final foobar = FooBar(foo: 'Hello', bar: 42);
await crudService.create(foobar);

// Export to JSON
await utility.exportToJsonFile('data.json');
```

## 🎯 Learning Path

1. **Start with**: `foobar.dart` - Understand the data model
2. **Setup database**: `foobar_create_collection.dart` - Create the schema
3. **Learn CRUD**: `foobar_crud.dart` - Basic operations
4. **Advanced features**: `foobar_utility.dart` - Import/export and utilities

## 📚 Documentation

### Individual Modules
- [Data Model (foobar.dart)](./foobar.md)
- [Collection Setup (foobar_create_collection.dart)](./foobar_create_collection.md) 
- [CRUD Operations (foobar_crud.dart)](./foobar_crud.md)
- [Utility Functions (foobar_utility.dart)](./foobar_utility.md)

### Learning Resources
- **[📖 Complete Tutorial](./tutorial.md)** - Step-by-step guide with exercises
- **[🧪 Testing Guide](../test/)** - Unit tests and examples
