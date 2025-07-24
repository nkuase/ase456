import 'dart:io';
import 'dart:convert';
import 'simple_database.dart';
import 'student.dart';

/// A simple database that saves data to a text file
/// This shows how data can be "persistent" (saved between runs)
/// 
/// The file format is simple JSON - easy to read and understand!
class FileDatabase implements SimpleDatabase {
  
  final String _filename;
  final List<Student> _students = [];
  
  // Constructor - you can choose the filename
  FileDatabase({String filename = 'students.json'}) : _filename = filename;
  
  @override
  String get databaseType => "File Database";
  
  /// Load students from file when we start
  Future<void> initialize() async {
    try {
      final file = File(_filename);
      
      if (await file.exists()) {
        // Read the file content
        String content = await file.readAsString();
        
        if (content.isNotEmpty) {
          // Parse JSON and convert to students
          List<dynamic> jsonList = jsonDecode(content);
          
          for (dynamic item in jsonList) {
            Map<String, dynamic> studentMap = item as Map<String, dynamic>;
            Student student = Student(
              name: studentMap['name'] as String,
              age: studentMap['age'] as int,
              major: studentMap['major'] as String,
            );
            _students.add(student);
          }
          
          print('📁 Loaded ${_students.length} students from file');
        }
      } else {
        print('📁 No existing file found, starting fresh');
      }
    } catch (e) {
      print('❌ Error loading from file: $e');
      print('📁 Starting with empty database');
    }
  }
  
  /// Save all students to file
  Future<void> _saveToFile() async {
    try {
      // Convert students to JSON format
      List<Map<String, dynamic>> jsonList = [];
      for (Student student in _students) {
        jsonList.add({
          'name': student.name,
          'age': student.age,
          'major': student.major,
        });
      }
      
      // Write to file
      final file = File(_filename);
      String jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
      
      print('💾 Saved ${_students.length} students to file');
    } catch (e) {
      print('❌ Error saving to file: $e');
    }
  }
  
  @override
  Future<bool> addStudent(Student student) async {
    // Check if student already exists
    for (Student existingStudent in _students) {
      if (existingStudent.name == student.name) {
        print('❌ Student ${student.name} already exists!');
        return false;
      }
    }
    
    // Add student and save to file
    _students.add(student);
    await _saveToFile();
    print('✅ Added student: ${student.name} (${student.major})');
    return true;
  }
  
  @override
  Future<List<Student>> getAllStudents() async {
    print('📋 Getting all students: ${_students.length} found');
    return List.from(_students);
  }
  
  @override
  Future<List<Student>> findByMajor(String major) async {
    List<Student> matches = [];
    
    for (Student student in _students) {
      if (student.major == major) {
        matches.add(student);
      }
    }
    
    print('🔍 Found ${matches.length} students in $major');
    return matches;
  }
  
  @override
  Future<Student?> findByName(String name) async {
    for (Student student in _students) {
      if (student.name == name) {
        print('✅ Found student: $name');
        return student;
      }
    }
    
    print('❌ Student not found: $name');
    return null;
  }
  
  @override
  Future<bool> updateAge(String name, int newAge) async {
    for (Student student in _students) {
      if (student.name == name) {
        int oldAge = student.age;
        student.age = newAge;
        await _saveToFile(); // Save changes to file
        print('✅ Updated ${student.name}: age $oldAge → $newAge');
        return true;
      }
    }
    
    print('❌ Cannot update: Student $name not found');
    return false;
  }
  
  @override
  Future<bool> deleteStudent(String name) async {
    for (int i = 0; i < _students.length; i++) {
      if (_students[i].name == name) {
        Student removed = _students.removeAt(i);
        await _saveToFile(); // Save changes to file
        print('✅ Deleted student: ${removed.name}');
        return true;
      }
    }
    
    print('❌ Cannot delete: Student $name not found');
    return false;
  }
  
  @override
  Future<void> clearAll() async {
    int count = _students.length;
    _students.clear();
    await _saveToFile(); // Save empty list to file
    print('🗑️ Cleared all students ($count removed)');
  }
  
  @override
  Future<void> close() async {
    await _saveToFile(); // Make sure everything is saved
    print('🔒 File database closed and saved');
  }
}
