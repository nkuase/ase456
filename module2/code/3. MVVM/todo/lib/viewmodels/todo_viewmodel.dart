import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

/// ViewModel - Contains business logic and manages state
///
/// This class acts as the bridge between the View (UI) and the Model (data).
/// It extends ChangeNotifier to provide reactive state management.
/// The ViewModel should NOT know about Flutter widgets or UI concerns.
class TodoViewModel extends ChangeNotifier {
  final TodoService _todoService;

  // Private state variables
  List<Todo> _todos = [];
  bool _isLoading = false;
  String _searchQuery = '';
  TodoFilter _currentFilter = TodoFilter.all;

  // Constructor - Dependency injection of the service
  TodoViewModel(this._todoService) {
    _loadTodos();
  }

  // Public getters - Expose state to the View
  List<Todo> get todos => _getFilteredTodos();
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  TodoFilter get currentFilter => _currentFilter;

  // Computed properties
  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((todo) => todo.isCompleted).length;
  int get pendingTodos => _todos.where((todo) => !todo.isCompleted).length;

  /// Load todos from service
  void _loadTodos() {
    _todos = _todoService.getAllTodos();
  }

  /// Add a new todo
  void addTodo(String title, {String description = ""}) {
    if (title.trim().isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
    );

    _todoService.addTodo(newTodo);
    _todos = _todoService.getAllTodos();
    notifyListeners();
  }

  /// Toggle todo completion status
  void toggleTodo(String id) {
    _todoService.toggleTodo(id);
    _todos = _todoService.getAllTodos();
    notifyListeners();
  }

  /// Delete a todo
  void deleteTodo(String id) {
    _todoService.deleteTodo(id);
    _todos = _todoService.getAllTodos();
    notifyListeners();
  }

  /// Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Set filter
  void setFilter(TodoFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  /// Get filtered todos based on current filter and search query
  List<Todo> _getFilteredTodos() {
    List<Todo> filteredTodos;

    // Apply filter
    switch (_currentFilter) {
      case TodoFilter.completed:
        filteredTodos = _todos.where((todo) => todo.isCompleted).toList();
        break;
      case TodoFilter.pending:
        filteredTodos = _todos.where((todo) => !todo.isCompleted).toList();
        break;
      case TodoFilter.all:
      // ignore: unreachable_switch_default
      default:
        filteredTodos = _todos;
        break;
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filteredTodos = filteredTodos
          .where((todo) =>
              todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              todo.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filteredTodos;
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clear all completed todos
  void clearCompleted() {
    final completedIds = _todos
        .where((todo) => todo.isCompleted)
        .map((todo) => todo.id)
        .toList();

    for (final id in completedIds) {
      _todoService.deleteTodo(id);
    }

    _todos = _todoService.getAllTodos();
    notifyListeners();
  }

  /// Mark all todos as completed
  void markAllCompleted() {
    for (final todo in _todos.where((todo) => !todo.isCompleted)) {
      _todoService.toggleTodo(todo.id);
    }
    _todos = _todoService.getAllTodos();
    notifyListeners();
  }
}

/// Enum for todo filters
enum TodoFilter {
  all,
  completed,
  pending,
}

/// Extension to get display names for filters
extension TodoFilterExtension on TodoFilter {
  String get displayName {
    switch (this) {
      case TodoFilter.all:
        return 'All';
      case TodoFilter.completed:
        return 'Completed';
      case TodoFilter.pending:
        return 'Pending';
    }
  }
}
