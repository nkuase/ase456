// 🔧 DEBUG VERSION - Integration Test with Detailed Logging
// This version helps us see exactly what's happening in the UI

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

// Import the ACTUAL app components
import 'package:todo/viewmodels/todo_viewmodel.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/views/todo_list_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Debug Integration Tests', () {
    // Helper method to print all text widgets
    void debugPrintAllText(WidgetTester tester) {
      print('=== ALL TEXT WIDGETS ===');
      final allText = find.byType(Text);
      for (var i = 0; i < allText.evaluate().length; i++) {
        final textWidget = tester.widget<Text>(allText.at(i));
        print('Text[$i]: "${textWidget.data}"');
      }
      print('========================');
    }

    // Helper method to create the app with proper MVVM setup
    Widget createTestApp() {
      return MultiProvider(
        providers: [
          Provider<TodoService>(create: (_) => TodoService()),
          ChangeNotifierProvider<TodoViewModel>(
            create: (context) => TodoViewModel(context.read<TodoService>()),
          ),
        ],
        child: const MaterialApp(
          home: TodoListView(),
          debugShowCheckedModeBanner: false,
        ),
      );
    }

    testWidgets('DEBUG: Check what stats are actually displayed', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      print('\n--- INITIAL STATE ---');
      debugPrintAllText(tester);

      // Navigate to add todo screen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      print('\n--- ON ADD TODO SCREEN ---');
      debugPrintAllText(tester);

      // Add first todo
      await tester.enterText(find.byType(TextFormField).first, 'Test Todo');
      await tester.tap(find.text('Save Todo'));
      await tester.pumpAndSettle();

      print('\n--- AFTER ADDING TODO ---');
      debugPrintAllText(tester);

      // Check what stats are displayed
      final statsTexts = ['0/1', '1/1', '0 / 1', '1 / 1', '0/1 ', '1/1 ', ' 0/1', ' 1/1'];
      for (final statsText in statsTexts) {
        final found = find.text(statsText).evaluate().length;
        if (found > 0) {
          print('FOUND STATS: "$statsText" ($found widgets)');
        }
      }

      // Look for any text containing '/'
      final allText = find.byType(Text);
      for (var i = 0; i < allText.evaluate().length; i++) {
        final textWidget = tester.widget<Text>(allText.at(i));
        final text = textWidget.data ?? '';
        if (text.contains('/')) {
          print('TEXT WITH SLASH: "$text"');
        }
      }

      // Check ViewModel state directly
      final context = tester.element(find.byType(TodoListView));
      final viewModel = Provider.of<TodoViewModel>(context, listen: false);
      print('\nVIEWMODEL STATE:');
      print('Total todos: ${viewModel.totalTodos}');
      print('Completed todos: ${viewModel.completedTodos}');
      print('Pending todos: ${viewModel.pendingTodos}');
      print('Expected stats text: "${viewModel.completedTodos}/${viewModel.totalTodos}"');

      // Try to complete the todo
      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().isNotEmpty) {
        print('\n--- BEFORE COMPLETING TODO ---');
        print('Found ${checkboxes.evaluate().length} checkboxes');
        
        await tester.tap(checkboxes.first);
        await tester.pumpAndSettle();
        
        print('\n--- AFTER COMPLETING TODO ---');
        debugPrintAllText(tester);
        
        print('VIEWMODEL STATE AFTER COMPLETION:');
        print('Total todos: ${viewModel.totalTodos}');
        print('Completed todos: ${viewModel.completedTodos}');
        print('Expected stats text: "${viewModel.completedTodos}/${viewModel.totalTodos}"');
        
        // Check for various possible formats
        final possibleFormats = [
          '${viewModel.completedTodos}/${viewModel.totalTodos}',
          '${viewModel.completedTodos} / ${viewModel.totalTodos}',
          '${viewModel.completedTodos}/${viewModel.totalTodos} ',
          ' ${viewModel.completedTodos}/${viewModel.totalTodos}',
        ];
        
        for (final format in possibleFormats) {
          final found = find.text(format).evaluate().length;
          print('Checking format "$format": ${found > 0 ? "FOUND" : "NOT FOUND"}');
        }
      }
    });
  });
}
