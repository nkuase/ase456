import 'dart:js_util';
import 'dart:async';
import 'package:indexed_db/indexed_db.dart' as idb;
import '../common/database_service.dart';
import '../common/student.dart';

/// IndexedDB implementation of DatabaseService
/// Perfect for browser-based applications
class IndexedDBStudentService implements DatabaseService {
  static late idb.Database _database;
  static const String _dbName = 'studentsDB';
  static const String _storeName = 'students';
  
  @override
  Future<void> initialize() async {
    try {
      final factory = idb.IdbFactory();
      
      // Open database with version 1
      final openRequest = factory.open(_dbName, version: 1, 
        onUpgradeNeeded: (event) {
          final db = (event.target as idb.Request).result as idb.Database;
          
          // Create object store if it doesn't exist
          if (!db.objectStoreNames.contains(_storeName)) {
            final store = db.createObjectStore(_storeName, keyPath: 'id');
            
            // Create indexes for better querying
            store.createIndex('name', 'name', unique: false);
            store.createIndex('major', 'major', unique: false);
            store.createIndex('age', 'age', unique: false);
          }
        });
      
      _database = await openRequest.future as idb.Database;
      print('✅ IndexedDB initialized successfully');
    } catch (e) {
      print('❌ IndexedDB initialization failed: $e');
      rethrow;
    }
  }

  @override
  Future<String> createStudent(Student student) async {
    try {
      final transaction = _database.transactionList([_storeName], 'readwrite');
      final store = transaction.objectStore(_storeName);
      
      // Convert Dart Map to JavaScript object for IndexedDB
      final jsData = jsify(student.toMap());
      
      // Store the student data using student ID as key
      store.put(jsData, student.id);
      
      // Wait for transaction to complete
      await transaction.completed;
      
      print('✅ CREATE: Added student ${student.id} - ${student.name}');
      return student.id;
    } catch (error) {
      print('❌ CREATE ERROR: Failed to add student: $error');
      rethrow;
    }
  }

  @override
  Future<Student?> readStudent(String id) async {
    try {
      final transaction = _database.transactionList([_storeName], 'readonly');
      final store = transaction.objectStore(_storeName);
      
      // Get the student data
      final result = await store.getObject(id);
      
      if (result != null) {
        // Convert JavaScript object back to Dart Map
        final dartData = dartify(result);
        final studentMap = Map<String, dynamic>.from(dartData as Map);
        final student = Student.fromMap(studentMap);
        
        print('✅ READ: Found student ${student.id} - ${student.name}');
        return student;
      } else {
        print('⚠️ READ: Student with ID $id not found');
        return null;
      }
    } catch (error) {
      print('❌ READ ERROR: Failed to get student: $error');
      return null;
    }
  }

  @override
  Future<List<Student>> readAllStudents() async {
    try {
      final transaction = _database.transactionList([_storeName], 'readonly');
      final store = transaction.objectStore(_storeName);

      // Use cursor to iterate through all records
      final students = <Student>[];
      
      await for (final cursorWithValue in store.openCursor(autoAdvance: true)) {
        // Convert JavaScript object back to Dart Map
        final dartData = dartify(cursorWithValue.value);
        final studentData = Map<String, dynamic>.from(dartData as Map);
        students.add(Student.fromMap(studentData));
      }
      
      print('✅ READ ALL: Retrieved ${students.length} students');
      return students;
    } catch (error) {
      print('❌ READ ALL ERROR: Failed to get all students: $error');
      return [];
    }
  }

  @override
  Future<bool> updateStudent(String id, Map<String, dynamic> updates) async {
    try {
      // First, check if student exists
      final existingStudent = await readStudent(id);
      if (existingStudent == null) {
        print('⚠️ UPDATE: Student with ID $id not found');
        return false;
      }

      // Create updated student with new values or keep existing ones
      final updatedStudentMap = existingStudent.toMap();
      updatedStudentMap.addAll(updates);
      
      final updatedStudent = Student.fromMap(updatedStudentMap);

      // Update the record
      final transaction = _database.transactionList([_storeName], 'readwrite');
      final store = transaction.objectStore(_storeName);
      final jsData = jsify(updatedStudent.toMap());
      store.put(jsData, id);
      await transaction.completed;
      
      print('✅ UPDATE: Student $id updated successfully');
      return true;
    } catch (error) {
      print('❌ UPDATE ERROR: Failed to update student: $error');
      return false;
    }
  }

  @override
  Future<bool> deleteStudent(String id) async {
    try {
      // Check if student exists first
      final existingStudent = await readStudent(id);
      if (existingStudent == null) {
        print('⚠️ DELETE: Student with ID $id not found');
        return false;
      }

      // Delete the record
      final transaction = _database.transactionList([_storeName], 'readwrite');
      final store = transaction.objectStore(_storeName);
      store.delete(id);
      await transaction.completed;
      
      print('✅ DELETE: Student $id deleted successfully');
      return true;
    } catch (error) {
      print('❌ DELETE ERROR: Failed to delete student: $error');
      return false;
    }
  }

  @override
  Future<void> clearAllStudents() async {
    try {
      final transaction = _database.transactionList([_storeName], 'readwrite');
      final store = transaction.objectStore(_storeName);

      store.clear();
      await transaction.completed;

      print('✅ CLEAR ALL: Removed all students from database');
    } catch (error) {
      print('❌ CLEAR ERROR: Failed to clear all students: $error');
    }
  }

  @override
  Future<List<Student>> getStudentsByMajor(String major) async {
    try {
      final transaction = _database.transactionList([_storeName], 'readonly');
      final store = transaction.objectStore(_storeName);
      final index = store.index('major');
      
      final students = <Student>[];
      
      // Use index to find students by major
      await for (final cursorWithValue in index.openCursor(key: major, autoAdvance: true)) {
        final dartData = dartify(cursorWithValue.value);
        final studentData = Map<String, dynamic>.from(dartData as Map);
        students.add(Student.fromMap(studentData));
      }
      
      print('✅ QUERY: Found ${students.length} students in $major');
      return students;
    } catch (error) {
      print('❌ QUERY ERROR: Failed to get students by major: $error');
      return [];
    }
  }

  @override
  Future<List<Student>> searchStudentsByName(String name) async {
    try {
      // IndexedDB doesn't have built-in text search, so we'll do it manually
      final allStudents = await readAllStudents();
      final matchingStudents = allStudents
          .where((student) => student.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
      
      print('✅ SEARCH: Found ${matchingStudents.length} students matching "$name"');
      return matchingStudents;
    } catch (error) {
      print('❌ SEARCH ERROR: Failed to search students by name: $error');
      return [];
    }
  }

  @override
  Future<void> close() async {
    try {
      _database.close();
      print('✅ IndexedDB connection closed');
    } catch (error) {
      print('❌ CLOSE ERROR: Failed to close IndexedDB: $error');
    }
  }
}
