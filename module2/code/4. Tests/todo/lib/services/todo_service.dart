import 'package:flutter/foundation.dart';
import '../models/todo.dart';

/// Service - Handles data operations
/// 
/// This simulates a repository or service layer that could interact with
/// databases, APIs, or local storage. In MVVM, services are responsible
/// for data operations and business logic related to data access.
class TodoService {
  // Simulated database using a list
  final List<Todo> _todos = [];
  
  /// Get all todos
  List<Todo> getAllTodos() {
    return List.unmodifiable(_todos);
  }

  /// Add a new todo
  void addTodo(Todo todo) {
    _todos.add(todo);
    if (kDebugMode) {
      print('TodoService: Added todo "${todo.title}" (${todo.id}). Total todos: ${_todos.length}');
    }
  }

  /// Update an existing todo
  void updateTodo(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      if (kDebugMode) {
        print('TodoService: Updated todo "${updatedTodo.title}" (${updatedTodo.id})');
      }
    }
  }

  /// Delete a todo by ID - ENHANCED with better debugging
  void deleteTodo(String id) {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) {
      if (kDebugMode) {
        print('TodoService: WARNING - Cannot delete todo with ID $id - not found!');
      }
      return;
    }
    
    final todoToDelete = _todos[todoIndex];
    final beforeCount = _todos.length;
    _todos.removeWhere((todo) => todo.id == id);
    final afterCount = _todos.length;
    final removedCount = beforeCount - afterCount;
    
    if (kDebugMode) {
      print('TodoService: Attempting to delete todo with ID: $id');
      print('TodoService: Todo to delete: "${todoToDelete.title}" (completed: ${todoToDelete.isCompleted})');
      print('TodoService: Removed $removedCount todos. Before: $beforeCount, After: $afterCount');
      print('TodoService: Remaining todos: ${_todos.map((t) => '"${t.title}" (${t.isCompleted})').join(', ')}');
    }
    
    // Verify the todo was actually removed
    final stillExists = _todos.any((todo) => todo.id == id);
    if (stillExists && kDebugMode) {
      print('TodoService: ERROR - Todo with ID $id still exists after deletion!');
    }
  }

  /// Toggle todo completion status - ENHANCED with better debugging
  void toggleTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = _todos[index];
      final wasCompleted = todo.isCompleted;
      _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
      
      if (kDebugMode) {
        print('TodoService: Toggled todo "${todo.title}" (${todo.id}): ${wasCompleted} -> ${!wasCompleted}');
      }
    } else if (kDebugMode) {
      print('TodoService: ERROR - Cannot toggle todo with ID $id - not found!');
    }
  }

  /// Get completed todos
  List<Todo> getCompletedTodos() {
    return _todos.where((todo) => todo.isCompleted).toList();
  }

  /// Get pending todos
  List<Todo> getPendingTodos() {
    return _todos.where((todo) => !todo.isCompleted).toList();
  }

  /// Search todos by title
  List<Todo> searchTodos(String query) {
    if (query.isEmpty) return getAllTodos();
    return _todos.where((todo) => 
      todo.title.toLowerCase().contains(query.toLowerCase()) ||
      todo.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  /// ADDED: Get debug info about current state
  void printDebugInfo() {
    if (kDebugMode) {
      print('TodoService DEBUG INFO:');
      print('  Total todos: ${_todos.length}');
      print('  Completed: ${getCompletedTodos().length}');
      print('  Pending: ${getPendingTodos().length}');
      print('  All todos:');
      for (var i = 0; i < _todos.length; i++) {
        final todo = _todos[i];
        print('    [$i] "${todo.title}" (${todo.id}) - Completed: ${todo.isCompleted}');
      }
    }
  }

  /// ADDED: Force clear all todos (for testing)
  void clearAllTodos() {
    _todos.clear();
    if (kDebugMode) {
      print('TodoService: Cleared all todos');
    }
  }
}
