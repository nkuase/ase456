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
  }

  /// Update an existing todo
  void updateTodo(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
    }
  }

  /// Delete a todo by ID
  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
  }

  /// Toggle todo completion status
  void toggleTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = _todos[index];
      _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
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
}
