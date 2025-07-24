import '../models/student.dart';
import '../utils/student_validator.dart';
import 'student_service.dart';
import 'firebase_result.dart';

/// Secure wrapper for StudentService with validation and sanitization
class SecureStudentService {
  final StudentService _studentService = StudentService();

  /// Create a student with validation and sanitization
  Future<FirebaseResult<String>> createSecurely(Student student) async {
    // Validate input
    if (!StudentValidator.isValidName(student.name)) {
      return FirebaseResult.error('Invalid name: ${StudentValidator.validateName(student.name)}');
    }
    
    if (!StudentValidator.isValidAge(student.age)) {
      return FirebaseResult.error('Invalid age: ${StudentValidator.getAgeRangeDescription()}');
    }
    
    if (!StudentValidator.isValidMajor(student.major)) {
      return FirebaseResult.error('Invalid major: ${StudentValidator.validateMajor(student.major)}');
    }

    // Sanitize input
    final sanitizedStudent = Student(
      name: StudentValidator.sanitizeName(student.name),
      age: student.age,
      major: StudentValidator.sanitizeMajor(student.major),
    );

    return await _studentService.create(sanitizedStudent);
  }

  /// Create student from form data with validation
  Future<FirebaseResult<String>> createFromFormData({
    required String name,
    required String ageText,
    required String major,
  }) async {
    // Validate all fields
    final errors = StudentValidator.validateStudent(
      name: name,
      ageText: ageText,
      major: major,
    );

    if (errors.isNotEmpty) {
      final errorMessages = errors.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      return FirebaseResult.error('Validation errors: $errorMessages');
    }

    // Parse age
    final age = StudentValidator.parseAge(ageText);
    if (age == null) {
      return FirebaseResult.error('Invalid age format');
    }

    // Create sanitized student
    final student = Student(
      name: StudentValidator.sanitizeName(name),
      age: age,
      major: StudentValidator.sanitizeMajor(major),
    );

    return await _studentService.create(student);
  }

  /// Update student with validation
  Future<FirebaseResult<void>> updateSecurely(String id, Student student) async {
    // Validate input
    if (!StudentValidator.isValidName(student.name)) {
      return FirebaseResult.error('Invalid name: ${StudentValidator.validateName(student.name)}');
    }
    
    if (!StudentValidator.isValidAge(student.age)) {
      return FirebaseResult.error('Invalid age: ${StudentValidator.getAgeRangeDescription()}');
    }
    
    if (!StudentValidator.isValidMajor(student.major)) {
      return FirebaseResult.error('Invalid major: ${StudentValidator.validateMajor(student.major)}');
    }

    // Check if student exists first
    final existingResult = await _studentService.read(id);
    if (existingResult.isError) {
      return FirebaseResult.error('Failed to verify student exists: ${existingResult.errorMessage}');
    }
    
    if (existingResult.value == null) {
      return FirebaseResult.error('Student with ID $id does not exist');
    }

    // Sanitize input
    final sanitizedStudent = Student(
      name: StudentValidator.sanitizeName(student.name),
      age: student.age,
      major: StudentValidator.sanitizeMajor(student.major),
    );

    return await _studentService.update(id, sanitizedStudent);
  }

  /// Update student name with validation
  Future<FirebaseResult<void>> updateNameSecurely(String id, String newName) async {
    final nameError = StudentValidator.validateName(newName);
    if (nameError != null) {
      return FirebaseResult.error('Invalid name: $nameError');
    }

    return await _studentService.updateFields(id, {
      'name': StudentValidator.sanitizeName(newName)
    });
  }

  /// Update student age with validation
  Future<FirebaseResult<void>> updateAgeSecurely(String id, int newAge) async {
    if (!StudentValidator.isValidAge(newAge)) {
      return FirebaseResult.error('Invalid age: ${StudentValidator.getAgeRangeDescription()}');
    }

    return await _studentService.updateStudentAge(id, newAge);
  }

  /// Update student major with validation
  Future<FirebaseResult<void>> updateMajorSecurely(String id, String newMajor) async {
    final majorError = StudentValidator.validateMajor(newMajor);
    if (majorError != null) {
      return FirebaseResult.error('Invalid major: $majorError');
    }

    return await _studentService.updateStudentMajor(id, StudentValidator.sanitizeMajor(newMajor));
  }

