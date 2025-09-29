# Firebase FooBar CRUD Demo

A simple educational project demonstrating Firebase/Firestore CRUD operations using Dart.

## 🎯 Learning Objectives

This project helps students understand:
- Firebase/Firestore CRUD operations (Create, Read, Update, Delete)
- Data modeling with Dart classes
- Serialization for database storage
- Error handling in database operations
- Unit testing for database applications
- Project structure and organization

## 📁 Project Structure

```
foobar/
├── lib/
│   ├── models/
│   │   └── foobar.dart                    # Simple data model (foo: String, bar: int)
│   ├── services/
│   │   └── foobar_crud_firebase.dart      # All CRUD operations
│   ├── main.dart                          # Demo application
│   └── firebase-config.json              # Firebase configuration
├── test/                                  # Unit tests
│   ├── foobar_model_test.dart            # Model testing
│   ├── foobar_service_test.dart          # Service testing
│   └── main_test.dart                    # Main app testing
├── doc/                                   # Documentation
│   ├── firebase_crud_slides.md           # Main tutorial slides
│   └── firebase_best_practices.md        # Advanced concepts
├── pubspec.yaml                          # Dependencies
└── run.sh                                # Educational script
```

## 🚀 Quick Start

### Prerequisites
- Dart SDK installed ([installation guide](https://dart.dev/get-dart))

### Running the Demo

1. **Easy way (recommended for first time):**
   ```bash
   ./run.sh
   ```
   This runs the complete educational workflow: checks dependencies, runs tests, demonstrates CRUD operations, and shows learning summaries.

2. **Individual components:**
   ```bash
   ./run.sh test      # Run unit tests only
   ./run.sh demo      # Run CRUD demo only
   ./run.sh docs      # View presentation slides
   ./run.sh structure # Show project organization
   ```

3. **Manual approach:**
   ```bash
   dart pub get          # Install dependencies
   dart test             # Run tests
   dart run lib/main.dart # Run demo
   ```

## 📚 What You'll Learn

### 1. Data Modeling (`lib/models/foobar.dart`)
- Simple Dart class with two fields: `foo` (String) and `bar` (int)
- Serialization methods for Firebase storage
- Copy methods for immutable updates
- Proper equality and toString implementations

### 2. CRUD Operations (`lib/services/foobar_crud_firebase.dart`)
- **CREATE**: Add new documents to Firebase
- **READ**: Retrieve single documents and collections
- **QUERY**: Filter documents with where clauses
- **UPDATE**: Modify existing documents (full and partial)
- **DELETE**: Remove documents from collections

### 3. Error Handling
- Try-catch blocks for all async operations
- Graceful failure with null returns
- Logging for debugging and monitoring

### 4. Testing (`test/` directory)
- Unit tests for data models
- Service structure validation
- Edge case handling
- Test organization and best practices

## 🔥 Key Concepts Demonstrated

### Firebase/Firestore Basics
```dart
// Initialize connection
await crudService.initialize();

// Create a document
FooBar newItem = FooBar(foo: 'hello', bar: 42);
FooBar? created = await crudService.create(newItem);

// Read documents
List<FooBar> all = await crudService.readAll();
FooBar? single = await crudService.read(documentId);

// Query with filters
List<FooBar> filtered = await crudService.readByBar(42);

// Update documents
await crudService.update(id, updatedItem);
await crudService.updateFields(id, {'foo': 'updated'});

// Delete documents
await crudService.delete(id);

// Always close when done
crudService.close();
```

### Data Serialization
```dart
// Convert to Map for Firebase storage
Map<String, dynamic> toMap() {
  return {'foo': foo, 'bar': bar};
}

// Create from Map (from Firebase)
static FooBar fromMap(Map<String, dynamic> map, [String? id]) {
  return FooBar(
    id: id,
    foo: map['foo'] ?? '',
    bar: map['bar'] ?? 0,
  );
}
```

## 🧪 Testing

The project includes comprehensive tests:

```bash
# Run all tests
dart test

# Run with detailed output
dart test --reporter=expanded

# Run specific test file
dart test test/foobar_model_test.dart
```

**Test Coverage:**
- Model validation and serialization
- Service method availability
- Random data generation
- Edge cases and error conditions

## 📖 Documentation

Interactive presentation slides are available in the `doc/` directory:

1. **`firebase_crud_slides.md`** - Main tutorial covering CRUD operations
2. **`firebase_best_practices.md`** - Advanced concepts and best practices

View as slides using Marp:
```bash
npx @marp-team/marp-cli doc/firebase_crud_slides.md --html
```

Or use the convenient script:
```bash
./run.sh docs
```

## 🔧 Configuration

The project uses a test Firebase configuration in `lib/firebase-config.json`. For production use:

1. Create your own Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Set up Firestore database
3. Update the configuration file with your project details
4. Set up security rules for production

## 🚨 Common Issues

### "Dart not found"
Install Dart SDK from https://dart.dev/get-dart

### "Permission denied" when running run.sh
Make the script executable:
```bash
chmod +x run.sh
```

### Firebase connection errors
This is expected with the demo configuration. The project includes error handling to demonstrate how operations would work with a real Firebase setup.

## 🎓 For Students

### Next Steps
1. **Modify the model** - Add more fields to FooBar
2. **Extend queries** - Add more filtering options
3. **Improve error handling** - Add retry logic
4. **Add validation** - Validate data before database operations
5. **Build a UI** - Create a Flutter app using this backend

### Learning Path
1. Start with this simple example
2. Understand each CRUD operation
3. Run and modify the tests
4. Read the documentation slides
5. Experiment with the code
6. Build your own Firebase project

## 📚 Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Development](https://flutter.dev/docs)
- [FireDart Package](https://pub.dev/packages/firedart)

## 💬 Support

- Review the presentation slides in the `doc/` directory
- Check the comprehensive comments in the source code
- Run `./run.sh help` for command options
- Ask questions during class or office hours

---

**Happy Learning!** 🚀

This project provides a solid foundation for understanding Firebase CRUD operations and serves as a stepping stone to more complex database applications.
