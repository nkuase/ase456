import 'simple_database.dart';
import 'student.dart';

/// A simple database that stores everything in memory (RAM)
/// This is perfect for learning - no files, no complex setup!
/// 
/// NOTE: Data disappears when program stops (because it's in memory)
/// But it's great for understanding how APIs work!
class MemoryDatabase implements SimpleDatabase {
  
  // This is where we store all our students (in memory)
  final List<Student> _students = [];
  
  @override
  String get databaseType => "Memory Database";
  
  @override
  Future<bool> addStudent(Student student) async {
    // Check if student already exists
    for (Student existingStudent in _students) {
      if (existingStudent.name == student.name) {
        print('❌ Student ${student.name} already exists!');
        return false;
      }
    }
    
    // Add the new student
    _students.add(student);
    print('✅ Added student: ${student.name} (${student.major})');
    return true;
  }
  
  @override
  Future<List<Student>> getAllStudents() async {
    print('📋 Getting all students: ${_students.length} found');
    return List.from(_students); // Return a copy, not the original list
  }
  
  @override
  Future<List<Student>> findByMajor(String major) async {
    List<Student> matches = [];
    
    // Look through all students and find matches
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
    // Look for student with exact name
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
    // Find the student and update their age
    for (Student student in _students) {
      if (student.name == name) {
        int oldAge = student.age;
        student.age = newAge;
        print('✅ Updated ${student.name}: age $oldAge → $newAge');
        return true;
      }
    }
    
    print('❌ Cannot update: Student $name not found');
    return false;
  }
  
  @override
  Future<bool> deleteStudent(String name) async {
    // Find and remove the student
    for (int i = 0; i < _students.length; i++) {
      if (_students[i].name == name) {
        Student removed = _students.removeAt(i);
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
    print('🗑️ Cleared all students ($count removed)');
  }
  
  @override
  Future<void> close() async {
    print('🔒 Memory database closed');
    // Nothing special to do for memory database
  }
}
