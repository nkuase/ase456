// Simplified Widget Tests for TodoListView
// These tests work around the async loading issues and focus on core functionality

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo/viewmodels/todo_viewmodel.dart';
import 'package:todo/views/todo_list_view.dart';
import 'package:todo/views/add_todo_view.dart';
import 'package:todo/services/todo_service.dart';

// Import our professional test logger
import '../utils/test_logger.dart';

void main() {
  group('TodoListView Widget Tests', () {
    late TodoViewModel viewModel;

    setUp(() {
      final service = TodoService();
      viewModel = TodoViewModel(service);
    });
    
    // Clean up logs after all tests complete
    tearDownAll(() {
      TestLogger.finalize();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<TodoViewModel>.value(
          value: viewModel,
          child: const TodoListView(),
        ),
      );
    }

    group('Initial State Tests', () {
      testWidgets('should display app bar with correct title', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('MVVM Todo App'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should display search field and filter chips',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Search todos...'), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.text('All'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
        expect(find.text('Pending'), findsOneWidget);
      });

      testWidgets('should display floating action button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('should display empty state after loading', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester
            .pump(const Duration(milliseconds: 600)); // Wait for loading

        // Assert
        expect(find.byIcon(Icons.task_alt), findsOneWidget);
        expect(find.text('No todos yet. Add one!'), findsOneWidget);
        expect(find.text('0/0'), findsOneWidget); // Initial stats
      });

      testWidgets('should not show action buttons when no todos',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        // Assert
        expect(find.text('Complete All'), findsNothing);
        expect(find.text('Clear Completed'), findsNothing);
      });
    });

    group('Todo Management Tests', () {
      testWidgets('should display todos when added via ViewModel',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        // Act
        viewModel.addTodo('Test Todo 1');
        viewModel.addTodo('Test Todo 2', description: 'Description 2');
        await tester.pump();

        // Assert
        expect(find.text('Test Todo 1'), findsOneWidget);
        expect(find.text('Test Todo 2'), findsOneWidget);
        expect(find.text('Description 2'), findsOneWidget);
        expect(find.byType(ListTile), findsNWidgets(2));
        expect(find.byType(Checkbox), findsNWidgets(2));
        expect(find.text('0/2'), findsOneWidget); // Stats display
      });

      testWidgets('should display todos with correct initial state',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        // Act
        viewModel.addTodo('New Todo');
        await tester.pump();

        // Assert
        expect(find.text('New Todo'), findsOneWidget);
        expect(find.byType(Checkbox), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);

        // Check checkbox is unchecked
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, false);
      });

      testWidgets('should toggle todo completion', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        viewModel.addTodo('Toggle Todo');
        await tester.pump();

        // Act
        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        // Assert
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, true);
        expect(find.text('1/1'), findsOneWidget); // Stats should update

        // Check strikethrough styling
        final textWidgets = tester.widgetList<Text>(find.text('Toggle Todo'));
        expect(
            textWidgets.any((text) =>
                text.style?.decoration == TextDecoration.lineThrough &&
                text.style?.color == Colors.grey),
            true);
      });
    });

    group('User Interaction Tests', () {
      testWidgets('should update search query when text changes',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        // Act
        await tester.enterText(find.byType(TextField), 'search query');
        await tester.pump();

        // Assert
        expect(viewModel.searchQuery, 'search query');
      });

      testWidgets('should filter todos by search query', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        viewModel.addTodo('Buy groceries');
        viewModel.addTodo('Walk the dog');
        viewModel.addTodo('Buy books');
        await tester.pump();

        // Act - Search for "buy"
        await tester.enterText(find.byType(TextField), 'buy');
        await tester.pump();

        // Assert
        expect(find.text('Buy groceries'), findsOneWidget);
        expect(find.text('Buy books'), findsOneWidget);
        expect(find.text('Walk the dog'), findsNothing);
      });

      testWidgets('should show no results message for empty search',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        viewModel.addTodo('Test Todo');
        await tester.pump();

        // Act
        await tester.enterText(find.byType(TextField), 'nonexistent');
        await tester.pump();

        // Assert
        expect(find.text('No todos found for "nonexistent"'), findsOneWidget);
      });

      testWidgets('should set filter when filter chip is tapped',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        // Act
        await tester.tap(find.text('Completed'));
        await tester.pump();

        // Assert
        expect(viewModel.currentFilter, TodoFilter.completed);
      });

      testWidgets('should navigate to AddTodoScreen when FAB is tapped',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        // Act
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300)); // Animation

        // Assert
        expect(find.byType(AddTodoView), findsOneWidget);
        expect(find.text('Add New Todo'), findsOneWidget);
      });
    });

    group('Filter and Action Tests', () {
      testWidgets('should filter by completion status', (tester) async {
        TestLogger.section('Starting filter completion status test');
        
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        viewModel.addTodo('Pending Todo');
        viewModel.addTodo('Completed Todo');
        await tester.pump();

        // Log initial state for debugging
        TestLogger.logViewModelState(viewModel, 'After adding todos');

        // Verify IDs are unique (important for proper functionality)
        final todos = viewModel.todos;
        expect(todos.length, 2);
        expect(todos[0].id != todos[1].id, true, reason: 'Todo IDs should be unique');
        
        TestLogger.debug('Todo IDs: [${todos[0].id}, ${todos[1].id}]');

        // Complete the specific todo we want to be completed
        final completedTodo = todos.firstWhere((todo) => todo.title == 'Completed Todo');
        TestLogger.debug('Found todo to complete: ${completedTodo.title} (ID: ${completedTodo.id})');
        
        viewModel.toggleTodo(completedTodo.id);
        await tester.pump();

        // Log state after toggle for debugging
        TestLogger.logViewModelState(viewModel, 'After toggling todo');

        // Act - Filter by completed
        await tester.tap(find.text('Completed'));
        await tester.pump();

        // Log state after filtering for debugging
        TestLogger.logViewModelState(viewModel, 'After filtering by completed');
        TestLogger.logAllTextWidgets(tester, filter: 'Todo');
        
        // Log widget finder results for debugging
        TestLogger.logWidgetFinderResults(find.text('Completed Todo'), 'Completed Todo');
        TestLogger.logWidgetFinderResults(find.text('Pending Todo'), 'Pending Todo');

        // Assert
        expect(find.text('Completed Todo'), findsOneWidget);
        expect(find.text('Pending Todo'), findsNothing);

        // Act - Filter by pending
        await tester.tap(find.text('Pending'));
        await tester.pump();

        TestLogger.logViewModelState(viewModel, 'After filtering by pending');

        // Assert
        expect(find.text('Pending Todo'), findsOneWidget);
        expect(find.text('Completed Todo'), findsNothing);

        // Act - Filter by all
        await tester.tap(find.text('All'));
        await tester.pump();

        TestLogger.logViewModelState(viewModel, 'After filtering by all');

        // Assert
        expect(find.text('Pending Todo'), findsOneWidget);
        expect(find.text('Completed Todo'), findsOneWidget);
        
        TestLogger.section('Filter completion status test completed successfully');
      });

      testWidgets('should show action buttons when todos exist',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        viewModel.addTodo('Test Todo');
        await tester.pump();

        // Assert
        expect(find.text('Complete All'), findsOneWidget);
        expect(find.text('Clear Completed'), findsOneWidget);
      });
    });

    group('Date and Stats Tests', () {
      testWidgets('should display formatted dates correctly', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        // Act
        viewModel.addTodo('Today Todo');
        await tester.pump();

        // Assert - Should display "Today" for today's date
        expect(find.text('Today'), findsOneWidget);
      });

      testWidgets('should update stats correctly as todos change',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        // Initial state
        expect(find.text('0/0'), findsOneWidget);

        // Add todo
        viewModel.addTodo('Test Todo');
        await tester.pump();
        expect(find.text('0/1'), findsOneWidget);

        // Complete todo
        viewModel.toggleTodo(viewModel.todos.first.id);
        await tester.pump();
        expect(find.text('1/1'), findsOneWidget);

        // Add another todo
        viewModel.addTodo('Second Todo');
        await tester.pump();
        expect(find.text('1/2'), findsOneWidget);
      });
    });

    group('Delete Functionality', () {
      testWidgets('should show delete confirmation dialog', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        viewModel.addTodo('Delete Me');
        await tester.pump();

        // Act
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pump();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Delete Todo'), findsOneWidget);
        expect(find.text('Are you sure you want to delete "Delete Me"?'),
            findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('should delete todo when confirmed', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump(const Duration(milliseconds: 600));

        viewModel.addTodo('Delete Me');
        await tester.pump();

        // Act
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pump();
        await tester.tap(find.text('Delete'));
        await tester.pump();

        // Assert
        expect(find.text('Delete Me'), findsNothing);
        expect(viewModel.totalTodos, 0);
      });
    });
  });
}
