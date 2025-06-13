import 'package:flutter_test/flutter_test.dart';
import 'package:db_abstraction_demo_mvvm/viewmodels/student_form_viewmodel.dart';
import 'package:db_abstraction_demo_mvvm/services/database_service_notifier.dart';
import 'package:db_abstraction_demo_mvvm/models/student.dart';

/// ViewModel unit tests for educational purposes
///
/// This demonstrates how to properly test business logic:
/// 1. Validation logic testing
/// 2. State management verification
/// 3. Form handling behavior
/// 4. Mocking external dependencies
void main() {
  group('StudentFormViewModel Tests', () {
    late StudentFormViewModel viewModel;
    late MockDatabaseService mockService;

    setUp(() {
      mockService = MockDatabaseService();
      viewModel = StudentFormViewModel(mockService);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Form Validation', () {
      test('should validate required name field', () async {
        // Arrange
        viewModel.nameController.text = '';
        viewModel.emailController.text = 'test@example.com';
        viewModel.ageController.text = '20';
        viewModel.majorController.text = 'Computer Science';

        // Act
        final result = await viewModel.saveStudent();

        // Assert
        expect(result, isFalse);
        expect(viewModel.validationError, equals('Name is required'));
      });

      test('should validate email format', () async {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        viewModel.emailController.text = 'invalid-email';
        viewModel.ageController.text = '20';
        viewModel.majorController.text = 'Computer Science';

        // Act
        final result = await viewModel.saveStudent();

        // Assert
        expect(result, isFalse);
        expect(viewModel.validationError, equals('Invalid email format'));
      });

      test('should validate age range', () async {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        viewModel.emailController.text = 'john@example.com';
        viewModel.ageController.text = '15'; // Too young
        viewModel.majorController.text = 'Computer Science';

        // Act
        final result = await viewModel.saveStudent();

        // Assert
        expect(result, isFalse);
        expect(viewModel.validationError,
            equals('Age must be between 16 and 100'));
      });

      test('should pass validation with valid data', () async {
        // Arrange
        viewModel.nameController.text = 'John Doe';
        viewModel.emailController.text = 'john@example.com';
        viewModel.ageController.text = '20';
        viewModel.majorController.text = 'Computer Science';

        // Act
        final result = await viewModel.saveStudent();

        // Assert
        expect(result, isTrue);
        expect(viewModel.validationError, isNull);
      });
    });

    group('Edit Mode', () {
      test('should populate form when editing student', () {
        // Arrange
        final student = Student(
          id: '1',
          name: 'Jane Doe',
          email: 'jane@example.com',
          age: 22,
          major: 'Mathematics',
          createdAt: DateTime.now(),
        );

        // Act
        viewModel.setEditingStudent(student);

        // Assert
        expect(viewModel.isEditMode, isTrue);
        expect(viewModel.nameController.text, equals('Jane Doe'));
        expect(viewModel.emailController.text, equals('jane@example.com'));
        expect(viewModel.ageController.text, equals('22'));
        expect(viewModel.majorController.text, equals('Mathematics'));
      });

      test('should clear form when canceling edit', () {
        // Arrange
        final student = Student(
          id: '1',
          name: 'Jane Doe',
          email: 'jane@example.com',
          age: 22,
          major: 'Mathematics',
          createdAt: DateTime.now(),
        );
        viewModel.setEditingStudent(student);

        // Act
        viewModel.clearForm();

        // Assert
        expect(viewModel.isEditMode, isFalse);
        expect(viewModel.nameController.text, isEmpty);
        expect(viewModel.emailController.text, isEmpty);
        expect(viewModel.ageController.text, isEmpty);
        expect(viewModel.majorController.text, isEmpty);
      });
    });
  });
}

/// Simple mock for testing ViewModels without database dependencies
class MockDatabaseService extends DatabaseServiceNotifier {
  @override
  Future<Student> createStudent(Student student) async {
    // Mock implementation - just succeed
    return student;
  }

  @override
  Future<Student> updateStudent(Student student) async {
    // Mock implementation - just succeed
    return student;
  }
}
