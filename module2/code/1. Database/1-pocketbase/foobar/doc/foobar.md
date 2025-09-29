# FooBar Data Model

**File**: `lib/foobar.dart`  
**Purpose**: Define the data structure for FooBar records with JSON serialization support.

## 📋 Overview

The `FooBar` class is a simple data model that represents a record with two fields:
- `foo`: A string value
- `bar`: An integer value

## 🔧 Features

- ✅ **Immutable Properties**: Uses `required` parameters
- ✅ **JSON Serialization**: `fromJson()` and `toJson()` methods
- ✅ **Equality Comparison**: Overridden `==` operator and `hashCode`
- ✅ **Type Safety**: Strong typing with Dart's type system

## 💡 Usage Examples

### Basic Usage

```dart
import 'lib/foobar.dart';

// Create a FooBar instance
final foobar = FooBar(foo: 'Hello World', bar: 42);

print('foo: ${foobar.foo}'); // Output: foo: Hello World
print('bar: ${foobar.bar}'); // Output: bar: 42
```

### JSON Serialization

```dart
// Convert to JSON
final json = foobar.toJson();
print(json); // Output: {foo: Hello World, bar: 42}

// Create from JSON
final jsonData = {'foo': 'Test', 'bar': 123};
final foobarFromJson = FooBar.fromJson(jsonData);
```

### Equality Comparison

```dart
final foobar1 = FooBar(foo: 'test', bar: 1);
final foobar2 = FooBar(foo: 'test', bar: 1);
final foobar3 = FooBar(foo: 'test', bar: 2);

print(foobar1 == foobar2); // Output: true
print(foobar1 == foobar3); // Output: false
```

## 🎯 Key Methods

| Method | Purpose | Returns |
|--------|---------|---------|
| `FooBar()` | Constructor | `FooBar` instance |
| `fromJson()` | Create from JSON map | `FooBar` instance |
| `toJson()` | Convert to JSON map | `Map<String, dynamic>` |
| `==` | Equality comparison | `bool` |
| `hashCode` | Hash code for collections | `int` |

## 📝 Class Definition

```dart
class FooBar {
  String foo;
  int bar;

  FooBar({required this.foo, required this.bar});
  
  factory FooBar.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
  
  @override
  bool operator ==(Object other) { ... }
  
  @override
  int get hashCode { ... }
}
```

## 🔗 Related Modules

- **[foobar_crud.dart](./foobar_crud.md)**: Uses this model for database operations
- **[foobar_utility.dart](./foobar_utility.md)**: Uses this model for import/export operations
