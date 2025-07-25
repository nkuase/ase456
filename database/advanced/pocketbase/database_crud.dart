import '../../pocketbase/students/lib/models/student.dart';

/// Abstract database service interface
/// This allows easy switching between different database backends
/// (Firebase, PocketBase, SQLite, etc.) without changing application logic
abstract class DatabaseCrudService {
  /// Initialize the database service
  Future<void> initialize();
  
  /// Generate a new ID for a record
  String generateId();
  
  // ===============================
  // CREATE Operations
  // ===============================
  
  /// Create a new student record
  Future<String> createStudent(Student student);
  
  /// Create a student with a specific ID
  Future<void> createStudentWithId(Student student);
  
  /// Create multiple students at once
  Future<void> createMultipleStudents(List<Student> students);
  
  // ===============================
  // READ Operations
  // ===============================
  
  /// Get all students
  Future<List<Student>> getAllStudents();
  
  /// Get a student by ID
  Future<Student?> getStudentById(String id);
  
  /// Get students by major
  Future<List<Student>> getStudentsByMajor(String major);
  
  /// Get students by age range
  Future<List<Student>> getStudentsByAgeRange(int minAge, int maxAge);
  
  /// Search students by name
  Future<List<Student>> searchStudentsByName(String nameQuery);
  
  /// Get a stream of students (real-time updates)
  Stream<List<Student>> getStudentsStream();
  
  /// Get total count of students
  Future<int> getStudentCount();
  
  // ===============================
  // UPDATE Operations
  // ===============================
  
  /// Update specific fields of a student
  Future<void> updateStudent(String id, Map<String, dynamic> updates);
  
  /// Update entire student record
  Future<void> updateEntireStudent(Student student);
  
  /// Increment student age
  Future<void> incrementStudentAge(String id);
  
  /// Transfer student to new major (transaction-like operation)
  Future<void> transferStudentMajor(String studentId, String newMajor);
  
  // ===============================
  // DELETE Operations
  // ===============================
  
  /// Delete a student by ID
  Future<void> deleteStudent(String id);
  
  /// Delete all students
  Future<void> deleteAllStudents();
  
  /// Delete students by major
  Future<int> deleteStudentsByMajor(String major);
}

