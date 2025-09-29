import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/todo_viewmodel.dart';
import '../models/todo.dart';
import 'add_todo_view.dart';

/// View - The UI layer that displays data and handles user interactions
///
/// This screen demonstrates MVVM principles:
/// 1. It only handles UI logic and user interactions
/// 2. It gets data from the ViewModel
/// 3. It notifies the ViewModel of user actions
/// 4. It listens to ViewModel changes and rebuilds accordingly
class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MVVM Todo App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Statistics display
          Consumer<TodoViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '${viewModel.completedTodos}/${viewModel.totalTodos}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchAndFilter(),

          // Todo List
          Expanded(
            child: _buildTodoList(),
          ),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTodo(context),
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build search and filter widgets
  Widget _buildSearchAndFilter() {
    return Consumer<TodoViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search TextField
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search todos...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: context.read<TodoViewModel>().updateSearchQuery,
              ),
              const SizedBox(height: 12),

              // Filter Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: TodoFilter.values.map((filter) {
                  return FilterChip(
                    label: Text(filter.displayName),
                    selected: viewModel.currentFilter == filter,
                    onSelected: (_) =>
                        context.read<TodoViewModel>().setFilter(filter),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build the todo list
  Widget _buildTodoList() {
    return Consumer<TodoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final todos = viewModel.todos;

        if (todos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  viewModel.searchQuery.isNotEmpty
                      ? 'No todos found for "${viewModel.searchQuery}"'
                      : 'No todos yet. Add one!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return _buildTodoItem(context, todo, viewModel);
          },
        );
      },
    );
  }

  /// Build individual todo item
  Widget _buildTodoItem(
      BuildContext context, Todo todo, TodoViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => context.read<TodoViewModel>().toggleTodo(todo.id),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: todo.description.isNotEmpty
            ? Text(
                todo.description,
                style: TextStyle(
                  color: todo.isCompleted ? Colors.grey : null,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatDate(todo.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () =>
                  _showDeleteConfirmation(context, todo, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Consumer<TodoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.totalTodos == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: viewModel.pendingTodos > 0
                    ? context.read<TodoViewModel>().markAllCompleted
                    : null,
                icon: const Icon(Icons.done_all),
                label: const Text('Complete All'),
              ),
              ElevatedButton.icon(
                onPressed: viewModel.completedTodos > 0
                    ? context.read<TodoViewModel>().clearCompleted
                    : null,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear Completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Navigate to add todo screen
  void _navigateToAddTodo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddTodoView(),
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(
      BuildContext context, Todo todo, TodoViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: Text('Are you sure you want to delete "${todo.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                viewModel.deleteTodo(todo.id);
                // We cannot use this because this context is from the dialog
                //context.read<TodoViewModel>().deleteTodo(todo.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
