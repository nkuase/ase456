import '../models/student.dart';
import '../models/api_response.dart';

/// Universal database service interface that all implementations must follow
/// This allows seamless switching between different database backends
abstract class DatabaseService {
  /// Get a human-readable name for this database implementation
  String get databaseType;

  /// Initialize the database connection/setup
  Future<void> initialize();

  /// Close the database connection and cleanup resources
  Future<void> close();

  /// Check if the database is healthy and responsive
  Future<bool> isHealthy();

  // =============================================================================
  // CRUD OPERATIONS
  // =============================================================================

  /// CREATE: Add a new student to the database
  /// Returns the ID of the created student
  Future<String> createStudent(Student student);

  /// CREATE: Add multiple students in a batch operation
  /// Returns a BatchResponse with success/failure details
  Future<BatchResponse> createStudentsBatch(List<Student> students);

  /// READ: Get a specific student by ID
  /// Returns null if student not found
  Future<Student?> getStudentById(String id);

  /// READ: Get all students with optional query parameters
  /// Returns a paginated list of students
  Future<PaginatedResponse<Student>> getStudents([StudentQuery? query]);

  /// READ: Get students count (for pagination)
  Future<int> getStudentsCount([StudentQuery? query]);

  /// UPDATE: Modify an existing student
  /// Returns true if successful, false if student not found
  Future<bool> updateStudent(String id, Student student);

  /// UPDATE: Update specific fields of a student
  /// Returns true if successful, false if student not found
  Future<bool> updateStudentFields(String id, Map<String, dynamic> fields);

  /// DELETE: Remove a student by ID
  /// Returns true if successful, false if student not found
  Future<bool> deleteStudent(String id);

  /// DELETE: Remove all students matching query criteria
  /// Returns the number of deleted students
  Future<int> deleteStudentsWhere(StudentQuery query);

  /// DELETE: Remove all students (use with caution!)
  /// Returns the number of deleted students
  Future<int> deleteAllStudents();

  // =============================================================================
  // ADVANCED OPERATIONS (Optional - databases can provide empty implementations)
  // =============================================================================

  /// SEARCH: Search students by text (name, major, etc.)
  /// Default implementation filters by name and major
  Future<List<Student>> searchStudents(String searchText) async {
    final query = StudentQuery(nameContains: searchText);
    final result = await getStudents(query);
    return result.items;
  }

  /// ANALYTICS: Get statistics about students
  Future<Map<String, dynamic>> getStudentStatistics() async {
    final allStudents = await getStudents();
    final students = allStudents.items;
    
    if (students.isEmpty) {
      return {
        'totalStudents': 0,
        'averageAge': 0,
        'majorDistribution': <String, int>{},
        'ageDistribution': <String, int>{},
      };
    }

    final majorCounts = <String, int>{};
    final ageCounts = <String, int>{};
    int totalAge = 0;

    for (final student in students) {
      // Major distribution
      majorCounts[student.major] = (majorCounts[student.major] ?? 0) + 1;
      
      // Age distribution by ranges
      String ageRange;
      if (student.age < 20) {
        ageRange = '16-19';
      } else if (student.age < 25) {
        ageRange = '20-24';
      } else if (student.age < 30) {
        ageRange = '25-29';
      } else {
        ageRange = '30+';
      }
      ageCounts[ageRange] = (ageCounts[ageRange] ?? 0) + 1;
      
      totalAge += student.age;
    }

    return {
      'totalStudents': students.length,
      'averageAge': totalAge / students.length,
      'majorDistribution': majorCounts,
      'ageDistribution': ageCounts,
    };
  }

  // =============================================================================
  // BACKUP & MIGRATION (Optional)
  // =============================================================================

  /// Export all students to JSON format for backup or migration
  Future<List<Map<String, dynamic>>> exportStudents() async {
    final result = await getStudents();
    return result.items.map((student) => student.toJson()).toList();
  }

  /// Import students from JSON format (for migration or restore)
  Future<BatchResponse> importStudents(List<Map<String, dynamic>> studentsJson) async {
    final students = studentsJson.map((json) => Student.fromJson(json)).toList();
    return await createStudentsBatch(students);
  }

  // =============================================================================
  // REAL-TIME FEATURES (Optional - only some databases support this)
  // =============================================================================

  /// Listen to real-time changes in students collection
  /// Returns a stream of all students (empty implementation for databases without real-time)
  Stream<List<Student>> watchStudents() {
    // Default implementation: return empty stream
    // Real-time capable databases (Firebase, PocketBase) will override this
    return Stream.empty();
  }

  /// Listen to real-time changes for a specific student
  /// Returns a stream of the student (empty implementation for databases without real-time)
  Stream<Student?> watchStudent(String id) {
    // Default implementation: return empty stream
    // Real-time capable databases will override this
    return Stream.empty();
  }
}

/// Exception thrown when database operations fail
class DatabaseException implements Exception {
  final String message;
  final String? details;
  final Exception? originalException;

  const DatabaseException(this.message, {this.details, this.originalException});

  @override
  String toString() {
    return 'DatabaseException: $message${details != null ? ' ($details)' : ''}';
  }
}

/// Exception thrown when validation fails
class ValidationException implements Exception {
  final List<String> errors;

  const ValidationException(this.errors);

  @override
  String toString() {
    return 'ValidationException: ${errors.join(', ')}';
  }
}

/// Exception thrown when a resource is not found
class NotFoundException implements Exception {
  final String resource;
  final String id;

  const NotFoundException(this.resource, this.id);

  @override
  String toString() {
    return 'NotFoundException: $resource with ID $id not found';
  }
}
