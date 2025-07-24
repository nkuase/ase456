/*
 * IndexedDB CRUD Operations Tutorial
 * Demonstrates Create, Read, Update, Delete operations using Dart and IndexedDB
 * 
 * Learning Objectives:
 * 1. Understand how to initialize IndexedDB
 * 2. Learn CRUD operations with practical examples
 * 3. Handle asynchronous database operations
 * 4. Manage transactions and error handling
 */

import 'dart:js_interop';
import 'dart:js_util';
import 'package:web/web.dart' as web;
import 'package:indexed_db/indexed_db.dart' as idb;

// Database configuration constants
const String dbName = 'UniversityDB';
const String storeName = 'students';
const int dbVersion = 1;

// Global variables for database management
late idb.Database database;
late web.HTMLElement outputDiv;
late web.HTMLElement statusDiv;

// Student data model
class Student {
  final String id;
  final String name;
  final int age;
  final String major;

  Student({
    required this.id,
    required this.name,
    required this.age,
    required this.major,
  });

  // Convert student to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'major': major,
    };
  }

  // Create student from Map
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      major: map['major'] as String,
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, age: $age, major: $major}';
  }
}

void main() async {
  print('🎓 Starting IndexedDB CRUD Tutorial...');

  try {
    // Get HTML elements for interaction with proper casting
    final outputElement = web.document.getElementById('output') as web.HTMLElement?;
    final statusElement = web.document.getElementById('db-status') as web.HTMLElement?;
    
    if (outputElement == null || statusElement == null) {
      print('❌ Required HTML elements not found!');
      return;
    }
    
    outputDiv = outputElement;
    statusDiv = statusElement;
    
    // Clear initial content
    outputDiv.textContent = '';
    statusDiv.textContent = '';

    // Initialize the database
    await initializeDatabase();

    // Set up event listeners for UI interactions
    setupEventListeners();

    log('✅ Application initialized successfully!');
    log('👉 Use the interface above to perform CRUD operations');
    
  } catch (error) {
    print('❌ Failed to initialize application: $error');
  }
}

/// Initialize IndexedDB database and object store
Future<void> initializeDatabase() async {
  try {
    updateStatus('🔧 Initializing database...', 'info');

    final factory = idb.IdbFactory();

    // Delete existing database for clean start (useful for development)
    factory.deleteDatabase(dbName);
    log('🗑️ Cleaned up existing database');

    // Create database with object store
    final result = await factory.openCreate(dbName, storeName);
    database = result.database;

    updateStatus('✅ Database initialized successfully!', 'success');
    log('🏗️ Created database: $dbName with store: $storeName');

    // Add some sample data for demonstration
    await addSampleData();
    
  } catch (error) {
    updateStatus('❌ Failed to initialize database: $error', 'error');
    log('💥 Database initialization failed: $error');
    rethrow;
  }
}

/// Add sample student data for demonstration
Future<void> addSampleData() async {
  final sampleStudents = [
    Student(
      id: 'S001',
      name: 'Alice Johnson',
      age: 20,
      major: 'Computer Science',
    ),
    Student(
      id: 'S002', 
      name: 'Bob Smith', 
      age: 22, 
      major: 'Mathematics'
    ),
    Student(
      id: 'S003', 
      name: 'Carol Davis', 
      age: 21, 
      major: 'Physics'
    ),
  ];

  for (final student in sampleStudents) {
    await createStudent(student);
  }

  log('📊 Added ${sampleStudents.length} sample students');
}

/// CREATE: Add a new student to the database
Future<void> createStudent(Student student) async {
  try {
    // Create a read-write transaction
    final transaction = database.transactionList([storeName], 'readwrite');
    final store = transaction.objectStore(storeName);

    // Convert Dart Map to JavaScript object for IndexedDB
    final jsData = jsify(student.toMap());
    
    // Store the student data using student ID as key
    store.put(jsData, student.id);

    // Wait for transaction to complete
    await transaction.completed;

    log('✅ CREATE: Added student ${student.id} - ${student.name}');
    
  } catch (error) {
    log('❌ CREATE ERROR: Failed to add student: $error');
    rethrow;
  }
}

/// READ: Get a specific student by ID
Future<Student?> readStudent(String studentId) async {
  try {
    // Create a read-only transaction
    final transaction = database.transactionList([storeName], 'readonly');
    final store = transaction.objectStore(storeName);

    // Get the student data
    final result = await store.getObject(studentId);

    if (result != null) {
      // Convert JavaScript object back to Dart Map
      final dartData = dartify(result);
      final studentMap = Map<String, dynamic>.from(dartData as Map);
      final student = Student.fromMap(studentMap);
      log('✅ READ: Found student ${student.id} - ${student.name}');
      return student;
    } else {
      log('⚠️ READ: Student with ID $studentId not found');
      return null;
    }
    
  } catch (error) {
    log('❌ READ ERROR: Failed to get student: $error');
    return null;
  }
}

