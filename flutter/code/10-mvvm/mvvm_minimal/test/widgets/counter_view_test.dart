// test/widgets/counter_view_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_minimal/views/counter_view.dart';

void main() {
  group('CounterView Widget Tests', () {
    testWidgets('should display initial count of 0', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Assert
      expect(find.text('Count: 0'), findsOneWidget);
    });

    testWidgets('should have Add 1 button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Assert
      expect(find.text('Add 1'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
    });

    testWidgets('should increment count when button is pressed', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Verify initial state
      expect(find.text('Count: 0'), findsOneWidget);
      
      // Act - Tap the button
      await tester.tap(find.text('Add 1'));
      await tester.pump(); // Trigger rebuild
      
      // Assert
      expect(find.text('Count: 1'), findsOneWidget);
      expect(find.text('Count: 0'), findsNothing);
    });

    testWidgets('should increment multiple times', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Act - Tap button multiple times
      await tester.tap(find.text('Add 1'));
      await tester.pump();
      await tester.tap(find.text('Add 1'));
      await tester.pump();
      await tester.tap(find.text('Add 1'));
      await tester.pump();
      
      // Assert
      expect(find.text('Count: 3'), findsOneWidget);
    });

    testWidgets('should have app bar with correct title', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Assert
      expect(find.text('Mini MVVM Test'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should have explanation section', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Assert
      expect(find.text('How it works:'), findsOneWidget);
      expect(find.textContaining('viewModel.increment()'), findsOneWidget);
    });

    testWidgets('should have Print State button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Assert
      expect(find.text('Print State (No UI Update)'), findsOneWidget);
    });

    testWidgets('Print State button should not change display', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Act - Tap Print State button (should not update UI)
      await tester.tap(find.text('Print State (No UI Update)'));
      await tester.pump();
      
      // Assert - Count should still be 0
      expect(find.text('Count: 0'), findsOneWidget);
    });

    testWidgets('should handle rapid button presses', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Act - Rapid taps
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Add 1'));
        await tester.pump();
      }
      
      // Assert
      expect(find.text('Count: 5'), findsOneWidget);
    });

    testWidgets('should show count persists in same widget instance', (WidgetTester tester) async {
      // This test shows that ViewModel state persists within the same widget instance
      
      // Arrange
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Verify initial state
      expect(find.text('Count: 0'), findsOneWidget);
      
      // Act - Increment the counter twice
      await tester.tap(find.text('Add 1'));
      await tester.pump();
      expect(find.text('Count: 1'), findsOneWidget);
      
      await tester.tap(find.text('Add 1'));
      await tester.pump();
      expect(find.text('Count: 2'), findsOneWidget);
      
      // The ViewModel state persists because it's the same widget instance
      // This demonstrates proper MVVM state management
    });

    testWidgets('should display all UI elements correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(home: CounterView()));
      
      // Assert - Check all major UI elements exist
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Mini MVVM Test'), findsOneWidget);
      expect(find.text('Count: 0'), findsOneWidget);
      expect(find.text('Add 1'), findsOneWidget);
      expect(find.text('Print State (No UI Update)'), findsOneWidget);
      expect(find.text('How it works:'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsAtLeastNWidgets(2));
    });
  });
}