import 'package:test/test.dart';
import '../lib/models/student.dart';

/// Unit tests for the Student model
/// Demonstrates testing data models and their methods
void main() {
  group('Student Model Tests', () {
    late Student testStudent;
    late DateTime testTime;

    setUp(() {
      testTime = DateTime(2024, 1, 15, 10, 30, 0);
      testStudent = Student(
        id: 'test-123',
        name: 'Alice Johnson',
        age: 20,
        major: 'Computer Science',
        createdAt: testTime,
      );
    });

    test('should create student with correct properties', () {
      expect(testStudent.id, equals('test-123'));
      expect(testStudent.name, equals('Alice Johnson'));
      expect(testStudent.age, equals(20));
      expect(testStudent.major, equals('Computer Science'));
      expect(testStudent.createdAt, equals(testTime));
    });

    test('should convert student to map correctly', () {
      final map = testStudent.toMap();
      
      expect(map['name'], equals('Alice Johnson'));
      expect(map['age'], equals(20));
      expect(map['major'], equals('Computer Science'));
      expect(map['createdAt'], equals(testTime.toIso8601String()));
      
      // Note: ID is not included in toMap() as it's the document ID
      expect(map.containsKey('id'), isFalse);
    });

    test('should create student from map correctly', () {
      final map = {
        'name': 'Bob Smith',
        'age': 22,
        'major': 'Mathematics',
        'createdAt': testTime.toIso8601String(),
      };
      
      final student = Student.fromMap(map, 'bob-456');
      
      expect(student.id, equals('bob-456'));
      expect(student.name, equals('Bob Smith'));
      expect(student.age, equals(22));
      expect(student.major, equals('Mathematics'));
      expect(student.createdAt, equals(testTime));
    });

    test('should handle copyWith correctly', () {
      final updatedStudent = testStudent.copyWith(
        age: 21,
        major: 'Data Science',
      );
      
      // Changed properties
      expect(updatedStudent.age, equals(21));
      expect(updatedStudent.major, equals('Data Science'));
      
      // Unchanged properties
      expect(updatedStudent.id, equals(testStudent.id));
      expect(updatedStudent.name, equals(testStudent.name));
      expect(updatedStudent.createdAt, equals(testStudent.createdAt));
    });

    test('should handle toString correctly', () {
      final stringRepresentation = testStudent.toString();
      
      expect(stringRepresentation, contains('Alice Johnson'));
      expect(stringRepresentation, contains('20'));
      expect(stringRepresentation, contains('Computer Science'));
      expect(stringRepresentation, contains('test-123'));
    });

    test('should handle equality correctly', () {
      final sameStudent = Student(
        id: 'test-123',
        name: 'Alice Johnson',
        age: 20,
        major: 'Computer Science',
        createdAt: testTime,
      );
      
      final differentStudent = Student(
        id: 'test-456',
        name: 'Bob Smith',
        age: 22,
        major: 'Mathematics',
        createdAt: testTime,
      );
      
      expect(testStudent, equals(sameStudent));
      expect(testStudent, isNot(equals(differentStudent)));
    });

    test('should handle hashCode correctly', () {
      final sameStudent = Student(
        id: 'test-123',
        name: 'Alice Johnson',
        age: 20,
        major: 'Computer Science',
        createdAt: testTime,
      );
      
      expect(testStudent.hashCode, equals(sameStudent.hashCode));
    });

    test('should handle missing data gracefully in fromMap', () {
      final incompleteMap = <String, dynamic>{
        'name': 'Charlie Brown',
        // Missing age, major, createdAt
      };
      
      final student = Student.fromMap(incompleteMap, 'charlie-789');
      
      expect(student.id, equals('charlie-789'));
      expect(student.name, equals('Charlie Brown'));
      expect(student.age, equals(0)); // Default value
      expect(student.major, equals('')); // Default value
      // createdAt will be current time due to DateTime.now() fallback
      expect(student.createdAt, isA<DateTime>());
    });

    test('should handle null values in fromMap', () {
      final mapWithNulls = <String, dynamic>{
        'name': null,
        'age': null,
        'major': null,
        'createdAt': null,
      };
      
      final student = Student.fromMap(mapWithNulls, 'null-test');
      
      expect(student.id, equals('null-test'));
      expect(student.name, equals('')); // Null coalescing to empty string
      expect(student.age, equals(0)); // Null coalescing to 0
      expect(student.major, equals('')); // Null coalescing to empty string
      expect(student.createdAt, isA<DateTime>()); // Fallback to current time
    });
  });

  group('Student Model Edge Cases', () {
    test('should handle very long names', () {
      final longName = 'A' * 1000; // 1000 character name
      final student = Student(
        id: 'long-name-test',
        name: longName,
        age: 20,
        major: 'Test Major',
        createdAt: DateTime.now(),
      );
      
      expect(student.name.length, equals(1000));
      expect(student.toMap()['name'], equals(longName));
    });

    test('should handle edge case ages', () {
      final youngStudent = Student(
        id: 'young',
        name: 'Young Student',
        age: 0,
        major: 'Preschool',
        createdAt: DateTime.now(),
      );
      
      final oldStudent = Student(
        id: 'old',
        name: 'Old Student',
        age: 150,
        major: 'Life Experience',
        createdAt: DateTime.now(),
      );
      
      expect(youngStudent.age, equals(0));
      expect(oldStudent.age, equals(150));
    });

    test('should handle special characters in fields', () {
      final specialStudent = Student(
        id: 'special-chars',
        name: 'José García-López',
        age: 25,
        major: 'Computer Science & Mathematics',
        createdAt: DateTime.now(),
      );
      
      expect(specialStudent.name, contains('José'));
      expect(specialStudent.major, contains('&'));
      
      final map = specialStudent.toMap();
      final reconstructed = Student.fromMap(map, specialStudent.id);
      
      expect(reconstructed.name, equals(specialStudent.name));
      expect(reconstructed.major, equals(specialStudent.major));
    });
  });

  group('PocketBase Specific Tests', () {
    test('should handle PocketBase ID format', () {
      // PocketBase typically generates IDs like this
      final pocketbaseId = 'abc123def456';
      final student = Student(
        id: pocketbaseId,
        name: 'PocketBase Student',
        age: 21,
        major: 'Database Management',
        createdAt: DateTime.now(),
      );
      
      expect(student.id, equals(pocketbaseId));
      expect(student.id.length, greaterThan(10)); // PocketBase IDs are usually longer
    });

    test('should handle empty ID for new records', () {
      final newStudent = Student(
        id: '', // Empty ID for new records
        name: 'New Student',
        age: 20,
        major: 'Computer Science',
        createdAt: DateTime.now(),
      );
      
      expect(newStudent.id, equals(''));
      
      // When converted to map, ID should not be included
      final map = newStudent.toMap();
      expect(map.containsKey('id'), isFalse);
    });
  });
}
