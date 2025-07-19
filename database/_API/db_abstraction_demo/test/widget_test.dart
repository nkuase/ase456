import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:db_abstraction_demo/services/database_service_notifier.dart';
import 'package:db_abstraction_demo/widgets/database_setup_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Basic Widget Tests', () {
    testWidgets('App shows initial UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => DatabaseServiceNotifier(),
            child: const DatabaseSetupScreen(),
          ),
        ),
      );
      await tester.pump();

      // Basic UI elements
      expect(find.text('Database Abstraction Demo'), findsOneWidget);
      expect(find.text('Welcome to Database Abstraction Demo'), findsOneWidget);
      expect(find.text('Choose a Database Implementation'), findsOneWidget);
      expect(find.byIcon(Icons.school), findsOneWidget);
    });

    testWidgets('App shows loading state initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => DatabaseServiceNotifier(),
            child: const DatabaseSetupScreen(),
          ),
        ),
      );
      await tester.pump();

      // Initial loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Checking database availability...'), findsOneWidget);
    });
  });

  group('Theme Tests', () {
    testWidgets('App uses correct theme colors', (WidgetTester tester) async {
      final theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: ChangeNotifierProvider(
            create: (_) => DatabaseServiceNotifier(),
            child: const DatabaseSetupScreen(),
          ),
        ),
      );
      await tester.pump();

      // Find AppBar and verify its color
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, theme.colorScheme.inversePrimary);
    });
  });
}
