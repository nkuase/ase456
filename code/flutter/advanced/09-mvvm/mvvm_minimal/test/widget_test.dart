// This is the main app integration test for the MVVM minimal app
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_minimal/main.dart';

void main() {
  testWidgets('MVVM Counter App Integration Test', (WidgetTester tester) async {
    // Build our MVVM app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0 (in MVVM format)
    expect(find.text('Count: 0'), findsOneWidget);
    expect(find.text('Count: 1'), findsNothing);

    // Verify the app title
    expect(find.text('Mini MVVM Test'), findsOneWidget);

    // Tap the 'Add 1' button and trigger a frame.
    await tester.tap(find.text('Add 1'));
    await tester.pump();

    // Verify that our counter has incremented (in MVVM format)
    expect(find.text('Count: 0'), findsNothing);
    expect(find.text('Count: 1'), findsOneWidget);
    
    // Test multiple increments
    await tester.tap(find.text('Add 1'));
    await tester.pump();
    expect(find.text('Count: 2'), findsOneWidget);
    
    // Verify MVVM explanation is present
    expect(find.text('How it works:'), findsOneWidget);
    
    // Verify both buttons exist
    expect(find.text('Add 1'), findsOneWidget);
    expect(find.text('Print State (No UI Update)'), findsOneWidget);
  });
}