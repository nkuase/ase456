import '../models/student.dart';
import 'database_service.dart';
import 'pocketbase_student_service.dart';

/// PocketBase Database Service Adapter
/// Wraps the static PocketBaseStudentService to implement DatabaseService interface
/// This allows the existing static service to work with the interface pattern
class PocketBaseDatabaseAdapter implements DatabaseService {
  
  @override
  Future<void> initialize() async {
    await PocketBaseStudentService.initialize();
  }
  
  @override
  String generateId() {
    return PocketBaseStudentService.generateId();
  }
  
  // ===============================
  // CREATE Operations
  // ===============================
  
  @override
  Future<String> createStudent(Student student) async {
    return await PocketBaseStudentService.createStudent(student);
  }
  
  @override
  Future<void> createStudentWithId(Student student) async {
    await PocketBaseStudentService.createStudentWithId(student);
  }
  
  @override
  Future<void> createMultipleStudents(List<Student> students) async {
    await PocketBaseStudentService.createMultipleStudents(students);
  }
  
  // ===============================
  // READ Operations
  // ===============================
  
  @override
  Future<List<Student>> getAllStudents() async {
    return await PocketBaseStudentService.getAllStudents();
  }
  
  @override
  Future<Student?> getStudentById(String id) async {
    return await PocketBaseStudentService.getStudentById(id);
  }
  
  @override
  Future<List<Student>> getStudentsByMajor(String major) async {
    return await PocketBaseStudentService.getStudentsByMajor(major);
  }
  
  @override
  Future<List<Student>> getStudentsByAgeRange(int minAge, int maxAge) async {
    return await PocketBaseStudentService.getStudentsByAgeRange(minAge, maxAge);
  }
  
  @override
  Future<List<Student>> searchStudentsByName(String nameQuery) async {
    return await PocketBaseStudentService.searchStudentsByName(nameQuery);
  }
  
  @override
  Stream<List<Student>> getStudentsStream() {
    return PocketBaseStudentService.getStudentsStream();
  }
  
  @override
  Future<int> getStudentCount() async {
    return await PocketBaseStudentService.getStudentCount();
  }
  
  // ===============================
  // UPDATE Operations
  // ===============================
  
  @override
  Future<void> updateStudent(String id, Map<String, dynamic> updates) async {
    await PocketBaseStudentService.updateStudent(id, updates);
  }
  
  @override
  Future<void> updateEntireStudent(Student student) async {
    await PocketBaseStudentService.updateEntireStudent(student);
  }
  
  @override
  Future<void> incrementStudentAge(String id) async {
    await PocketBaseStudentService.incrementStudentAge(id);
  }
  
  @override
  Future<void> transferStudentMajor(String studentId, String newMajor) async {
    await PocketBaseStudentService.transferStudentMajor(studentId, newMajor);
  }
  
  // ===============================
  // DELETE Operations
  // ===============================
  
  @override
  Future<void> deleteStudent(String id) async {
    await PocketBaseStudentService.deleteStudent(id);
  }
  
  @override
  Future<void> deleteAllStudents() async {
    await PocketBaseStudentService.deleteAllStudents();
  }
  
  @override
  Future<int> deleteStudentsByMajor(String major) async {
    return await PocketBaseStudentService.deleteStudentsByMajor(major);
  }
}
