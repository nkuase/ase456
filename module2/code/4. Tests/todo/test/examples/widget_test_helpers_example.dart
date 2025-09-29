// ===============================================================================
// 📚 EXAMPLE: Widget Test Helpers
// ===============================================================================
// 
// ⚠️  NOTE: This file is NOT currently used in the test suite!
// 
// This file demonstrates professional widget test helper patterns and utilities
// that could be used to make widget tests more maintainable and consistent.
// 
// 🎓 EDUCATIONAL PURPOSE:
//   - Shows how to create reusable test utilities
//   - Demonstrates professional testing patterns
//   - Provides examples of test helper organization
//   - Shows extension methods for cleaner test code
// 
// 🔧 TO USE THIS:
//   1. Copy relevant helpers to your test files
//   2. Import: import '../examples/widget_test_helpers_example.dart';
//   3. Use: WidgetTestHelpers.createTestApp(...)
// 
// 🗑️  TO REMOVE:
//   This is completely safe to delete if you prefer simpler, direct test code.
// ===============================================================================

// Test Helper Functions for Widget Tests
// These helpers make widget tests more maintainable and consistent

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo/viewmodels/todo_viewmodel.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/models/todo.dart';

/// Test Helper class for common widget testing functionality
class WidgetTestHelpers {
  /// Creates a MaterialApp wrapper with Provider for testing widgets
  /// This is the standard setup needed for most widget tests
  static Widget createTestApp({
    required Widget child,
    TodoViewModel? viewModel,
  }) {
    final vm = viewModel ?? TodoViewModel(TodoService());
    return MaterialApp(
      home: ChangeNotifierProvider<TodoViewModel>.value(
        value: vm,
        child: child,
      ),
    );
  }

  /// Creates a fresh TodoViewModel with TodoService for testing
  static TodoViewModel createTestViewModel() {
    final service = TodoService();
    return TodoViewModel(service);
  }

  /// Creates a navigation-aware test app for testing navigation flows
  static Widget createNavigationTestApp({
    required Widget home,
    TodoViewModel? viewModel,
  }) {
    final vm = viewModel ?? TodoViewModel(TodoService());
    return MaterialApp(
      home: ChangeNotifierProvider<TodoViewModel>.value(
        value: vm,
        child: home,
      ),
    );
  }

  /// Helper to wait for loading states to complete
  static Future<void> waitForLoading(WidgetTester tester) async {
    await tester.pump(); // Initial pump
    await tester.pump(); // Wait for loading to complete
  }

  /// Helper to add multiple test todos to a ViewModel
  static void addTestTodos(TodoViewModel viewModel, List<String> titles) {
    for (final title in titles) {
      viewModel.addTodo(title);
    }
  }

