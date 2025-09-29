// SIMPLE MOCK TEST EXAMPLE
// This demonstrates basic mocking concepts for educational purposes

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/services/todo_service.dart';

// Generate mocks using build_runner
// Run: flutter packages pub run build_runner build
@GenerateMocks([TodoService])
import 'simple_mock_test.mocks.dart';

void main() {
  group('Simple Mock Examples', () {
    late MockTodoService mockService;

    setUp(() {
      mockService = MockTodoService();
    });

    group('Basic Mock Setup', () {
      test('should create a mock service', () {
        // Arrange & Act
        final mock = MockTodoService();

        // Assert
        expect(mock, isA<TodoService>());
        expect(mock, isA<MockTodoService>());
      });
    });

    group('Mock Behavior Setup - when().thenReturn()', () {
      test('should return predefined todos when getAllTodos is called', () {
        // Arrange - Set up mock behavior
        final expectedTodos = [
          Todo(id: '1', title: 'Mock Todo 1'),
          Todo(id: '2', title: 'Mock Todo 2', isCompleted: true),
        ];

        when(mockService.getAllTodos()).thenReturn(expectedTodos);

        // Act - Call the mocked method
        final result = mockService.getAllTodos();

        // Assert - Check the result
        expect(result, expectedTodos);
        expect(result.length, 2);
        expect(result[0].title, 'Mock Todo 1');
        expect(result[1].isCompleted, true);
      });

      test('should return empty list when no todos exist', () {
        // Arrange
        when(mockService.getAllTodos()).thenReturn([]);

        // Act
        final result = mockService.getAllTodos();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('Mock Behavior - Different Return Values', () {
      test('should return different values on successive calls', () {
        // Arrange - Set up different behaviors for multiple calls
        // Note: Must use separate when() calls for different return values
        when(mockService.getAllTodos()).thenReturn([Todo(id: '1', title: 'First Call')]);

        // Act & Assert - First call
        final firstResult = mockService.getAllTodos();
        expect(firstResult[0].title, 'First Call');

        // Setup second call behavior
        when(mockService.getAllTodos()).thenReturn([Todo(id: '2', title: 'Second Call')]);

        // Act & Assert - Second call  
        final secondResult = mockService.getAllTodos();
        expect(secondResult[0].title, 'Second Call');
      });

      test('should return different todos for completed and pending', () {
        // Arrange
        final completedTodos = [
          Todo(id: '1', title: 'Completed Todo', isCompleted: true),
        ];
        final pendingTodos = [
          Todo(id: '2', title: 'Pending Todo', isCompleted: false),
        ];

        when(mockService.getCompletedTodos()).thenReturn(completedTodos);
        when(mockService.getPendingTodos()).thenReturn(pendingTodos);

        // Act & Assert
        final completed = mockService.getCompletedTodos();
        final pending = mockService.getPendingTodos();

        expect(completed.length, 1);
        expect(completed[0].isCompleted, true);
        expect(pending.length, 1);
        expect(pending[0].isCompleted, false);
      });
    });

    group('Mock Method Verification', () {
      test('should verify that addTodo was called', () {
        // Arrange
        final todo = Todo(id: '1', title: 'Test Todo');

        // Act - Void methods don't need when().thenReturn()
        mockService.addTodo(todo);

        // Assert - Verify the method was called
        verify(mockService.addTodo(todo)).called(1);
      });

      test('should verify method was called with specific parameters', () {
        // Arrange
        const todoId = 'test-id';

        // Act - Void method, no mocking needed
        mockService.deleteTodo(todoId);

        // Assert - Verify with specific argument
        verify(mockService.deleteTodo('test-id')).called(1);
      });

      test('should verify method was never called', () {
        // Act - Don't call any methods

        // Assert - Verify no interactions
        verifyNever(mockService.getAllTodos());
        verifyNever(mockService.addTodo(any));
        verifyNever(mockService.deleteTodo(any));
      });

      test('should verify multiple method calls', () {
        // Arrange
        final todo1 = Todo(id: '1', title: 'Todo 1');
        final todo2 = Todo(id: '2', title: 'Todo 2');

        // Act
        mockService.addTodo(todo1);
        mockService.addTodo(todo2);
        mockService.getAllTodos(); // This now returns [] by default

        // Assert - Verify multiple calls
        verify(mockService.addTodo(todo1)).called(1);
        verify(mockService.addTodo(todo2)).called(1);
        verify(mockService.getAllTodos()).called(1);
      });
    });

    group('Mock Error Simulation', () {
      test('should throw exception when simulating service error', () {
        // Arrange - Mock to throw an exception
        when(mockService.getAllTodos()).thenThrow(Exception('Service error'));

        // Act & Assert - Expect exception
        expect(
          () => mockService.getAllTodos(),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle different error types', () {
        // Arrange - Mock void method to throw exception
        when(mockService.addTodo(any)).thenThrow(ArgumentError('Invalid todo'));

        // Act & Assert
        final todo = Todo(id: '1', title: 'Test');
        expect(
          () => mockService.addTodo(todo),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should simulate network timeout', () {
        // Arrange
        when(mockService.searchTodos(any)).thenThrow(Exception('Connection timeout'));

        // Act & Assert
        expect(
          () => mockService.searchTodos('test'),
          throwsException,
        );
      });
    });

    group('Mock with Argument Matchers', () {
      test('should match any argument for void methods', () {
        // Act
        mockService.deleteTodo('any-id');
        mockService.deleteTodo('another-id');

        // Assert - Both calls should work
        verify(mockService.deleteTodo('any-id')).called(1);
        verify(mockService.deleteTodo('another-id')).called(1);
      });

      test('should match arguments with conditions', () {
        // Act
        mockService.deleteTodo('test-1');
        mockService.deleteTodo('test-2');

        // Assert
        verify(mockService.deleteTodo('test-1')).called(1);
        verify(mockService.deleteTodo('test-2')).called(1);
      });

      test('should use typed argument matchers', () {
        // Act
        final todo = Todo(id: '1', title: 'Test Todo');
        mockService.addTodo(todo);

        // Assert
        verify(mockService.addTodo(argThat(isA<Todo>()))).called(1);
      });

      test('should verify calls with any matcher', () {
        // Arrange
        final todo1 = Todo(id: '1', title: 'Test Todo 1');
        final todo2 = Todo(id: '2', title: 'Test Todo 2');

        // Act
        mockService.addTodo(todo1);
        mockService.addTodo(todo2);

        // Assert - Verify any Todo was added twice
        verify(mockService.addTodo(any)).called(2);
      });
    });

    group('Mock Search Functionality', () {
      test('should mock search results', () {
        // Arrange
        final searchResults = [
          Todo(id: '1', title: 'Search Result 1'),
          Todo(id: '2', title: 'Search Result 2'),
        ];

        when(mockService.searchTodos('test')).thenReturn(searchResults);

        // Act
        final result = mockService.searchTodos('test');

        // Assert
        expect(result.length, 2);
        expect(result[0].title, 'Search Result 1');
        verify(mockService.searchTodos('test')).called(1);
      });

      test('should return empty list for no search matches', () {
        // Arrange - Not needed! Mock returns [] by default
        
        // Act
        final result = mockService.searchTodos('nonexistent');

        // Assert - Default return is empty list
        expect(result, isEmpty);
      });
    });

    group('Mock State Changes', () {
      test('should mock toggle todo functionality', () {
        // Act - Void method, no mocking behavior needed
        mockService.toggleTodo('test-id');

        // Assert
        verify(mockService.toggleTodo('test-id')).called(1);
      });

      test('should mock update todo functionality', () {
        // Arrange
        final updatedTodo = Todo(id: '1', title: 'Updated Todo');

        // Act - Void method
        mockService.updateTodo(updatedTodo);

        // Assert
        verify(mockService.updateTodo(updatedTodo)).called(1);
      });

      test('should simulate error on state change', () {
        // Arrange - Mock toggle to throw error
        when(mockService.toggleTodo(any)).thenThrow(Exception('Toggle failed'));

        // Act & Assert
        expect(
          () => mockService.toggleTodo('test-id'),
          throwsException,
        );
      });
    });

    group('Practical Mock Example', () {
      test('should simulate a complete workflow', () {
        // Arrange - Set up a realistic scenario
        final existingTodos = [
          Todo(id: '1', title: 'Existing Todo'),
        ];
        final newTodo = Todo(id: '2', title: 'New Todo');

        // Set up mock behaviors for methods that return values
        when(mockService.getAllTodos()).thenReturn(existingTodos);
        when(mockService.getCompletedTodos()).thenReturn([]);
        when(mockService.getPendingTodos()).thenReturn(existingTodos);

        // Act - Simulate app workflow
        final currentTodos = mockService.getAllTodos();
        mockService.addTodo(newTodo); // Void method - no mocking needed
        final pendingTodos = mockService.getPendingTodos();

        // Assert - Verify workflow
        expect(currentTodos.length, 1);
        expect(currentTodos[0].title, 'Existing Todo');
        expect(pendingTodos.length, 1);
        
        verify(mockService.getAllTodos()).called(1);
        verify(mockService.addTodo(newTodo)).called(1);
        verify(mockService.getPendingTodos()).called(1);
      });

      test('should simulate error recovery with different calls', () {
        // Arrange - First call fails
        when(mockService.getAllTodos()).thenThrow(Exception('First call fails'));

        // Act & Assert - First call should fail
        expect(() => mockService.getAllTodos(), throwsException);

        // Arrange - Setup second call to succeed
        when(mockService.getAllTodos()).thenReturn([Todo(id: '1', title: 'Recovery successful')]);

        // Act & Assert - Second call should succeed
        final result = mockService.getAllTodos();
        expect(result.length, 1);
        expect(result[0].title, 'Recovery successful');
        
        // Verify both calls happened
        verify(mockService.getAllTodos()).called(2);
      });
    });

    group('Mock Interaction Patterns', () {
      test('should verify interaction order', () {
        // Arrange
        final todo = Todo(id: '1', title: 'Test Todo');

        // Act - Perform operations in specific order
        mockService.addTodo(todo);
        mockService.getAllTodos(); // Returns [] by default
        mockService.toggleTodo(todo.id);
        
        // Assert - Verify each interaction happened
        verifyInOrder([
          mockService.addTodo(todo),
          mockService.getAllTodos(),
          mockService.toggleTodo(todo.id),
        ]);
      });

      test('should verify no more interactions after expected calls', () {
        // Arrange
        final todo = Todo(id: '1', title: 'Test Todo');

        // Act
        mockService.addTodo(todo);
        mockService.getAllTodos(); // Returns [] by default

        // Assert
        verify(mockService.addTodo(todo)).called(1);
        verify(mockService.getAllTodos()).called(1);
        verifyNoMoreInteractions(mockService);
      });

      test('should reset mock between test calls', () {
        // Arrange
        final todo = Todo(id: '1', title: 'Test Todo');

        // Act - First interaction
        mockService.addTodo(todo);
        verify(mockService.addTodo(todo)).called(1);

        // Reset the mock
        reset(mockService);

        // Act - After reset, no interactions should be recorded
        verifyZeroInteractions(mockService);

        // Act - New interaction
        mockService.deleteTodo(todo.id);
        
        // Assert - Only the new interaction should be recorded
        verify(mockService.deleteTodo(todo.id)).called(1);
        verifyNever(mockService.addTodo(any));
      });
    });

    group('Default Behavior Demonstration', () {
      test('should return empty lists by default without stubs', () {
        // Act - Call methods without setting up stubs first
        // The mock now returns empty lists by default
        final todos = mockService.getAllTodos();
        final completed = mockService.getCompletedTodos();
        final pending = mockService.getPendingTodos();
        final searchResults = mockService.searchTodos('test');

        // Assert - Should return empty lists by default
        expect(todos, isEmpty);
        expect(completed, isEmpty);
        expect(pending, isEmpty);
        expect(searchResults, isEmpty);
      });

      test('should allow void method calls without stubs', () {
        // Arrange
        final todo = Todo(id: '1', title: 'Test Todo');

        // Act - These work fine without stubs for void methods
        mockService.addTodo(todo);
        mockService.updateTodo(todo);
        mockService.deleteTodo(todo.id);
        mockService.toggleTodo(todo.id);

        // Assert - Verify all calls were made
        verify(mockService.addTodo(todo)).called(1);
        verify(mockService.updateTodo(todo)).called(1);
        verify(mockService.deleteTodo(todo.id)).called(1);
        verify(mockService.toggleTodo(todo.id)).called(1);
      });

      test('should demonstrate stubbed vs default behavior', () {
        // Arrange - First call uses default behavior
        final defaultResult = mockService.getAllTodos();
        expect(defaultResult, isEmpty); // Default return

        // Arrange - Now stub the method
        final stubbedTodos = [
          Todo(id: '1', title: 'Stubbed Todo'),
        ];
        when(mockService.getAllTodos()).thenReturn(stubbedTodos);

        // Act - Second call uses stubbed behavior  
        final stubbedResult = mockService.getAllTodos();

        // Assert - Different results
        expect(stubbedResult.length, 1);
        expect(stubbedResult[0].title, 'Stubbed Todo');
        
        verify(mockService.getAllTodos()).called(2);
      });
    });
  });
}
