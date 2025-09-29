// 🧪 UNIT TEST - Verify ViewModel methods work correctly in isolation

import 'package:flutter_test/flutter_test.dart';
import 'package:todo/viewmodels/todo_viewmodel.dart';
import 'package:todo/services/todo_service.dart';

void main() {
  group('ViewModel Method Tests', () {
    late TodoViewModel viewModel;
    late TodoService service;

    setUp(() {
      service = TodoService();
      viewModel = TodoViewModel(service);
    });

    test('markAllCompleted should complete all todos', () {
      print('\n🧪 Testing markAllCompleted...');
      
      // Add test todos
      viewModel.addTodo('Todo 1');
      viewModel.addTodo('Todo 2');
      viewModel.addTodo('Todo 3');
      
      print('After adding: ${viewModel.completedTodos}/${viewModel.totalTodos}');
      expect(viewModel.totalTodos, 3);
      expect(viewModel.completedTodos, 0);
      
      // Mark all completed
      viewModel.markAllCompleted();
      
      print('After markAllCompleted: ${viewModel.completedTodos}/${viewModel.totalTodos}');
      expect(viewModel.totalTodos, 3);
      expect(viewModel.completedTodos, 3);
      
      // Verify individual todos are completed
      final allTodos = viewModel.todos;
      for (var todo in allTodos) {
        expect(todo.isCompleted, true, reason: 'Todo "${todo.title}" should be completed');
        print('✅ ${todo.title} is completed');
      }
    });

    test('clearCompleted should remove all completed todos', () {
      print('\n🧪 Testing clearCompleted...');
      
      // Add test todos
      viewModel.addTodo('Keep This');
      viewModel.addTodo('Remove This 1');
      viewModel.addTodo('Remove This 2');
      
      print('After adding: ${viewModel.completedTodos}/${viewModel.totalTodos}');
      expect(viewModel.totalTodos, 3);
      expect(viewModel.completedTodos, 0);
      
      // Complete some todos (the last two)
      final todos = viewModel.todos;
      viewModel.toggleTodo(todos[1].id); // Remove This 1
      viewModel.toggleTodo(todos[2].id); // Remove This 2
      
      print('After completing some: ${viewModel.completedTodos}/${viewModel.totalTodos}');
      expect(viewModel.totalTodos, 3);
      expect(viewModel.completedTodos, 2);
      
      // Clear completed
      viewModel.clearCompleted();
      
      print('After clearCompleted: ${viewModel.completedTodos}/${viewModel.totalTodos}');
      expect(viewModel.totalTodos, 1);
      expect(viewModel.completedTodos, 0);
      
      // Verify only uncompleted todo remains
      final remainingTodos = viewModel.todos;
      expect(remainingTodos.length, 1);
      expect(remainingTodos.first.title, 'Keep This');
      expect(remainingTodos.first.isCompleted, false);
      print('✅ Only "Keep This" remains, and it\'s not completed');
    });

    test('combined workflow: add → complete all → clear', () {
      print('\n🧪 Testing combined workflow...');
      
      // Add todos
      viewModel.addTodo('Todo A');
      viewModel.addTodo('Todo B');
      viewModel.addTodo('Todo C');
      print('Step 1 - Added todos: ${viewModel.completedTodos}/${viewModel.totalTodos}');
      
      // Complete all
      viewModel.markAllCompleted();
      print('Step 2 - Completed all: ${viewModel.completedTodos}/${viewModel.totalTodos}');
      
      // Clear completed
      viewModel.clearCompleted();
      print('Step 3 - Cleared completed: ${viewModel.completedTodos}/${viewModel.totalTodos}');
      
      // Final verification
      expect(viewModel.totalTodos, 0);
      expect(viewModel.completedTodos, 0);
      expect(viewModel.todos.isEmpty, true);
      print('✅ All todos successfully cleared');
    });
  });
}
