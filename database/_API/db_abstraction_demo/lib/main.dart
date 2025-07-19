import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/database_service_notifier.dart';
import 'widgets/database_setup_screen.dart';

/// Main entry point of the Database Abstraction Demo application
///
/// This app demonstrates key software engineering concepts:
/// 1. Interface-based programming
/// 2. Strategy pattern implementation
/// 3. Dependency injection using Provider
/// 4. Clean architecture separation
/// 5. Error handling and user feedback

void main() {
  runApp(const DatabaseAbstractionDemoApp());
}

class DatabaseAbstractionDemoApp extends StatelessWidget {
  const DatabaseAbstractionDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provide DatabaseService to the entire app
      // This demonstrates dependency injection pattern
      create: (context) => DatabaseServiceNotifier(),
      child: MaterialApp(
        title: 'Database Abstraction Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const DatabaseSetupScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
