import '../../pocketbase/students/lib/services/database_factory.dart';
import '../../pocketbase/students/lib/services/database_crud.dart';
import '../../pocketbase/students/lib/models/student.dart';

/// Example implementation showing how to use the DatabaseServiceFactory
/// 
/// This file demonstrates best practices for:
/// - Factory pattern usage
/// - Dependency injection
/// - Service initialization
/// - Error handling

/// Mock implementation for demonstration purposes
class MockStudentService implements DatabaseCrudService {
  final List<Student> _students = [];
  bool _initialized = false;
  
  @override
  Future<void> initialize() async {
    _initialized = true;
    print('Mock database service initialized');
  }
  
  @override
  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
  
  @override
  Future<String> createStudent(Student student) async {
    if (!_initialized) throw StateError('Service not initialized');
    final id = generateId();
    final studentWithId = Student(
      id: id,
      name: student.name,
      age: student.age,
      major: student.major,
      createdAt: student.createdAt,
    );
    _students.add(studentWithId);
    return id;
  }
  
  @override
  Future<List<Student>> getAllStudents() async {
    if (!_initialized) throw StateError('Service not initialized');
    return List.from(_students);
  }
  
  // Implement other methods as needed...
  @override
  Future<void> createStudentWithId(Student student) async {
    if (!_initialized) throw StateError('Service not initialized');
    _students.add(student);
  }
  
  @override
  Future<void> createMultipleStudents(List<Student> students) async {
    for (final student in students) {
      await createStudent(student);
    }
  }
  
  @override
  Future<Student?> getStudentById(String id) async {
    if (!_initialized) throw StateError('Service not initialized');
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<Student>> getStudentsByMajor(String major) async {
    if (!_initialized) throw StateError('Service not initialized');
    return _students.where((s) => s.major == major).toList();
  }
  
  @override
  Future<List<Student>> getStudentsByAgeRange(int minAge, int maxAge) async {
    if (!_initialized) throw StateError('Service not initialized');
    return _students.where((s) => s.age >= minAge && s.age <= maxAge).toList();
  }
  
  @override
  Future<List<Student>> searchStudentsByName(String nameQuery) async {
    if (!_initialized) throw StateError('Service not initialized');
    return _students.where((s) => 
        s.name.toLowerCase().contains(nameQuery.toLowerCase())).toList();
  }
  
  @override
  Stream<List<Student>> getStudentsStream() {
    return Stream.periodic(Duration(seconds: 1), (count) => List.from(_students));
  }
  
  @override
  Future<int> getStudentCount() async {
    if (!_initialized) throw StateError('Service not initialized');
    return _students.length;
  }
  
  @override
  Future<void> updateStudent(String id, Map<String, dynamic> updates) async {
    if (!_initialized) throw StateError('Service not initialized');
    final index = _students.indexWhere((s) => s.id == id);
    if (index != -1) {
      final student = _students[index];
      _students[index] = Student(
        id: student.id,
        name: updates['name'] ?? student.name,
        age: updates['age'] ?? student.age,
        major: updates['major'] ?? student.major,
        createdAt: updates['createdAt'] ?? student.createdAt,
      );
    }
  }
  
  @override
  Future<void> updateEntireStudent(Student student) async {
    if (!_initialized) throw StateError('Service not initialized');
    final index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _students[index] = student;
    }
  }
  
  @override
  Future<void> incrementStudentAge(String id) async {
    final student = await getStudentById(id);
    if (student != null) {
      await updateStudent(id, {'age': student.age + 1});
    }
  }
  
  @override
  Future<void> transferStudentMajor(String studentId, String newMajor) async {
    await updateStudent(studentId, {'major': newMajor});
  }
  
  @override
  Future<void> deleteStudent(String id) async {
    if (!_initialized) throw StateError('Service not initialized');
    _students.removeWhere((s) => s.id == id);
  }
  
  @override
  Future<void> deleteAllStudents() async {
    if (!_initialized) throw StateError('Service not initialized');
    _students.clear();
  }
  
  @override
  Future<int> deleteStudentsByMajor(String major) async {
    if (!_initialized) throw StateError('Service not initialized');
    final initialCount = _students.length;
    _students.removeWhere((s) => s.major == major);
    return initialCount - _students.length;
  }
}

/// Example of how to properly initialize and use the database factory
class DatabaseServiceExample {
  static Future<void> runExample() async {
    print('=== Database Factory Pattern Example ===\n');
    
    // Step 1: Get the factory instance
    final factory = DatabaseServiceFactory.instance;
    
    // Step 2: Register available services
    print('Registering database services...');
    factory.registerService('mock', () => MockStudentService());
    factory.registerService('mock-test', () => MockStudentService());
    
    // Step 3: Show available services
    print('Available services: ${factory.getAvailableServiceTypes()}\n');
    
    // Step 4: Create and use a service
    try {
      print('Creating mock database service...');
      final dbService = factory.createService('mock');
      
      print('Initializing service...');
      await dbService.initialize();
      
      // Step 5: Use the service
      print('Adding sample students...');
      final student1 = Student(
        id: '',
        name: 'Alice Johnson',
        age: 20,
        major: 'Computer Science',
        createdAt: DateTime.now(),
      );
      
      final student2 = Student(
        id: '',
        name: 'Bob Smith',
        age: 22,
        major: 'Mathematics',
        createdAt: DateTime.now(),
      );
      
      final id1 = await dbService.createStudent(student1);
      final id2 = await dbService.createStudent(student2);
      
      print('Created students with IDs: $id1, $id2');
      
      // Step 6: Query the data
      final allStudents = await dbService.getAllStudents();
      print('Total students: ${allStudents.length}');
      
      final csStudents = await dbService.getStudentsByMajor('Computer Science');
      print('CS students: ${csStudents.length}');
      
      print('\nExample completed successfully!');
      
    } catch (e) {
      print('Error during example: $e');
    }
    
    // Step 7: Demonstrate error handling
    print('\n=== Error Handling Example ===');
    try {
      factory.createService('nonexistent');
    } catch (e) {
      print('Expected error caught: $e');
    }
  }
}

/// Main function to run the example
/// Uncomment this to test the factory pattern
/*
void main() async {
  await DatabaseServiceExample.runExample();
}
*/
