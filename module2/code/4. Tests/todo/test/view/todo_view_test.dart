// Simplified Widget Tests for TodoListView
// These tests focus on core MVVM functionality without loading state complexity

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo/viewmodels/todo_viewmodel.dart';
import 'package:todo/views/todo_list_view.dart';
import 'package:todo/services/todo_service.dart';

void main() {
  group('TodoListView Tests', () {
    late TodoViewModel viewModel;

    setUp(() {
      final service = TodoService();
      viewModel = TodoViewModel(service);
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider.value(
          value: viewModel,
          child: const TodoListView(),
        ),
      );
    }

    group('Basic UI Elements', () {
      testWidgets('should display app bar with title', (tester) async {
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
    });

    group('Empty State', () {
      testWidgets('should display empty state initially', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert - Empty state should be visible
        expect(find.byIcon(Icons.task_alt), findsOneWidget);
        expect(find.text('No todos yet. Add one!'), findsOneWidget);
      });

      testWidgets('should display initial stats as 0/0', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('0/0'), findsOneWidget);
      });
    });

    group('Adding Todos via ViewModel', () {
      testWidgets('should add and display a single todo', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Act - Add todo directly via ViewModel
        viewModel.addTodo('Test Todo');
        await tester.pump(); // Rebuild after state change

        // Assert
        expect(find.text('Test Todo'), findsOneWidget);
        expect(find.text('0/1'), findsOneWidget); // Stats updated
        expect(find.byType(ListTile), findsOneWidget);
        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('should add multiple todos', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Act
        viewModel.addTodo('Todo 1');
        viewModel.addTodo('Todo 2');
        await tester.pump();

        // Assert
        expect(find.text('Todo 1'), findsOneWidget);
        expect(find.text('Todo 2'), findsOneWidget);
        expect(find.byType(ListTile), findsNWidgets(2));
        expect(find.text('0/2'), findsOneWidget);
      });

      testWidgets('should clear empty state when todos are added',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Verify empty state first
        expect(find.byIcon(Icons.task_alt), findsOneWidget);

        // Act
        viewModel.addTodo('First Todo');
        await tester.pump();

        // Assert - Empty state should be gone
        expect(find.byIcon(Icons.task_alt), findsNothing);
        expect(find.text('No todos yet. Add one!'), findsNothing);
      });
    });

    group('Todo Display and Interaction', () {
      testWidgets('should display todo with checkbox and delete button',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Act
        viewModel.addTodo('Interactive Todo');
        await tester.pump();

        // Assert
        expect(find.text('Interactive Todo'), findsOneWidget);
        expect(find.byType(Checkbox), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);

        // Check checkbox is initially unchecked
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, false);
      });

      testWidgets('should toggle todo completion when checkbox is tapped',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        viewModel.addTodo('Toggle Todo');
        await tester.pump();

        // Act - Tap checkbox
        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        // Assert
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, true);
        expect(find.text('1/1'), findsOneWidget); // Stats updated

        // Check text styling for completed todo
        final textWidgets = tester.widgetList<Text>(find.text('Toggle Todo'));
        expect(
            textWidgets.any((text) =>
                text.style?.decoration == TextDecoration.lineThrough &&
                text.style?.color == Colors.grey),
            true);
      });
    });

    group('Search Functionality', () {
      testWidgets('should filter todos by search query', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

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
        await tester.pump();

        viewModel.addTodo('Test Todo');
        await tester.pump();

        // Act
        await tester.enterText(find.byType(TextField), 'nonexistent');
        await tester.pump();

        // Assert
        expect(find.text('No todos found for "nonexistent"'), findsOneWidget);
      });
    });

    group('Filter Functionality', () {
      testWidgets('should filter by completion status', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        viewModel.addTodo('Completed Todo');
        viewModel.addTodo('Pending Todo');
        await tester.pump();

        // Complete first todo
        viewModel.toggleTodo(viewModel.todos[0].id);
        await tester.pump();

        // Act - Filter by completed
        await tester.tap(find.text('Completed'));
        await tester.pump();

        // Assert
        expect(find.text('Completed Todo'), findsOneWidget);
        expect(find.text('Pending Todo'), findsNothing);
      });
    });

    group('Action Buttons', () {
      testWidgets('should show action buttons when todos exist',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        viewModel.addTodo('Test Todo');
        await tester.pump();

        // Assert
        expect(find.text('Complete All'), findsOneWidget);
        expect(find.text('Clear Completed'), findsOneWidget);
      });

      testWidgets('should not show action buttons when no todos exist',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Complete All'), findsNothing);
        expect(find.text('Clear Completed'), findsNothing);
      });
    });

    group('Navigation', () {
      testWidgets('should navigate to AddTodoView when FAB is tapped',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Act
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();
        await tester
            .pump(const Duration(milliseconds: 300)); // Navigation animation

        // Assert
        expect(find.text('Add New Todo'), findsOneWidget);
      });
    });

    group('Stats Update', () {
      testWidgets('should update stats correctly as todos change',
          (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Initially 0/0
        expect(find.text('0/0'), findsOneWidget);

        // Add todo -> 0/1
        viewModel.addTodo('Test Todo');
        await tester.pump();
        expect(find.text('0/1'), findsOneWidget);

        // Complete todo -> 1/1
        viewModel.toggleTodo(viewModel.todos.first.id);
        await tester.pump();
        expect(find.text('1/1'), findsOneWidget);
      });
    });
  });
}
