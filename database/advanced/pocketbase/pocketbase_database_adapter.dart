import '../../pocketbase/students/lib/models/student.dart';
import 'database_crud.dart';
import '../../pocketbase/students/lib/services/pocketbase_crud_service.dart';

/// PocketBase Database Service Adapter
/// Wraps the static PocketBaseStudentService to implement DatabaseService interface
/// This allows the existing static service to work with the interface pattern
class PocketBaseDatabaseAdapter implements DatabaseCrudService {
  
  @override
  Future<void> initialize() async {
    await PocketBaseCrudService.initialize();
  }
  
  @override
  String generateId() {
    return PocketBaseCrudService.generateId();
  }
  
  // ===============================
  // CREATE Operations
  // ===============================
  
  @override
  Future<String> createStudent(Student student) async {
    return await PocketBaseCrudService.createStudent(student);
  }
  
  @override
  Future<void> createStudentWithId(Student student) async {
    await PocketBaseCrudService.createStudentWithId(student);
  }
  
  @override
  Future<void> createMultipleStudents(List<Student> students) async {
    await PocketBaseCrudService.createMultipleStudents(students);
  }
  
  // ===============================
  // READ Operations
  // ===============================
  
  @override
  Future<List<Student>> getAllStudents() async {
    return await PocketBaseCrudService.getAllStudents();
  }
  
  @override
  Future<Student?> getStudentById(String id) async {
    return await PocketBaseCrudService.getStudentById(id);
  }
  
  @override
  Future<List<Student>> getStudentsByMajor(String major) async {
    return await PocketBaseCrudService.getStudentsByMajor(major);
  }
  
  @override
  Future<List<Student>> getStudentsByAgeRange(int minAge, int maxAge) async {
    return await PocketBaseCrudService.getStudentsByAgeRange(minAge, maxAge);
  }
  
  @override
  Future<List<Student>> searchStudentsByName(String nameQuery) async {
    return await PocketBaseCrudService.searchStudentsByName(nameQuery);
  }
  
  @override
  Stream<List<Student>> getStudentsStream() {
    return PocketBaseCrudService.getStudentsStream();
  }
  
  @override
  Future<int> getStudentCount() async {
    return await PocketBaseCrudService.getStudentCount();
  }
  
  // ===============================
  // UPDATE Operations
  // ===============================
  
  @override
  Future<void> updateStudent(String id, Map<String, dynamic> updates) async {
    await PocketBaseCrudService.updateStudent(id, updates);
  }
  
  @override
  Future<void> updateEntireStudent(Student student) async {
    await PocketBaseCrudService.updateEntireStudent(student);
  }
  
  @override
  Future<void> incrementStudentAge(String id) async {
    await PocketBaseCrudService.incrementStudentAge(id);
  }
  
  @override
  Future<void> transferStudentMajor(String studentId, String newMajor) async {
    await PocketBaseCrudService.transferStudentMajor(studentId, newMajor);
  }
  
  // ===============================
  // DELETE Operations
  // ===============================
  
  @override
  Future<void> deleteStudent(String id) async {
    await PocketBaseCrudService.deleteStudent(id);
  }
  
  @override
  Future<void> deleteAllStudents() async {
    await PocketBaseCrudService.deleteAllStudents();
  }
  
  @override
  Future<int> deleteStudentsByMajor(String major) async {
    return await PocketBaseCrudService.deleteStudentsByMajor(major);
  }
}
