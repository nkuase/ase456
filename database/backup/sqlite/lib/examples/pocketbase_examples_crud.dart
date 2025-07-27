import '../models/student.dart';
import '../services/pocketbase_crud_service.dart';

/// PocketBase Examples
/// Demonstrates practical usage of PocketBase CRUD operations
/// These examples show how to use the PocketBaseStudentService
class PocketBaseExamples {
  /// Example 1: Basic CRUD Operations
  Future<void> basicCrudExample() async {
    print('\n📚 === Basic CRUD Example ===');

    try {
      // 1. CREATE - Add new students
      print('\n1️⃣ Creating students...');

      Student alice = Student(
        id: '', // Will be auto-generated
        name: 'Alice Johnson',
        age: 20,
        major: 'Computer Science',
        createdAt: DateTime.now(),
      );

      Student bob = Student(
        id: '', // Will be auto-generated
        name: 'Bob Smith',
        age: 22,
        major: 'Mathematics',
        createdAt: DateTime.now(),
      );

      var pb = PocketBaseCrudService();
      await pb.initialize();

      String aliceId = await pb.createStudent(alice);
      String bobId = await pb.createStudent(bob);
      print('  ✅ Created Alice with ID: $aliceId');
      print('  ✅ Created Bob with ID: $bobId');

      // 2-1. READ - Get all students
      print('\n2️⃣ Reading all students...');
      List<Student> allStudents = await pb.getAllStudents();
      for (Student student in allStudents) {
        print('  📖 $student');
      }

      // 2-2. READ - Get specific student
      print('\n3️⃣ Reading specific student...');
      Student? foundAlice = await pb.getStudentById(aliceId);
      if (foundAlice != null) {
        print('  📖 Found: $foundAlice');
      }

      // 3-1. Search by Major
      List<Student> students = await pb.getStudentsByMajor("Computer Science");
      for (Student student in students) {
        print('CS $student');
      }
      // 3-2. Search by Age Range
      List<Student> youngStudents = await pb.getStudentsByAgeRange(18, 21);
      for (Student student in youngStudents) {
        print('Age 18 - 21  🎓 $student');
      }

      // 4. UPDATE - Update student age
      print('\n4️⃣ Updating student...');
      await pb.updateStudent(aliceId, {'age': 21, 'major': 'Data Science'});

      // Verify update
      Student? updatedAlice = await pb.getStudentById(aliceId);
      if (updatedAlice != null) {
        print('  📝 Updated to DS: $updatedAlice');
      }

      // 4-2. Update entire record
      Student newStudent = Student(
        id: aliceId,
        name: 'Alice Johnson-Smith',
        age: 21,
        major: 'Engineering',
        createdAt: DateTime.now(),
      );
      await pb.updateEntireStudent(newStudent);
      // Verify update
      updatedAlice = await pb.getStudentById(aliceId);
      if (updatedAlice != null) {
        print('  📝 Updated to Eng: $updatedAlice');
      }

      // 5-1. DELETE - Remove one student
      print('\n5️⃣ Deleting student...');
      await pb.deleteStudent(bobId);

      // Verify deletion
      List<Student> remainingStudents = await pb.getAllStudents();
      print('  🗑️ Remaining students: ${remainingStudents.length}');

      // 5-2. DELETE - Remove all students
      print('\n6️⃣ Deleting all students...');
      await pb.deleteAllStudents();
      remainingStudents = await pb.getAllStudents();
      print(
          '  🗑️ Remaining students after cleanup: ${remainingStudents.length}');
    } catch (e) {
      print('❌ Basic CRUD Example failed: $e');
    }
  }
}
