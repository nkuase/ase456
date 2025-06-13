import 'package:uuid/uuid.dart';

// Simple console app to demonstrate database abstraction
// Run with: dart run example/simple_demo.dart

// Mock implementations for demonstration
abstract class DatabaseInterface {
  String get name;
  Future<void> initialize();
  Future<void> create(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getAll();
  Future<void> close();
}

class MockSQLiteDatabase implements DatabaseInterface {
  final List<Map<String, dynamic>> _data = [];

  @override
  String get name => 'SQLite';

  @override
  Future<void> initialize() async {
    print('📂 Initializing SQLite database...');
    await Future.delayed(const Duration(milliseconds: 100));
    print('✅ SQLite database ready!');
  }

  @override
  Future<void> create(Map<String, dynamic> data) async {
    print('💾 SQLite: INSERT INTO students VALUES (${data['name']})');
    _data.add(data);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    print('🔍 SQLite: SELECT * FROM students ORDER BY name');
    return List.from(_data)..sort((a, b) => a['name'].compareTo(b['name']));
  }

  @override
  Future<void> close() async {
    print('🔒 SQLite database connection closed');
  }
}

class MockIndexedDBDatabase implements DatabaseInterface {
  final List<Map<String, dynamic>> _data = [];

  @override
  String get name => 'IndexedDB';

  @override
  Future<void> initialize() async {
    print('🌐 Initializing IndexedDB in browser...');
    await Future.delayed(const Duration(milliseconds: 150));
    print('✅ IndexedDB object store ready!');
  }

  @override
  Future<void> create(Map<String, dynamic> data) async {
    print('💾 IndexedDB: store.add(${data['name']})');
    _data.add(data);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    print('🔍 IndexedDB: cursor.openCursor() iteration');
    return List.from(_data)..sort((a, b) => a['name'].compareTo(b['name']));
  }

  @override
  Future<void> close() async {
    print('🔒 IndexedDB connection closed');
  }
}

class MockPocketBaseDatabase implements DatabaseInterface {
  final List<Map<String, dynamic>> _data = [];

  @override
  String get name => 'PocketBase';

  @override
  Future<void> initialize() async {
    print('☁️  Connecting to PocketBase server...');
    await Future.delayed(const Duration(milliseconds: 200));
    print('✅ PocketBase API ready!');
  }

  @override
  Future<void> create(Map<String, dynamic> data) async {
    print('💾 PocketBase: POST /api/collections/students/records');
    print('   📤 Sending JSON: ${data['name']}');
    _data.add(data);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    print('🔍 PocketBase: GET /api/collections/students/records?sort=name');
    return List.from(_data)..sort((a, b) => a['name'].compareTo(b['name']));
  }

  @override
  Future<void> close() async {
    print('🔒 PocketBase HTTP client closed');
  }
}

// Service that can work with any database implementation
class StudentService {
  DatabaseInterface? _database;
  final _uuid = const Uuid();

  Future<void> switchDatabase(DatabaseInterface newDatabase) async {
    if (_database != null) {
      await _database!.close();
    }

    _database = newDatabase;
    await _database!.initialize();
    print('🔄 Switched to ${_database!.name} database\n');
  }

  Future<void> addStudent(String name, String major, int age) async {
    if (_database == null) throw Exception('No database connected');

    final student = {
      'id': _uuid.v4(),
      'name': name,
      'major': major,
      'age': age,
      'created_at': DateTime.now().toIso8601String(),
    };

    await _database!.create(student);
    print('➕ Added student: $name\n');
  }

  Future<void> listAllStudents() async {
    if (_database == null) throw Exception('No database connected');

    final students = await _database!.getAll();

    print('📋 All students in ${_database!.name}:');
    if (students.isEmpty) {
      print('   (No students found)');
    } else {
      for (final student in students) {
        print(
            '   • ${student['name']} (${student['major']}, age ${student['age']})');
      }
    }
    print('');
  }
}

void main() async {
  print('🎓 Database Abstraction Demo');
  print('=============================\n');

  final service = StudentService();

  // Create sample students
  final sampleStudents = [
    {'name': 'Alice Johnson', 'major': 'Computer Science', 'age': 20},
    {'name': 'Bob Smith', 'major': 'Mathematics', 'age': 22},
    {'name': 'Charlie Brown', 'major': 'Physics', 'age': 21},
  ];

  // Test with each database implementation
  final databases = [
    MockSQLiteDatabase(),
    MockIndexedDBDatabase(),
    MockPocketBaseDatabase(),
  ];

  for (final database in databases) {
    print('🔥 Testing ${database.name} Implementation');
    print('=' * 40);

    // Switch to this database
    await service.switchDatabase(database);

    // Add sample students
    for (final student in sampleStudents) {
      await service.addStudent(
        student['name'] as String,
        student['major'] as String,
        student['age'] as int,
      );
    }

    // List all students
    await service.listAllStudents();

    // Close database
    await database.close();
    print('');
  }

  print('🎯 Key Takeaways:');
  print('==================');
  print('✨ Same StudentService code worked with ALL database implementations!');
  print('✨ Each database has different internal behavior, but same interface');
  print('✨ Easy to switch between databases at runtime');
  print('✨ Code is flexible, testable, and maintainable');
  print('');
  print('🚀 This is the power of interface-based programming!');
  print('   The same principles work for ANY abstractions:');
  print('   • File storage (local, cloud, database)');
  print('   • Authentication (email, social, biometric)');
  print('   • Payment processing (credit card, PayPal, crypto)');
  print('   • Notifications (email, SMS, push)');
  print('');
  print('💡 Master this pattern and build better software! 🎓');
}
