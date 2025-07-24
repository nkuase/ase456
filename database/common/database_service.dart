/// Common interface for all database services
/// This allows switching between IndexedDB, SQLite, Firebase, etc.
abstract class DatabaseService {
  /// Initialize the database connection
  Future<void> initialize();
  
  /// Create a new student
  Future<String> createStudent(Student student);
  
  /// Read a student by ID
  Future<Student?> readStudent(String id);
  
  /// Read all students
  Future<List<Student>> readAllStudents();
  
  /// Update a student by ID
  Future<bool> updateStudent(String id, Map<String, dynamic> updates);
  
  /// Delete a student by ID
  Future<bool> deleteStudent(String id);
  
  /// Clear all students
  Future<void> clearAllStudents();
  
  /// Get students by major
  Future<List<Student>> getStudentsByMajor(String major);
  
  /// Search students by name
  Future<List<Student>> searchStudentsByName(String name);
  
  /// Close the database connection
  Future<void> close();
}