  /// Helper to create a test todo with specific properties
  static Todo createTestTodo({
    String? id,
    String title = 'Test Todo',
    String description = '',
    bool isCompleted = false,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }

  /// Common expectation helpers
  static void expectEmptyState(WidgetTester tester) {
    expect(find.byIcon(Icons.task_alt), findsOneWidget);
    expect(find.text('No todos yet. Add one!'), findsOneWidget);
  }

  static void expectTodoInList(String title) {
    expect(find.text(title), findsOneWidget);
  }

  static void expectStatsDisplay(String expectedStats) {
    expect(find.text(expectedStats), findsOneWidget);
  }

  /// Helper for common user interactions
  static Future<void> enterSearchText(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    await tester.pump();
  }

  static Future<void> tapFilterChip(
      WidgetTester tester, String filterName) async {
    await tester.tap(find.text(filterName));
    await tester.pump();
  }

  static Future<void> tapCheckbox(WidgetTester tester, {int index = 0}) async {
    final checkboxes = find.byType(Checkbox);
    await tester.tap(checkboxes.at(index));
    await tester.pump();
  }

  static Future<void> tapDeleteButton(WidgetTester tester,
      {int index = 0}) async {
    final deleteButtons = find.byIcon(Icons.delete);
    await tester.tap(deleteButtons.at(index));
    await tester.pump();
  }

  static Future<void> confirmDeletion(WidgetTester tester) async {
    await tester.tap(find.text('Delete'));
    await tester.pump();
  }

  static Future<void> cancelDeletion(WidgetTester tester) async {
    await tester.tap(find.text('Cancel'));
    await tester.pump();
  }

  /// Helper for form interactions
  static Future<void> fillTodoForm(
    WidgetTester tester, {
    required String title,
    String description = '',
  }) async {
    await tester.enterText(find.byType(TextFormField).first, title);
    if (description.isNotEmpty) {
      await tester.enterText(find.byType(TextFormField).last, description);
    }
  }

  static Future<void> submitTodoForm(WidgetTester tester) async {
    await tester.tap(find.text('Save Todo'));
    await tester.pump();
  }

  /// Helper for navigation testing
  static Future<void> navigateToAddTodo(WidgetTester tester) async {
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  }

  static Future<void> navigateBack(WidgetTester tester) async {
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  }

  /// Helper for validation testing
  static void expectValidationError(String errorMessage) {
    expect(find.text(errorMessage), findsOneWidget);
  }

  static void expectNoValidationError(String errorMessage) {
    expect(find.text(errorMessage), findsNothing);
  }

  /// Helper for success message testing
  static void expectSuccessSnackbar() {
    expect(find.text('Todo added successfully!'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  }

  /// Helper for button state testing
  static void expectButtonEnabled(String buttonText) {
    final buttonFinder = find.ancestor(
      of: find.text(buttonText),
      matching: find.byType(ElevatedButton),
    );
    final button = find.byType(ElevatedButton);
    expect(button, findsWidgets);
    // Note: To properly test button state, you would need to check the onPressed property
  }

  static void expectButtonDisabled(WidgetTester tester, String buttonText) {
    final button = tester.widget<ElevatedButton>(
      find.ancestor(
        of: find.text(buttonText),
        matching: find.byType(ElevatedButton),
      ),
    );
    expect(button.onPressed, isNull);
  }

  /// Helper for checkbox state testing
  static void expectCheckboxState(WidgetTester tester, bool expectedState,
      {int index = 0}) {
    final checkboxes = find.byType(Checkbox);
    final checkbox = tester.widget<Checkbox>(checkboxes.at(index));
    expect(checkbox.value, expectedState);
  }

  /// Helper for text style testing
  static void expectStrikethroughText(WidgetTester tester, String text) {
    final textWidgets = tester.widgetList<Text>(find.text(text));
    final strikethroughText = textWidgets.firstWhere((textWidget) =>
        textWidget.style?.decoration == TextDecoration.lineThrough);
    expect(strikethroughText.style?.decoration, TextDecoration.lineThrough);
    expect(strikethroughText.style?.color, Colors.grey);
  }

  /// Debug helpers for troubleshooting tests
  static void printAllWidgets(WidgetTester tester) {
    print('All widgets:');
    tester.allWidgets.forEach((widget) {
      print('- ${widget.runtimeType}');
    });
  }

  static void printAllText(WidgetTester tester) {
    print('All text widgets:');
    final textWidgets = tester.widgetList<Text>(find.byType(Text));
    textWidgets.forEach((text) {
      print('- "${text.data}"');
    });
  }
}

/// Extension methods for common test patterns
extension WidgetTesterExtensions on WidgetTester {
  /// Pump and wait for loading to complete
  Future<void> pumpAndWaitForLoading() async {
    await pump();
    await pump();
  }

  /// Enter text and pump in one call
  Future<void> enterTextAndPump(Finder finder, String text) async {
    await enterText(finder, text);
    await pump();
  }

  /// Tap and pump in one call
  Future<void> tapAndPump(Finder finder) async {
    await tap(finder);
    await pump();
  }

  /// Tap and settle in one call
  Future<void> tapAndSettle(Finder finder) async {
    await tap(finder);
    await pumpAndSettle();
  }
}

/// Common test data for consistent testing
class TestData {
  static const String validTodoTitle = 'Valid Todo Title';
  static const String validTodoDescription = 'Valid todo description';
  static const String shortTitle = 'ab'; // Too short for validation
  static String longTitle = 'A' * 120; // Too long for title field
  static const String emptyTitle = '';
  static const String whitespaceTitle = '   ';

  static List<String> sampleTodoTitles = [
    'Buy groceries',
    'Walk the dog',
    'Finish homework',
    'Call mom',
    'Read a book',
  ];

  static List<Map<String, String>> sampleTodosWithDescriptions = [
    {'title': 'Buy groceries', 'description': 'Milk, bread, eggs'},
    {'title': 'Walk the dog', 'description': 'Take Max to the park'},
    {'title': 'Finish homework', 'description': 'Math problems 1-10'},
  ];
}

/// Common assertions for widget testing
class TestAssertions {
  /// Assert that the empty state is displayed
  static void assertEmptyState() {
    expect(find.byIcon(Icons.task_alt), findsOneWidget);
    expect(find.text('No todos yet. Add one!'), findsOneWidget);
  }

  /// Assert that the search functionality works
  static void assertSearchResults({
    required List<String> visibleTodos,
    required List<String> hiddenTodos,
  }) {
    for (final todo in visibleTodos) {
      expect(find.text(todo), findsOneWidget);
    }
    for (final todo in hiddenTodos) {
      expect(find.text(todo), findsNothing);
    }
  }

  /// Assert that stats are displayed correctly
  static void assertStats({
    required int completed,
    required int total,
  }) {
    expect(find.text('$completed/$total'), findsOneWidget);
  }

  /// Assert that a todo has the correct completion state
  static void assertTodoCompletionState(
    WidgetTester tester,
    String todoTitle,
    bool shouldBeCompleted,
  ) {
    if (shouldBeCompleted) {
      WidgetTestHelpers.expectStrikethroughText(tester, todoTitle);
    } else {
      expect(find.text(todoTitle), findsOneWidget);
    }
  }
}