  /// Bulk create students with validation
  Future<FirebaseResult<List<String>>> bulkCreateSecurely(List<Student> students) async {
    final validStudents = <Student>[];
    final errors = <String>[];

    for (int i = 0; i < students.length; i++) {
      final student = students[i];
      
      // Validate each student
      if (!StudentValidator.isValidName(student.name)) {
        errors.add('Student $i: Invalid name');
        continue;
      }
      
      if (!StudentValidator.isValidAge(student.age)) {
        errors.add('Student $i: Invalid age');
        continue;
      }
      
      if (!StudentValidator.isValidMajor(student.major)) {
        errors.add('Student $i: Invalid major');
        continue;
      }

      // Sanitize and add to valid list
      validStudents.add(Student(
        name: StudentValidator.sanitizeName(student.name),
        age: student.age,
        major: StudentValidator.sanitizeMajor(student.major),
      ));
    }

    if (errors.isNotEmpty) {
      return FirebaseResult.error('Validation errors: ${errors.join(', ')}');
    }

    if (validStudents.isEmpty) {
      return FirebaseResult.error('No valid students to create');
    }

    return await _studentService.createBatch(validStudents);
  }

  /// Delete with additional safety checks
  Future<FirebaseResult<void>> deleteSecurely(String id) async {
    // Verify student exists before deleting
    final existingResult = await _studentService.read(id);
    if (existingResult.isError) {
      return FirebaseResult.error('Failed to verify student exists: ${existingResult.errorMessage}');
    }
    
    if (existingResult.value == null) {
      return FirebaseResult.error('Student with ID $id does not exist');
    }

    return await _studentService.delete(id);
  }

  /// Delete students by major with confirmation
  Future<FirebaseResult<int>> deleteStudentsByMajorSecurely(String major) async {
    // Validate major first
    if (!StudentValidator.isValidMajor(major)) {
      return FirebaseResult.error('Invalid major: ${StudentValidator.validateMajor(major)}');
    }

    // Get count of students to be deleted first
    final studentsResult = await _studentService.getStudentsByMajor(major);
    if (studentsResult.isError) {
      return FirebaseResult.error('Failed to get students for deletion: ${studentsResult.errorMessage}');
    }

    final studentCount = studentsResult.value.length;
    if (studentCount == 0) {
      return FirebaseResult.success(0);
    }

    // Proceed with deletion
    return await _studentService.deleteStudentsByMajor(major);
  }

  /// Get validation rules
  String getValidationRules() {
    return StudentValidator.getValidationRules();
  }

  /// Get list of valid majors
  List<String> getValidMajors() {
    return StudentValidator.getValidMajors();
  }

  // Delegate safe read operations to the underlying service
  Future<FirebaseResult<Student?>> read(String id) => _studentService.read(id);
  Future<FirebaseResult<List<Student>>> readAll({int? limit, String? orderBy, bool descending = false}) =>
      _studentService.readAll(limit: limit, orderBy: orderBy, descending: descending);
  Future<FirebaseResult<List<Student>>> getStudentsByMajor(String major) => _studentService.getStudentsByMajor(major);
  Future<FirebaseResult<List<Student>>> getStudentsByAgeRange(int minAge, int maxAge) => 
      _studentService.getStudentsByAgeRange(minAge, maxAge);
  Future<List<Student>> searchStudentsByName(String searchTerm) => _studentService.searchStudentsByName(searchTerm);
  Future<Map<String, int>> getStudentCountByMajor() => _studentService.getStudentCountByMajor();
  Future<double> getAverageAge() => _studentService.getAverageAge();
  Future<Map<String, dynamic>> getStudentStatistics() => _studentService.getStudentStatistics();

  // Delegate stream operations
  Stream<List<Student>> streamAll({int? limit, String? orderBy, bool descending = false}) =>
      _studentService.streamAll(limit: limit, orderBy: orderBy, descending: descending);
  Stream<Student?> streamDocument(String id) => _studentService.streamDocument(id);
  Stream<List<Student>> streamStudentsByMajor(String major) => _studentService.streamStudentsByMajor(major);
}
