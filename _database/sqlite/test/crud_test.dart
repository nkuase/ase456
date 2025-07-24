import 'package:test/test.dart';
import 'dart:io';
import '../main.dart'; // Import our main application

/// Simple tests demonstrating how to test CRUD operations
/// This shows students how to verify their database code works correctly
void main() {
  group('Student CRUD Operations Tests', () {
    late DatabaseHelper dbHelper;
    late String testDbPath;

    /// Setup: Create a fresh database for each test
    setUp(() {
      // Create a unique test database for each test (add microseconds for uniqueness)
      testDbPath = 'test_students_${DateTime.now().microsecondsSinceEpoch}.db';
      dbHelper = DatabaseHelper(customDbPath: testDbPath);
    });

    /// Cleanup: Close database and delete test file after each test
    tearDown(() {
      try {
        dbHelper.close();
      } catch (e) {
        // Ignore errors during close
      }
      
      // Clean up test database file
      try {
        File testFile = File(testDbPath);
        if (testFile.existsSync()) {
          testFile.deleteSync();
        }
      } catch (e) {
        // Ignore cleanup errors
        print('Warning: Could not delete test file $testDbPath: $e');
      }
    });

    test('CREATE: Should insert a new student and return valid ID', () {
      // Arrange: Create a test student
      Student testStudent = Student(
        name: 'Test Student',
        age: 20,
        major: 'Test Major',
      );

      // Act: Insert the student
      int insertedId = dbHelper.insertStudent(testStudent);

      // Assert: Check that ID is valid (positive number)
      expect(insertedId, greaterThan(0));
      expect(testStudent.id, equals(insertedId));
    });

    test('READ: Should retrieve the correct student by ID', () {
      // Arrange: Insert a test student first
      Student original = Student(
        name: 'Alice Test',
        age: 22,
        major: 'Computer Science',
      );
      int id = dbHelper.insertStudent(original);

      // Act: Retrieve the student by ID
      Student? retrieved = dbHelper.getStudentById(id);

      // Assert: Check that retrieved student matches original
      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals(id));
      expect(retrieved.name, equals('Alice Test'));
      expect(retrieved.age, equals(22));
      expect(retrieved.major, equals('Computer Science'));
    });

    test('READ: Should return null for non-existent student ID', () {
      // Act: Try to get student with non-existent ID
      Student? result = dbHelper.getStudentById(999);

      // Assert: Should return null
      expect(result, isNull);
    });

    test('UPDATE: Should modify existing student information', () {
      // Arrange: Insert a student first
      Student student = Student(
        name: 'Bob Test',
        age: 20,
        major: 'Mathematics',
      );
      int id = dbHelper.insertStudent(student);

      // Act: Update the student's information
      student.age = 21;
      student.major = 'Computer Science';
      int rowsAffected = dbHelper.updateStudent(student);

      // Assert: Check update was successful
      expect(rowsAffected, equals(1));

      // Verify the changes were saved
      Student? updated = dbHelper.getStudentById(id);
      expect(updated!.age, equals(21));
      expect(updated.major, equals('Computer Science'));
    });

    test('UPDATE: Should return 0 for non-existent student', () {
      // Arrange: Create student with non-existent ID
      Student nonExistentStudent = Student(
        id: 999,
        name: 'Ghost Student',
        age: 25,
        major: 'Paranormal Studies',
      );

      // Act: Try to update non-existent student
      int rowsAffected = dbHelper.updateStudent(nonExistentStudent);

      // Assert: Should return 0 (no rows affected)
      expect(rowsAffected, equals(0));
    });

    test('DELETE: Should remove student from database', () {
      // Arrange: Insert a student first
      Student student = Student(
        name: 'Charlie Test',
        age: 19,
        major: 'Physics',
      );
      int id = dbHelper.insertStudent(student);

      // Act: Delete the student
      int rowsAffected = dbHelper.deleteStudent(id);

      // Assert: Check deletion was successful
      expect(rowsAffected, equals(1));

      // Verify student no longer exists
      Student? deleted = dbHelper.getStudentById(id);
      expect(deleted, isNull);
    });

    test('DELETE: Should return 0 for non-existent student', () {
      // Act: Try to delete non-existent student
      int rowsAffected = dbHelper.deleteStudent(999);

      // Assert: Should return 0 (no rows affected)
      expect(rowsAffected, equals(0));
    });

    test('READ ALL: Should retrieve all students in database', () {
      // Arrange: Insert multiple students
      List<Student> testStudents = [
        Student(name: 'Student 1', age: 20, major: 'Major 1'),
        Student(name: 'Student 2', age: 21, major: 'Major 2'),
        Student(name: 'Student 3', age: 22, major: 'Major 3'),
      ];

      for (Student student in testStudents) {
        dbHelper.insertStudent(student);
      }

      // Act: Retrieve all students
      List<Student> allStudents = dbHelper.getAllStudents();

      // Assert: Should have exactly our test students
      expect(allStudents.length, equals(3));

      // Check that our test students are in the results
      List<String> names = allStudents.map((s) => s.name).toList();
      expect(names, contains('Student 1'));
      expect(names, contains('Student 2'));
      expect(names, contains('Student 3'));
    });

    test('Database operations should handle special characters in names', () {
      // Arrange: Create student with special characters
      Student student = Student(
        name: "O'Connor-Smith",
        age: 23,
        major: 'English & Literature',
      );

      // Act: Insert and retrieve
      int id = dbHelper.insertStudent(student);
      Student? retrieved = dbHelper.getStudentById(id);

      // Assert: Special characters should be preserved
      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals("O'Connor-Smith"));
      expect(retrieved.major, equals('English & Literature'));
    });
  });
}
