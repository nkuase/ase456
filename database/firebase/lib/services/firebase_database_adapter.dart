import '../models/student.dart';
import 'database_service.dart';
import 'firebase_student_service.dart';

/// Firebase Database Service Adapter
/// Wraps the static FirebaseStudentService to implement DatabaseService interface
/// This allows the existing static service to work with the interface pattern
class FirebaseDatabaseAdapter implements DatabaseService {
  
  @override
  Future<void> initialize() async {
    await FirebaseStudentService.initialize();
  }
  
  @override
  String generateId() {
    return FirebaseStudentService.generateId();
  }
  
  // ===============================
  // CREATE Operations
  // ===============================
  
  @override
  Future<String> createStudent(Student student) async {
    return await FirebaseStudentService.createStudent(student);
  }
  
  @override
  Future<void> createStudentWithId(Student student) async {
    await FirebaseStudentService.createStudentWithId(student);
  }
  
  @override
  Future<void> createMultipleStudents(List<Student> students) async {
    await FirebaseStudentService.createMultipleStudents(students);
  }
  
  // ===============================
  // READ Operations
  // ===============================
  
  @override
  Future<List<Student>> getAllStudents() async {
    return await FirebaseStudentService.getAllStudents();
  }
  
  @override
  Future<Student?> getStudentById(String id) async {
    return await FirebaseStudentService.getStudentById(id);
  }
  
  @override
  Future<List<Student>> getStudentsByMajor(String major) async {
    return await FirebaseStudentService.getStudentsByMajor(major);
  }
  
  @override
  Future<List<Student>> getStudentsByAgeRange(int minAge, int maxAge) async {
    return await FirebaseStudentService.getStudentsByAgeRange(minAge, maxAge);
  }
  
  @override
  Future<List<Student>> searchStudentsByName(String nameQuery) async {
    return await FirebaseStudentService.searchStudentsByName(nameQuery);
  }
  
  @override
  Stream<List<Student>> getStudentsStream() {
    return FirebaseStudentService.getStudentsStream();
  }
  
  @override
  Future<int> getStudentCount() async {
    return await FirebaseStudentService.getStudentCount();
  }
  
  // ===============================
  // UPDATE Operations
  // ===============================
  
  @override
  Future<void> updateStudent(String id, Map<String, dynamic> updates) async {
    await FirebaseStudentService.updateStudent(id, updates);
  }
  
  @override
  Future<void> updateEntireStudent(Student student) async {
    await FirebaseStudentService.updateEntireStudent(student);
  }
  
  @override
  Future<void> incrementStudentAge(String id) async {
    await FirebaseStudentService.incrementStudentAge(id);
  }
  
  @override
  Future<void> transferStudentMajor(String studentId, String newMajor) async {
    await FirebaseStudentService.transferStudentMajor(studentId, newMajor);
  }
  
  // ===============================
  // DELETE Operations
  // ===============================
  
  @override
  Future<void> deleteStudent(String id) async {
    await FirebaseStudentService.deleteStudent(id);
  }
  
  @override
  Future<void> deleteAllStudents() async {
    await FirebaseStudentService.deleteAllStudents();
  }
  
  @override
  Future<int> deleteStudentsByMajor(String major) async {
    return await FirebaseStudentService.deleteStudentsByMajor(major);
  }
}
