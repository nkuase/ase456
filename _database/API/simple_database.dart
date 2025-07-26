import 'student.dart';

/// Simple database interface for beginners
/// This is like a "contract" - any database must be able to do these things
abstract class SimpleDatabase {
  
  /// Add a new student to the database
  /// Returns true if successful, false if failed
  Future<bool> addStudent(Student student);
  
  /// Find all students in the database
  /// Returns a list of all students
  Future<List<Student>> getAllStudents();
  
  /// Find students by their major (what they study)
  /// Example: findByMajor("Computer Science") 
  Future<List<Student>> findByMajor(String major);
  
  /// Find a student by their exact name
  /// Returns the student if found, null if not found
  Future<Student?> findByName(String name);
  
  /// Update a student's age
  /// Returns true if successful, false if student not found
  Future<bool> updateAge(String name, int newAge);
  
  /// Remove a student from the database
  /// Returns true if successful, false if student not found  
  Future<bool> deleteStudent(String name);
  
  /// Remove all students (start fresh)
  Future<void> clearAll();
  
  /// Close the database connection
  Future<void> close();
  
  /// Get a simple name for this database type
  String get databaseType;
}
