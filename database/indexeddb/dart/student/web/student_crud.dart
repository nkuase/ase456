import 'package:idb_shim/idb.dart' as idb;
import 'package:idb_shim/idb_browser.dart';
import 'package:web/web.dart' hide Request, Event;
import 'student.dart';

// Global variables
const String dbName = 'StudentDatabase';
const String storeName = 'students';

/// Update status message on the web page
void updateStatus(String message, String type) {
  final statusElement = document.querySelector('#db-status') as HTMLElement?;
  if (statusElement != null) {
    statusElement.textContent = message;
    statusElement.className = 'status $type';
  }
  print('Status: $message');
}

/// Initialize IndexedDB database and object store
Future<idb.Database> initializeDatabase() async {
  try {
    updateStatus('🔧 Initializing database...', 'info');
    print('🔧 Starting database initialization...');

    final idbFactory = idbFactoryBrowser;
    print('✅ Got IDB factory');

    // Delete existing database for clean start
    await idbFactory.deleteDatabase(dbName);
    print('🗑️ Cleaned up existing database');

    // Open database and create object store
    final database = await idbFactory.open(dbName, version: 1,
        onUpgradeNeeded: (idb.VersionChangeEvent e) {
      final db = (e.target as idb.Request).result as idb.Database;
      print('🏗️ Creating database schema...');
      if (!db.objectStoreNames.contains(storeName)) {
        db.createObjectStore(storeName, keyPath: 'id');
        print('🏗️ Created object store: $storeName');
      }
    });

    updateStatus('✅ Database initialized successfully!', 'success');
    print('🏗️ Database ready: $dbName with store: $storeName');

    // Add sample data
    await addSampleData(database);

    return database;
  } catch (error) {
    updateStatus('❌ Failed to initialize database: $error', 'error');
    print('💥 Database initialization failed: $error');
    rethrow;
  }
}

/// Add sample student data
Future<void> addSampleData(idb.Database database) async {
  print('📊 Adding sample data...');

  final sampleStudents = [
    Student(
        id: 'S001', name: 'Alice Johnson', age: 20, major: 'Computer Science'),
    Student(id: 'S002', name: 'Bob Smith', age: 22, major: 'Mathematics'),
    Student(id: 'S003', name: 'Carol Davis', age: 21, major: 'Physics'),
    Student(id: 'S004', name: 'David Wilson', age: 23, major: 'Engineering'),
    Student(id: 'S005', name: 'Eva Martinez', age: 19, major: 'Biology'),
  ];

  for (final student in sampleStudents) {
    await createStudent(database, student);
  }

  print('📊 Successfully added ${sampleStudents.length} sample students');
}

/// CREATE: Add a new student
Future<void> createStudent(idb.Database database, Student student) async {
  try {
    print('💾 Creating student: ${student.id} - ${student.name}');

    final txn = database.transaction(storeName, 'readwrite');
    final store = txn.objectStore(storeName);

    await store.put(student.toMap(), student.id);
    await txn.completed;

    print('✅ Student created: ${student.id}');
  } catch (error) {
    print('💥 Create error: $error');
    rethrow;
  }
}

/// READ: Get a specific student by ID
Future<Student?> readStudent(idb.Database database, String studentId) async {
  try {
    print('🔍 Reading student: $studentId');

    final txn = database.transaction(storeName, 'readonly');
    final store = txn.objectStore(storeName);
    final result = await store.getObject(studentId);
    await txn.completed;

    if (result != null && result is Map) {
      final studentMap = Map<String, dynamic>.from(result as Map);
      final student = Student.fromMap(studentMap);
      print('✅ Found student: ${student.toString()}');
      return student;
    } else {
      print('⚠️ Student not found: $studentId');
      return null;
    }
  } catch (error) {
    print('💥 Read error: $error');
    return null;
  }
}

/// READ: Get all students
Future<List<Student>> readAllStudents(idb.Database database) async {
  print('🔍 Starting readAllStudents()');

  try {
    final txn = database.transaction(storeName, 'readonly');
    final store = txn.objectStore(storeName);
    final students = <Student>[];

    print('📊 Opening cursor...');

    // Get all records using cursor
    await for (final cursor in store.openCursor()) {
      print('📄 Found record: ${cursor.key}');
      try {
        final data = cursor.value;
        print('📄 Raw data: $data');

        if (data is Map) {
          final studentMap = Map<String, dynamic>.from(data);
          final student = Student.fromMap(studentMap);
          students.add(student);
          print('✅ Added student: ${student.name}');
        }
      } catch (parseError) {
        print('💥 Parse error for record ${cursor.key}: $parseError');
      }
    }

    await txn.completed;
    print('📊 readAllStudents() returning ${students.length} students');
    return students;
  } catch (error) {
    print('💥 readAllStudents() error: $error');
    return [];
  }
}

/// UPDATE: Modify student information
Future<bool> updateStudent(idb.Database database, String studentId,
    {String? name, int? age, String? major}) async {
  try {
    print('🔄 Updating student: $studentId');

    final existingStudent = await readStudent(database, studentId);
    if (existingStudent == null) {
      print('⚠️ Student not found for update: $studentId');
      return false;
    }

    final updatedStudent = Student(
      id: studentId,
      name: name ?? existingStudent.name,
      age: age ?? existingStudent.age,
      major: major ?? existingStudent.major,
    );

    final txn = database.transaction(storeName, 'readwrite');
    final store = txn.objectStore(storeName);
    await store.put(updatedStudent.toMap(), studentId);
    await txn.completed;

    print('✅ Student updated: ${updatedStudent.toString()}');
    return true;
  } catch (error) {
    print('💥 Update error: $error');
    return false;
  }
}

/// DELETE: Remove a student
Future<bool> deleteStudent(idb.Database database, String studentId) async {
  try {
    print('🗑️ Deleting student: $studentId');

    final existingStudent = await readStudent(database, studentId);
    if (existingStudent == null) {
      print('⚠️ Student not found for deletion: $studentId');
      return false;
    }

    final txn = database.transaction(storeName, 'readwrite');
    final store = txn.objectStore(storeName);
    await store.delete(studentId);
    await txn.completed;

    print('✅ Student deleted: $studentId');
    return true;
  } catch (error) {
    print('💥 Delete error: $error');
    return false;
  }
}

/// DELETE: Clear all students
Future<void> clearAllStudents(idb.Database database) async {
  try {
    print('🗑️ Clearing all students...');

    final txn = database.transaction(storeName, 'readwrite');
    final store = txn.objectStore(storeName);
    await store.clear();
    await txn.completed;

    print('✅ All students cleared');
  } catch (error) {
    print('💥 Clear all error: $error');
  }
}
