import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:db_abstraction_demo_mvvm/services/database_service_notifier.dart';
import 'package:db_abstraction_demo_mvvm/views/database_setup/database_setup_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Basic Widget Tests', () {
    testWidgets('App shows main UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => DatabaseServiceNotifier(),
            child: const DatabaseSetupScreen(),
          ),
        ),
      );
      await tester.pump();

      // Verify essential UI elements are present
      expect(find.text('Database Abstraction Demo'), findsOneWidget);
      expect(find.text('Choose a Database Implementation'), findsOneWidget);
      expect(find.byIcon(Icons.school), findsOneWidget);
    });

    testWidgets('App shows loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => DatabaseServiceNotifier(),
            child: const DatabaseSetupScreen(),
          ),
        ),
      );
      await tester.pump();

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