/// READ: Get all students from the database
Future<List<Student>> readAllStudents() async {
  try {
    final transaction = database.transactionList([storeName], 'readonly');
    final store = transaction.objectStore(storeName);

    // Get all records using cursor
    final students = <Student>[];

    await for (final cursorWithValue in store.openCursor(autoAdvance: true)) {
      // Convert JavaScript object back to Dart Map
      final dartData = dartify(cursorWithValue.value);
      final studentData = Map<String, dynamic>.from(dartData as Map);
      students.add(Student.fromMap(studentData));
    }

    log('✅ READ ALL: Retrieved ${students.length} students');
    return students;
    
  } catch (error) {
    log('❌ READ ALL ERROR: Failed to get all students: $error');
    return [];
  }
}

/// UPDATE: Modify an existing student's information
Future<bool> updateStudent(
  String studentId, {
  String? name,
  int? age,
  String? major,
}) async {
  try {
    // First, check if student exists
    final existingStudent = await readStudent(studentId);
    if (existingStudent == null) {
      log('⚠️ UPDATE: Student with ID $studentId not found');
      return false;
    }

    // Create updated student with new values or keep existing ones
    final updatedStudent = Student(
      id: studentId,
      name: name ?? existingStudent.name,
      age: age ?? existingStudent.age,
      major: major ?? existingStudent.major,
    );

    // Update the record
    final transaction = database.transactionList([storeName], 'readwrite');
    final store = transaction.objectStore(storeName);

    // Convert Dart Map to JavaScript object for IndexedDB
    final jsData = jsify(updatedStudent.toMap());
    
    store.put(jsData, studentId);
    await transaction.completed;

    log('✅ UPDATE: Modified student ${updatedStudent.id} - ${updatedStudent.name}');
    return true;
    
  } catch (error) {
    log('❌ UPDATE ERROR: Failed to update student: $error');
    return false;
  }
}

/// DELETE: Remove a student from the database
Future<bool> deleteStudent(String studentId) async {
  try {
    // Check if student exists first
    final existingStudent = await readStudent(studentId);
    if (existingStudent == null) {
      log('⚠️ DELETE: Student with ID $studentId not found');
      return false;
    }

    // Delete the record
    final transaction = database.transactionList([storeName], 'readwrite');
    final store = transaction.objectStore(storeName);

    store.delete(studentId);
    await transaction.completed;

    log('✅ DELETE: Removed student $studentId');
    return true;
    
  } catch (error) {
    log('❌ DELETE ERROR: Failed to delete student: $error');
    return false;
  }
}

/// DELETE: Clear all students from the database
Future<void> clearAllStudents() async {
  try {
    final transaction = database.transactionList([storeName], 'readwrite');
    final store = transaction.objectStore(storeName);

    store.clear();
    await transaction.completed;

    log('✅ CLEAR ALL: Removed all students from database');
    
  } catch (error) {
    log('❌ CLEAR ERROR: Failed to clear all students: $error');
  }
}

// =============================================================================
// UI INTERACTION FUNCTIONS (Event Handlers)
// =============================================================================

/// Set up event listeners for all buttons
void setupEventListeners() {
  try {
    // Add Student button
    final addBtn = web.document.getElementById('add-student-btn');
    if (addBtn != null) {
      addBtn.addEventListener('click', ((web.Event event) => handleAddStudent()).toJS);
    }

    // Get All Students button
    final getAllBtn = web.document.getElementById('get-all-students-btn');
    if (getAllBtn != null) {
      getAllBtn.addEventListener('click', ((web.Event event) => handleGetAllStudents()).toJS);
    }

    // Get Student button
    final getBtn = web.document.getElementById('get-student-btn');
    if (getBtn != null) {
      getBtn.addEventListener('click', ((web.Event event) => handleGetStudent()).toJS);
    }

    // Update Student button
    final updateBtn = web.document.getElementById('update-student-btn');
    if (updateBtn != null) {
      updateBtn.addEventListener('click', ((web.Event event) => handleUpdateStudent()).toJS);
    }

    // Delete Student button
    final deleteBtn = web.document.getElementById('delete-student-btn');
    if (deleteBtn != null) {
      deleteBtn.addEventListener('click', ((web.Event event) => handleDeleteStudent()).toJS);
    }

    // Clear All Students button
    final clearBtn = web.document.getElementById('clear-all-btn');
    if (clearBtn != null) {
      clearBtn.addEventListener('click', ((web.Event event) => handleClearAllStudents()).toJS);
    }
    
    log('🔗 Event listeners setup complete');
    
  } catch (error) {
    log('❌ Failed to setup event listeners: $error');
  }
}

