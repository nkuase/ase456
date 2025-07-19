import '../models/student.dart';

/// Abstract interface for database operations
/// This defines the contract that all database implementations must follow
///
/// This is a classic example of the Strategy Pattern and Interface Segregation Principle
/// Students will learn:
/// 1. How to define contracts using abstract classes
/// 2. How different implementations can provide the same functionality
/// 3. How to write code that depends on abstractions, not concretions
abstract class DatabaseInterface {
  /// Initialize the database connection/setup
  /// This method prepares the database for use
  /// Returns true if initialization was successful
  Future<bool> initialize();

  /// Create a new student record
  /// Returns the created student with any server-generated fields
  /// Throws exception if creation fails
  Future<Student> create(Student student);

  /// Read a student by their ID
  /// Returns null if student with given ID doesn't exist
  Future<Student?> read(String id);

  /// Update an existing student record
  /// Returns the updated student
  /// Throws exception if student doesn't exist or update fails
  Future<Student> update(Student student);

  /// Delete a student by their ID
  /// Returns true if deletion was successful
  /// Returns false if student doesn't exist
  Future<bool> delete(String id);

  /// Get all students from the database
  /// Returns empty list if no students exist
  /// Can be optionally filtered by major
  Future<List<Student>> getAll({String? majorFilter});

  /// Search students by name (case-insensitive)
  /// Returns list of students whose names contain the search term
  Future<List<Student>> searchByName(String namePattern);

  /// Count total number of students
  /// Useful for pagination and statistics
  Future<int> count();

  /// Clear all student records
  /// Used for testing and cleanup
  /// Returns true if successful
  Future<bool> clear();

  /// Close the database connection
  /// Clean up resources when done
  Future<void> close();

  /// Get the name of this database implementation
  /// Useful for UI display and debugging
  String get databaseName;

  /// Check if the database is currently connected/ready
  bool get isConnected;
}

/// Exception thrown when database operations fail
class DBAbstractionException implements Exception {
  final String message;
  final String? operation;
  final dynamic originalError;

  DBAbstractionException(this.message, {this.operation, this.originalError});

  @override
  String toString() {
    String result = 'DBAbstractionException: $message';
    if (operation != null) {
      result += ' (Operation: $operation)';
    }
    if (originalError != null) {
      result += ' (Original error: $originalError)';
    }
    return result;
  }
}
