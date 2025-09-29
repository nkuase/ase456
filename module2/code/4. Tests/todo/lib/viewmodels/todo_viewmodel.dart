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

  // Computed properties - Make sure these reflect the current state
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

    // Generate unique ID using timestamp + counter to avoid collisions
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueId = '$timestamp-${title.hashCode.abs()}';

    final newTodo = Todo(
      id: uniqueId,
      title: title.trim(),
      description: description.trim(),
    );

    _todoService.addTodo(newTodo);
    _refreshTodos();
  }

  /// Toggle todo completion status
  void toggleTodo(String id) {
    if (kDebugMode) {
      print('TodoViewModel: toggleTodo called for ID: $id');
    }
    _todoService.toggleTodo(id);
    _refreshTodos();
  }

  /// Delete a todo
  void deleteTodo(String id) {
    if (kDebugMode) {
      print('TodoViewModel: deleteTodo called for ID: $id');
    }
    _todoService.deleteTodo(id);
    _refreshTodos();
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

  /// Centralized method to refresh todos and notify listeners
  void _refreshTodos() {
    final oldCount = _todos.length;
    final oldCompleted = completedTodos;
    
    _todos = _todoService.getAllTodos();
    
    if (kDebugMode) {
      print('TodoViewModel: _refreshTodos called');
      print('  Before: $oldCompleted/$oldCount');
      print('  After: $completedTodos/$totalTodos');
      print('  Current todos: ${_todos.map((t) => '"${t.title}" (${t.isCompleted})').join(', ')}');
    }
    
    notifyListeners();
  }

  /// FIXED: Clear all completed todos with comprehensive debugging
  void clearCompleted() {
    if (kDebugMode) {
      print('\n======= TodoViewModel: clearCompleted() START =======');
      print('Current state: $completedTodos/$totalTodos');
      print('All todos before clear:');
      for (var i = 0; i < _todos.length; i++) {
        final todo = _todos[i];
        print('  [$i] "${todo.title}" (${todo.id}) - Completed: ${todo.isCompleted}');
      }
    }
    
    // FIXED: Get completed todos to delete (renamed to avoid conflict)
    final todosToDelete = _todos
        .where((todo) => todo.isCompleted)
        .toList();
    
    if (kDebugMode) {
      print('Found ${todosToDelete.length} completed todos to delete:');
      for (final todo in todosToDelete) {
        print('  - "${todo.title}" (${todo.id})');
      }
    }
    
    if (todosToDelete.isEmpty) {
      if (kDebugMode) {
        print('No completed todos to clear. Exiting.');
      }
      return;
    }
    
    // Delete each completed todo
    for (final todo in todosToDelete) {
      if (kDebugMode) {
        print('Deleting todo: "${todo.title}" (${todo.id})');
      }
      _todoService.deleteTodo(todo.id);
    }
    
    // Force refresh state
    _refreshTodos();
    
    // Verify the deletion worked
    final remainingCompletedTodos = _todos.where((todo) => todo.isCompleted).toList();
    
    if (kDebugMode) {
      print('After deletion:');
      print('  Remaining todos: ${_todos.length}');
      print('  Remaining completed todos: ${remainingCompletedTodos.length}');
      if (remainingCompletedTodos.isNotEmpty) {
        print('  ERROR: These completed todos were not deleted:');
        for (final todo in remainingCompletedTodos) {
          print('    - "${todo.title}" (${todo.id})');
        }
      } else {
        print('  SUCCESS: All completed todos were deleted');
      }
      print('  Final state: $completedTodos/$totalTodos');
      print('======= TodoViewModel: clearCompleted() END =======\n');
    }
  }

  /// FIXED: Mark all todos as completed
  void markAllCompleted() {
    if (kDebugMode) {
      print('\n======= TodoViewModel: markAllCompleted() START =======');
      print('Current state: $completedTodos/$totalTodos (pending: $pendingTodos)');
    }
    
    // FIXED: Get pending todos to complete (renamed to avoid conflict)
    final todosToComplete = _todos
        .where((todo) => !todo.isCompleted)
        .toList();
    
    if (kDebugMode) {
      print('Found ${todosToComplete.length} pending todos to complete:');
      for (final todo in todosToComplete) {
        print('  - "${todo.title}" (${todo.id})');
      }
    }
    
    if (todosToComplete.isEmpty) {
      if (kDebugMode) {
        print('No pending todos to complete. Exiting.');
      }
      return;
    }
    
    // Complete each pending todo
    for (final todo in todosToComplete) {
      if (kDebugMode) {
        print('Completing todo: "${todo.title}" (${todo.id})');
      }
      _todoService.toggleTodo(todo.id);
    }
    
    // Force refresh state
    _refreshTodos();
    
    if (kDebugMode) {
      print('After completion:');
      print('  Final state: $completedTodos/$totalTodos (pending: $pendingTodos)');
      if (todosToComplete.isNotEmpty) {
        print('  SUCCESS: All todos are now completed');
      }
      print('======= TodoViewModel: markAllCompleted() END =======\n');
    }
  }
  
  /// Get all raw todos (for debugging and testing)
  List<Todo> getAllTodos() {
    return List.unmodifiable(_todos);
  }

  /// ADDED: Print debug info
  void printDebugInfo() {
    if (kDebugMode) {
      print('\nTodoViewModel DEBUG INFO:');
      print('  Total todos: $totalTodos');
      print('  Completed: $completedTodos'); 
      print('  Pending: $pendingTodos');
      print('  Current filter: $_currentFilter');
      print('  Search query: "$_searchQuery"');
      print('  Visible todos: ${todos.length}');
      _todoService.printDebugInfo();
    }
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
