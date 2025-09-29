// SIMPLE TODO MODEL TESTS
// These tests demonstrate unit testing basics from the Marp slides

import 'package:flutter_test/flutter_test.dart';
import 'package:todo/models/todo.dart';

void main() {
  group('Todo Model Tests', () {
    test('should create a Todo with required parameters', () {
      // Arrange & Act
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
      );

      // Assert
      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.isCompleted, false); // Default value
    });

    test('should create a Todo with all parameters', () {
      // Arrange & Act
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        isCompleted: true,
      );

      // Assert
      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.isCompleted, true);
    });

    group('copyWith method', () {
      late Todo originalTodo;

      setUp(() {
        originalTodo = Todo(
          id: '1',
          title: 'Original Title',
          isCompleted: false,
        );
      });

      test('should create a copy with updated title', () {
        // Act
        final updatedTodo = originalTodo.copyWith(title: 'Updated Title');

        // Assert
        expect(updatedTodo.id, originalTodo.id);
        expect(updatedTodo.title, 'Updated Title');
        expect(updatedTodo.isCompleted, originalTodo.isCompleted);
      });

      test('should create a copy with updated completion status', () {
        // Act
        final updatedTodo = originalTodo.copyWith(isCompleted: true);

        // Assert
        expect(updatedTodo.id, originalTodo.id);
        expect(updatedTodo.title, originalTodo.title);
        expect(updatedTodo.isCompleted, true);
      });

      test('should create identical copy when no parameters provided', () {
        // Act
        final copiedTodo = originalTodo.copyWith();

        // Assert
        expect(copiedTodo.id, originalTodo.id);
        expect(copiedTodo.title, originalTodo.title);
        expect(copiedTodo.isCompleted, originalTodo.isCompleted);
      });
    });

    group('equality tests', () {
      test('should be equal when all properties match', () {
        // Arrange
        final todo1 = Todo(id: '1', title: 'Test Todo', isCompleted: true);
        final todo2 = Todo(id: '1', title: 'Test Todo', isCompleted: true);

        // Assert
        expect(todo1, equals(todo2));
        expect(todo1.hashCode, equals(todo2.hashCode));
      });

      test('should not be equal when properties differ', () {
        // Arrange
        final todo1 = Todo(id: '1', title: 'Test Todo 1');
        final todo2 = Todo(id: '2', title: 'Test Todo 2');

        // Assert
        expect(todo1, isNot(equals(todo2)));
      });
    });

    group('edge cases', () {
      test('should handle empty title', () {
        // Act
        final todo = Todo(id: '1', title: '');

        // Assert
        expect(todo.title, '');
      });

      test('should handle special characters in title', () {
        // Arrange
        const specialTitle = 'Todo with émojis 🎉';

        // Act
        final todo = Todo(id: '1', title: specialTitle);

        // Assert
        expect(todo.title, specialTitle);
      });
    });

    test('toString should return meaningful representation', () {
      // Arrange
      final todo = Todo(id: '1', title: 'Test Todo', isCompleted: true);

      // Act
      final stringRepresentation = todo.toString();

      // Assert
      expect(stringRepresentation, contains('Todo'));
      expect(stringRepresentation, contains('id: 1'));
      expect(stringRepresentation, contains('title: Test Todo'));
      expect(stringRepresentation, contains('isCompleted: true'));
    });
  });
}
