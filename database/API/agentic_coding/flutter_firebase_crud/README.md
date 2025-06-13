# Flutter Firebase CRUD Library

A comprehensive, ready-to-use Firebase CRUD library for Flutter applications. This library provides a simple and powerful interface for performing Create, Read, Update, and Delete operations with Firebase Firestore.

## Features

- 🔥 **Complete CRUD Operations**: Create, Read, Update, Delete
- 📊 **Real-time Streaming**: Listen to live data changes
- 🔍 **Advanced Queries**: Where conditions, ordering, limiting
- 📦 **Batch Operations**: Handle multiple documents at once
- ✅ **Type Safety**: Generic implementation with strong typing
- 🛡️ **Error Handling**: Comprehensive error management with FirebaseResult
- 📱 **Flutter Ready**: Optimized for Flutter applications

## Installation

1. Add this library to your Flutter project by copying the `lib` folder
2. Add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.24.2
  cloud_firestore: ^4.13.6
  firebase_auth: ^4.15.3
  firebase_storage: ^11.5.6
  uuid: ^4.2.1
  intl: ^0.19.0
```

3. Initialize Firebase in your `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

## Quick Start

### 1. Create a Model

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String name;
  final int age;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.name,
    required this.age,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String?,
      name: map['name'] as String,
      age: map['age'] as int,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
    };
  }
}
```

### 2. Create a Service

```dart
import '../lib/firebase_crud.dart';

class UserService extends FirebaseCrudService<User> {
  UserService()
      : super(
          collectionName: 'users',
          fromMap: User.fromMap,
          toMap: (user) => user.toMap(),
        );
}
```

### 3. Use in Your Widget

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final UserService _userService = UserService();

  Future<void> createUser() async {
    final user = User(name: 'John Doe', age: 30);
    final result = await _userService.create(user);
    
    result.fold(
      onSuccess: (id) => print('User created with ID: $id'),
      onError: (error) => print('Error: $error'),
    );
  }

  Future<void> loadUsers() async {
    final result = await _userService.readAll();
    
    result.fold(
      onSuccess: (users) {
        // Handle users list
        for (var user in users) {
          print('User: ${user.name}, Age: ${user.age}');
        }
      },
      onError: (error) => print('Error: $error'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<User>>(
        stream: _userService.streamAll(orderBy: 'createdAt', descending: true),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text('Age: ${user.age}'),
              );
            },
          );
        },
      ),
    );
  }
}
```

## Available Operations

### Create Operations
```dart
// Create a single document
final result = await service.create(item);

// Create with custom ID
final result = await service.create(item, customId: 'my-custom-id');

// Create multiple documents
final result = await service.createBatch([item1, item2, item3]);
```

### Read Operations
```dart
// Read a single document
final result = await service.read('document-id');

// Read all documents
final result = await service.readAll();

// Read with ordering and limiting
final result = await service.readAll(
  orderBy: 'createdAt',
  descending: true,
  limit: 10,
);

// Read with conditions
final result = await service.readWhere(
  field: 'age',
  value: 18,
  operator: '>=',
  orderBy: 'name',
);

// Count documents
final result = await service.count();

// Check if document exists
final result = await service.exists('document-id');
```

### Update Operations
```dart
// Update entire document
final result = await service.update('document-id', updatedItem);

// Update specific fields
final result = await service.updateFields('document-id', {
  'name': 'New Name',
  'age': 25,
});
```

### Delete Operations
```dart
// Delete a single document
final result = await service.delete('document-id');

// Delete multiple documents with condition
final result = await service.deleteWhere(
  field: 'age',
  value: 18,
  operator: '<',
);
```

### Stream Operations (Real-time)
```dart
// Stream all documents
final stream = service.streamAll(orderBy: 'createdAt');

// Stream a single document
final stream = service.streamDocument('document-id');

// Stream with conditions
final stream = service.streamWhere(
  field: 'active',
  value: true,
  operator: '==',
);
```

## Query Operators

The library supports all Firestore query operators:

- `==` (equal to)
- `!=` (not equal to)
- `>` (greater than)
- `>=` (greater than or equal to)
- `<` (less than)
- `<=` (less than or equal to)
- `array-contains`
- `in`

## Error Handling

The library uses `FirebaseResult<T>` for comprehensive error handling:

```dart
final result = await service.create(item);

// Method 1: Using fold
result.fold(
  onSuccess: (id) => print('Success: $id'),
  onError: (error) => print('Error: $error'),
);

// Method 2: Using properties
if (result.isSuccess) {
  print('Success: ${result.value}');
} else {
  print('Error: ${result.errorMessage}');
}

// Method 3: Using map
final mappedResult = result.map((id) => 'Document ID: $id');
```

## Example Project

Check the `example/main.dart` file for a complete working example that demonstrates:

- Creating items with form input
- Displaying items in a list
- Updating items
- Deleting items
- Real-time updates
- Error handling

## Best Practices

1. **Always handle errors**: Use the `FirebaseResult` to handle both success and error cases
2. **Use streams for real-time data**: Prefer `streamAll()` over `readAll()` for live updates
3. **Implement proper models**: Always create proper model classes with `fromMap` and `toMap` methods
4. **Use batch operations**: For multiple operations, use `createBatch()` for better performance
5. **Add timestamps**: The library automatically adds `createdAt` and `updatedAt` timestamps

## Firebase Security Rules

Make sure your Firestore security rules allow the operations you need:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Example rule - adjust based on your needs
    match /{collection}/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Contributing

Feel free to contribute to this library by submitting issues, feature requests, or pull requests.

## License

This library is open source and available under the MIT License.