/// Handle add student button click
void handleAddStudent() async {
  try {
    final idInput = web.document.getElementById('student-id') as web.HTMLInputElement?;
    final nameInput = web.document.getElementById('student-name') as web.HTMLInputElement?;
    final ageInput = web.document.getElementById('student-age') as web.HTMLInputElement?;
    final majorInput = web.document.getElementById('student-major') as web.HTMLInputElement?;

    if (idInput == null || nameInput == null || ageInput == null || majorInput == null) {
      log('❌ Could not find input elements');
      return;
    }

    // Validate inputs
    if (idInput.value.isEmpty ||
        nameInput.value.isEmpty ||
        ageInput.value.isEmpty ||
        majorInput.value.isEmpty) {
      log('⚠️ Please fill in all fields');
      return;
    }

    final age = int.tryParse(ageInput.value);
    if (age == null || age <= 0) {
      log('⚠️ Please enter a valid age');
      return;
    }

    final student = Student(
      id: idInput.value,
      name: nameInput.value,
      age: age,
      major: majorInput.value,
    );

    await createStudent(student);

    // Clear form
    idInput.value = '';
    nameInput.value = '';
    ageInput.value = '';
    majorInput.value = '';
    
  } catch (error) {
    log('❌ Error adding student: $error');
  }
}

/// Handle get all students button click
void handleGetAllStudents() async {
  try {
    log('📋 Retrieving all students...');
    final students = await readAllStudents();

    if (students.isEmpty) {
      log('📭 No students found in database');
    } else {
      log('👥 All Students:');
      for (final student in students) {
        log('  • ${student.toString()}');
      }
    }
  } catch (error) {
    log('❌ Error getting all students: $error');
  }
}

/// Handle get student button click
void handleGetStudent() async {
  try {
    final searchInput = web.document.getElementById('search-id') as web.HTMLInputElement?;
    
    if (searchInput == null) {
      log('❌ Could not find search input element');
      return;
    }

    if (searchInput.value.isEmpty) {
      log('⚠️ Please enter a student ID to search');
      return;
    }

    final student = await readStudent(searchInput.value);
    if (student != null) {
      log('🔍 Found: ${student.toString()}');
    }

    searchInput.value = '';
    
  } catch (error) {
    log('❌ Error getting student: $error');
  }
}

/// Handle update student button click
void handleUpdateStudent() async {
  try {
    final idInput = web.document.getElementById('update-id') as web.HTMLInputElement?;
    final nameInput = web.document.getElementById('update-name') as web.HTMLInputElement?;
    final ageInput = web.document.getElementById('update-age') as web.HTMLInputElement?;
    final majorInput = web.document.getElementById('update-major') as web.HTMLInputElement?;

    if (idInput == null || nameInput == null || ageInput == null || majorInput == null) {
      log('❌ Could not find update input elements');
      return;
    }

    if (idInput.value.isEmpty) {
      log('⚠️ Please enter a student ID to update');
      return;
    }

    final age = ageInput.value.isNotEmpty ? int.tryParse(ageInput.value) : null;
    
    final success = await updateStudent(
      idInput.value,
      name: nameInput.value.isNotEmpty ? nameInput.value : null,
      age: age,
      major: majorInput.value.isNotEmpty ? majorInput.value : null,
    );

    if (success) {
      // Clear form
      idInput.value = '';
      nameInput.value = '';
      ageInput.value = '';
      majorInput.value = '';
    }
    
  } catch (error) {
    log('❌ Error updating student: $error');
  }
}

/// Handle delete student button click
void handleDeleteStudent() async {
  try {
    final deleteInput = web.document.getElementById('delete-id') as web.HTMLInputElement?;
    
    if (deleteInput == null) {
      log('❌ Could not find delete input element');
      return;
    }

    if (deleteInput.value.isEmpty) {
      log('⚠️ Please enter a student ID to delete');
      return;
    }

    await deleteStudent(deleteInput.value);
    deleteInput.value = '';
    
  } catch (error) {
    log('❌ Error deleting student: $error');
  }
}

/// Handle clear all students button click
void handleClearAllStudents() async {
  try {
    final confirmed = web.window.confirm(
      'Are you sure you want to delete ALL students? This cannot be undone.',
    );
    
    if (confirmed) {
      await clearAllStudents();
    }
    
  } catch (error) {
    log('❌ Error clearing all students: $error');
  }
}

// =============================================================================
// UTILITY FUNCTIONS
// =============================================================================

/// Log message to output div with timestamp
void log(String message) {
  try {
    final timestamp = DateTime.now().toString().substring(11, 19);
    final logMessage = '[$timestamp] $message\n';
    
    // Update the output div
    final currentText = outputDiv.textContent ?? '';
    outputDiv.textContent = currentText + logMessage;
    
    // Scroll to bottom - handle potential scrollTop issues
    try {
      outputDiv.scrollTop = outputDiv.scrollHeight;
    } catch (e) {
      // Ignore scroll errors - some browsers might not support this
    }
    
    // Also log to console
    print(logMessage.trim());
    
  } catch (error) {
    print('Error logging message: $error');
  }
}

/// Update status div with color coding
void updateStatus(String message, String type) {
  try {
    statusDiv.textContent = message;
    statusDiv.className = 'status $type';
  } catch (error) {
    print('Error updating status: $error');
  }
}
