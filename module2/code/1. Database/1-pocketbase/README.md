# PocketBase Student Management Example

A comprehensive Dart example demonstrating PocketBase operations with a Student data model.

## 📚 What You'll Learn

This project demonstrates:
- ✅ **PocketBase setup** and initialization
- ✅ **CRUD operations** (Create, Read, Update, Delete)
- ✅ **Real-time data streaming** (simulated polling)
- ✅ **Query operations** (filtering, sorting, searching)
- ✅ **Collection management** and schema setup
- ✅ **Error handling** best practices
- ✅ **Data modeling** for REST API databases

## 🏗️ Project Structure

```
lib/
├── main.dart                              # Entry point and examples
├── models/
│   └── student.dart                       # Student data model
├── services/
│   └── pocketbase_student_service.dart    # PocketBase CRUD operations
└── examples/
    └── pocketbase_examples.dart           # Practical usage examples
```

## 🚀 Quick Start

### 1. Install PocketBase Server

Download PocketBase from [https://pocketbase.io/](https://pocketbase.io/):

```bash
# Download and extract PocketBase
wget https://github.com/pocketbase/pocketbase/releases/download/v0.20.0/pocketbase_0.20.0_linux_amd64.zip
unzip pocketbase_0.20.0_linux_amd64.zip

# Make executable and run
chmod +x pocketbase
./pocketbase serve
```

### 2. Install Dependencies

```bash
dart pub get
```

### 3. Start PocketBase Server

```bash
./pocketbase serve
```

The server will start at `http://127.0.0.1:8090`
- Admin panel: `http://127.0.0.1:8090/_/`
- API endpoint: `http://127.0.0.1:8090/api/`

### 4. Run the Example

```bash
dart run lib/main.dart
```

**Note:** The example can run in offline mode with mock data if PocketBase is not available.

## 📖 Code Examples

### Basic Student Model

```dart
class Student {
  final String id;
  final String name;
  final int age;
  final String major;
  final DateTime createdAt;

  // Convert to/from PocketBase
  Map<String, dynamic> toMap() { ... }
  factory Student.fromRecord(RecordModel record) { ... }
}
```

### CRUD Operations

```dart
// CREATE
String id = await PocketBaseStudentService.createStudent(student);

// READ
List<Student> students = await PocketBaseStudentService.getAllStudents();
Student? student = await PocketBaseStudentService.getStudentById(id);

// UPDATE
await PocketBaseStudentService.updateStudent(id, {'age': 21});

// DELETE
await PocketBaseStudentService.deleteStudent(id);
```

### Real-time Streaming (Simulated)

```dart
PocketBaseStudentService.getStudentsStream().listen((students) {
  print('Real-time update: ${students.length} students');
});
```

### Query Operations

```dart
// Filter by major
List<Student> csStudents = await PocketBaseStudentService
    .getStudentsByMajor('Computer Science');

// Filter by age range
List<Student> youngStudents = await PocketBaseStudentService
    .getStudentsByAgeRange(18, 25);

// Search by name
List<Student> results = await PocketBaseStudentService
    .searchStudentsByName('Alice');
```

### Collection Setup

```dart
// Set up the students collection with schema
await PocketBaseStudentService.setupCollection();
```

## 🛠️ Available Examples

Run the main.dart file to see these examples in action:

1. **Basic CRUD Example** - Create, read, update, delete operations
2. **Query Example** - Filtering and searching data
3. **Real-time Example** - Simulated live data streaming
4. **Advanced Example** - Batch operations and advanced features
5. **Error Handling Example** - Proper error management
6. **Setup Example** - Collection schema creation

## 🔧 Configuration Files

### pubspec.yaml
Contains all required dependencies:
- `pocketbase` - PocketBase client library
- `uuid` - For generating unique IDs
- `intl` - For date formatting

### PocketBase Server
The example expects PocketBase server to be running on `http://127.0.0.1:8090`.

## 📱 Platform Support

This example supports:
- ✅ **Console/CLI apps** (Dart)
- ✅ **Flutter mobile** (iOS/Android)
- ✅ **Flutter web**
- ✅ **Flutter desktop**

## 🎯 Learning Objectives

After studying this example, students will understand:

1. **REST API** operations and patterns
2. **Self-hosted database** management
3. **Real-time data** handling
4. **SQLite-based** backend operations
5. **Async programming** with Dart/Flutter
6. **Error handling** strategies
7. **Database abstraction** patterns

## 🔍 Key Concepts Demonstrated

### Data Modeling
- Converting between Dart objects and PocketBase records
- Handling timestamps and auto-generated IDs
- Designing REST API data structures

### PocketBase Operations
- Collection and record management
- Filtering and sorting with PocketBase syntax
- Real-time data polling strategies
- Schema definition and validation

### Best Practices
- Service pattern for database operations
- Error handling and logging
- Resource cleanup and connection management
- Offline functionality with mock data

## 🚨 Common Issues

### PocketBase Server Not Running
```
❌ PocketBase connection failed
```
**Solution:** Start PocketBase server with `./pocketbase serve`

### Missing Dependencies
```
❌ Package 'pocketbase' not found
```
**Solution:** Run `dart pub get` to install dependencies.

### Collection Not Found
```
❌ Collection 'students' not found
```
**Solution:** Run the setup example to create the collection or create it manually in the admin panel.

### Permission Errors
If you get permission errors, check your collection rules in the PocketBase admin panel:
```javascript
// For development - allow all operations
listRule: ""     // Public read
viewRule: ""     // Public read
createRule: ""   // Public create
updateRule: ""   // Public update
deleteRule: ""   // Public delete
```

## 🆚 PocketBase vs Firebase

### Similarities
- Real-time capabilities
- Easy CRUD operations
- NoSQL-style data handling
- Cross-platform support

### Differences
- **PocketBase**: Self-hosted, open-source, SQLite-based
- **Firebase**: Cloud-hosted, Google service, Firestore-based

### When to Choose PocketBase
- ✅ Need full control over your data
- ✅ Want to avoid vendor lock-in
- ✅ Prefer self-hosted solutions
- ✅ Building educational or internal projects
- ✅ Budget constraints (no usage fees)

## 📚 Additional Resources

- [PocketBase Documentation](https://pocketbase.io/docs/)
- [PocketBase GitHub](https://github.com/pocketbase/pocketbase)
- [Dart PocketBase Client](https://pub.dev/packages/pocketbase)
- [Dart Documentation](https://dart.dev/guides)

## 🎓 For Instructors

This example is designed for educational purposes and includes:
- Comprehensive code comments
- Step-by-step examples
- Error handling demonstrations
- Both online and offline modes
- Practical real-world scenarios
- Side-by-side comparison with Firebase patterns

Students can modify the Student model and service to practice with their own data structures.

### Comparison with Firebase Example
This PocketBase example mirrors the Firebase example structure to demonstrate:
- **Same API patterns** - Easy to switch between backends
- **Similar CRUD operations** - Transferable knowledge
- **Database abstraction** - Backend-agnostic application design
- **Educational continuity** - Students can compare approaches

## 🤝 Contributing

Feel free to:
- Add more example operations
- Improve error handling
- Add unit tests
- Extend the Student model
- Create additional data models
- Add real-time subscription features

## 📄 License

This educational example is provided as-is for learning purposes.
