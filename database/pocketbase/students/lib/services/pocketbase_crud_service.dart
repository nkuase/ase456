import 'package:pocketbase/pocketbase.dart';
import '../models/student.dart';

/// PocketBase Student Service
/// Provides CRUD operations for Student data in PocketBase
/// Demonstrates PocketBase patterns and best practices using instance-based design
class PocketBaseCrudService {
  // Instance variables instead of static
  final PocketBase _pb;
  final String _collection = 'students';
  
  // Constructor - this makes it an instance-based class
  PocketBaseCrudService({
    String baseUrl = 'http://127.0.0.1:8090',
  }) : _pb = PocketBase(baseUrl);
  
  /// Get reference to students collection
  RecordService get _studentsRef => _pb.collection(_collection);

  /// Generate new student ID
  String generateId() {
    // PocketBase generates IDs automatically, but we can simulate it
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Initialize service (can be used for setup)
  Future<void> initialize() async {
    try {
      // Test connection
      await _pb.health.check();
      
      // Try to authenticate with admin user (optional)
      try {
        await _pb.collection('_superusers').authWithPassword(
          'admin@example.com', 
          'admin123456'
        );
        print('✅ PocketBase authenticated successfully');
      } catch (e) {
        print('⚠️ PocketBase auth failed (continuing without auth): $e');
      }
      
      print('✅ PocketBase connected successfully');
    } catch (e) {
      print('❌ PocketBase connection failed: $e');
      rethrow;
    }
  }

  // ===============================
  // CREATE Operations
  // ===============================

  /// CREATE: Add new student to PocketBase with auto-generated ID
  Future<String> createStudent(Student student) async {
    try {
      final record = await _studentsRef.create(body: student.toJson());
      
      print('✅ CREATE: Student added with ID: ${record.id}');
      return record.id;
      
    } catch (e) {
      print('❌ CREATE Error: $e');
      throw Exception('Failed to create student: $e');
    }
  }

  /// CREATE: Add student with specific ID
  Future<void> createStudentWithId(Student student) async {
    try {
      await _studentsRef.create(body: {
        ...student.toJson(),
        'id': student.id, // Include ID in body for PocketBase
      });
      
      print('✅ CREATE: Student created with ID: ${student.id}');
      
    } catch (e) {
      print('❌ CREATE Error: $e');
      throw Exception('Failed to create student with ID: $e');
    }
  }

  // ===============================
  // READ Operations
  // ===============================

  /// READ: Get all students (one-time fetch)
  Future<List<Student>> getAllStudents() async {
    try {
      final result = await _studentsRef.getList(
        page: 1,
        perPage: 500, // Get more records at once
        sort: '+createdAt',
      );
      
      List<Student> students = result.items
          .map((record) => Student.fromRecord(record))
          .toList();
      
      print('✅ READ: Retrieved ${students.length} students');
      return students;
      
    } catch (e) {
      print('❌ READ Error: $e');
      throw Exception('Failed to get students: $e');
    }
  }

  /// READ: Stream of students (simulated real-time updates)
  /// Note: PocketBase has real-time subscriptions but this simulates it
  Stream<List<Student>> getStudentsStream() async* {
    while (true) {
      try {
        yield await getAllStudents();
        await Future.delayed(Duration(seconds: 5)); // Poll every 5 seconds
      } catch (e) {
        print('❌ STREAM Error: $e');
        yield []; // Return empty list on error
        await Future.delayed(Duration(seconds: 10)); // Wait longer on error
      }
    }
  }

  /// READ: Get specific student by ID
  Future<Student?> getStudentById(String id) async {
    try {
      final record = await _studentsRef.getOne(id);
      
      Student student = Student.fromRecord(record);
      print('✅ READ: Found student with ID $id');
      return student;
      
    } catch (e) {
      if (e.toString().contains('404') || e.toString().contains('Not Found')) {
        print('❌ READ: No student found with ID $id');
        return null;
      }
      print('❌ READ Error: $e');
      throw Exception('Failed to get student: $e');
    }
  }

  /// READ: Get students by major
  Future<List<Student>> getStudentsByMajor(String major) async {
    try {
      final result = await _studentsRef.getList(
        page: 1,
        perPage: 500,
        filter: 'major = "$major"',
        sort: '+createdAt',
      );
      
      List<Student> students = result.items
          .map((record) => Student.fromRecord(record))
          .toList();
      
      print('✅ READ: Retrieved ${students.length} students with major: $major');
      return students;
      
    } catch (e) {
      print('❌ READ Error: $e');
      throw Exception('Failed to get students by major: $e');
    }
  }

  /// READ: Get students by age range
  Future<List<Student>> getStudentsByAgeRange(int minAge, int maxAge) async {
    try {
      final result = await _studentsRef.getList(
        page: 1,
        perPage: 500,
        filter: 'age >= $minAge && age <= $maxAge',
        sort: '+age',
      );
      
      List<Student> students = result.items
          .map((record) => Student.fromRecord(record))
          .toList();
      
      print('✅ READ: Retrieved ${students.length} students aged $minAge-$maxAge');
      return students;
      
    } catch (e) {
      print('❌ READ Error: $e');
      throw Exception('Failed to get students by age range: $e');
    }
  }

  // ===============================
  // UPDATE Operations
  // ===============================

  /// UPDATE: Update specific fields of a student
  Future<void> updateStudent(String id, Map<String, dynamic> updates) async {
    try {
      await _studentsRef.update(id, body: updates);
      print('✅ UPDATE: Student $id updated successfully');
      
    } catch (e) {
      print('❌ UPDATE Error: $e');
      throw Exception('Failed to update student: $e');
    }
  }

  /// UPDATE: Update entire student document
  Future<void> updateEntireStudent(Student student) async {
    try {
      await _studentsRef.update(student.id, body: student.toJson());
      print('✅ UPDATE: Student ${student.id} replaced successfully');
      
    } catch (e) {
      print('❌ UPDATE Error: $e');
      throw Exception('Failed to update student: $e');
    }
  }

  /// UPDATE: Increment student age
  Future<void> incrementStudentAge(String id) async {
    try {
      // PocketBase doesn't have FieldValue.increment, so we need to fetch then update
      final student = await getStudentById(id);
      if (student != null) {
        await updateStudent(id, {'age': student.age + 1});
        print('✅ UPDATE: Student $id age incremented');
      } else {
        throw Exception('Student not found');
      }
      
    } catch (e) {
      print('❌ UPDATE Error: $e');
      throw Exception('Failed to increment student age: $e');
    }
  }

  // ===============================
  // DELETE Operations
  // ===============================

  /// DELETE: Remove student by ID
  Future<void> deleteStudent(String id) async {
    try {
      await _studentsRef.delete(id);
      print('✅ DELETE: Student $id deleted successfully');
      
    } catch (e) {
      print('❌ DELETE Error: $e');
      throw Exception('Failed to delete student: $e');
    }
  }

  /// DELETE: Remove all students (batch operation)
  Future<void> deleteAllStudents() async {
    try {
      int page = 1;
      int totalDeleted = 0;
      
      while (true) {
        final result = await _studentsRef.getList(
          page: page,
          perPage: 100,
        );
        
        if (result.items.isEmpty) break;
        
        for (final record in result.items) {
          await _studentsRef.delete(record.id);
          totalDeleted++;
        }
      }
      
      print('✅ DELETE: $totalDeleted students deleted successfully');
      
    } catch (e) {
      print('❌ DELETE Error: $e');
      throw Exception('Failed to delete all students: $e');
    }
  }

  /// DELETE: Remove students by major
  Future<int> deleteStudentsByMajor(String major) async {
    try {
      final studentsToDelete = await getStudentsByMajor(major);
      
      for (final student in studentsToDelete) {
        await _studentsRef.delete(student.id);
      }
      
      print('✅ DELETE: ${studentsToDelete.length} students with major $major deleted');
      return studentsToDelete.length;
      
    } catch (e) {
      print('❌ DELETE Error: $e');
      throw Exception('Failed to delete students by major: $e');
    }
  }

  // ===============================
  // Utility Operations
  // ===============================

  /// COUNT: Get total number of students
  Future<int> getStudentCount() async {
    try {
      final result = await _studentsRef.getList(page: 1, perPage: 1);
      int count = result.totalItems;
      print('✅ COUNT: Total students: $count');
      return count;
      
    } catch (e) {
      print('❌ COUNT Error: $e');
      throw Exception('Failed to count students: $e');
    }
  }

  /// SEARCH: Search students by name (partial match)
  Future<List<Student>> searchStudentsByName(String nameQuery) async {
    try {
      final result = await _studentsRef.getList(
        page: 1,
        perPage: 500,
        filter: 'name ~ "$nameQuery"',
        sort: '+name',
      );
      
      List<Student> students = result.items
          .map((record) => Student.fromRecord(record))
          .toList();
      
      print('✅ SEARCH: Found ${students.length} students matching "$nameQuery"');
      return students;
      
    } catch (e) {
      print('❌ SEARCH Error: $e');
      throw Exception('Failed to search students: $e');
    }
  }

  // ===============================
  // Advanced Operations
  // ===============================

  /// BATCH: Create multiple students at once
  Future<void> createMultipleStudents(List<Student> students) async {
    try {
      // PocketBase doesn't have batch operations, so we create them one by one
      for (Student student in students) {
        await _studentsRef.create(body: student.toJson());
      }
      
      print('✅ BATCH CREATE: ${students.length} students created successfully');
      
    } catch (e) {
      print('❌ BATCH CREATE Error: $e');
      throw Exception('Failed to create multiple students: $e');
    }
  }

  /// TRANSACTION: Transfer student between majors
  /// Note: PocketBase doesn't have transactions, so this is a simulation
  Future<void> transferStudentMajor(String studentId, String newMajor) async {
    try {
      // Simulate transaction by updating directly
      await updateStudent(studentId, {'major': newMajor});
      print('✅ TRANSACTION: Student $studentId transferred to $newMajor');
      
    } catch (e) {
      print('❌ TRANSACTION Error: $e');
      throw Exception('Failed to transfer student: $e');
    }
  }

  // ===============================
  // PocketBase Specific Operations
  // ===============================

  /// Setup the students collection with proper schema
  Future<void> setupCollection() async {
    try {
      await _pb.collections.create(body: {
        'name': _collection,
        'type': 'base',
        'schema': [
          {
            'name': 'name',
            'type': 'text',
            'required': true,
            'options': {
              'min': 1,
              'max': 100,
            }
          },
          {
            'name': 'age',
            'type': 'number',
            'required': true,
            'options': {
              'min': 0,
              'max': 150,
            }
          },
          {
            'name': 'major',
            'type': 'text',
            'required': true,
            'options': {
              'min': 1,
              'max': 100,
            }
          },
          {
            'name': 'createdAt',
            'type': 'date',
            'required': true,
          },
        ],
        'listRule': '',        // Public read
        'viewRule': '',        // Public read
        'createRule': '',      // Public create (for demo)
        'updateRule': '',      // Public update (for demo)
        'deleteRule': '',      // Public delete (for demo)
      });
      
      print('✅ SETUP: Students collection created successfully');
      
    } catch (e) {
      if (e.toString().contains('already exists')) {
        print('✅ SETUP: Students collection already exists');
      } else {
        print('❌ SETUP Error: $e');
        throw Exception('Failed to setup collection: $e');
      }
    }
  }

  // ===============================
  // Instance-specific helper methods
  // ===============================

  /// Check if service is properly initialized
  bool get isInitialized => _pb.authStore.isValid;

  /// Get current PocketBase URL
  String get baseUrl => _pb.baseUrl;

  /// Get connection status
  Future<bool> checkConnection() async {
    try {
      await _pb.health.check();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Dispose resources (good practice for cleanup)
  void dispose() {
    // Clean up any resources if needed
    // PocketBase doesn't require explicit disposal but good practice to have this method
  }
}
