import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/database_setup/database_setup_screen.dart';
import 'services/database_service_notifier.dart';

/// 🎓 Simple MVVM Database Demo for Students
///
/// This app demonstrates MVVM (Model-View-ViewModel) architecture
/// in a clear, educational way without unnecessary complexity.
///
/// Key Learning Points:
/// 1. Models: Data structures (Student)
/// 2. Views: UI components that only handle presentation
/// 3. ViewModels: Presentation logic and state management
/// 4. Services: Business logic and data operations
///
/// Students can see how:
/// - Views react automatically to ViewModel changes
/// - Business logic is separated from UI logic
/// - Code is more testable and maintainable
/// - Different database implementations work with the same interface

void main() {
  runApp(const MVVMDatabaseDemoApp());
}

class MVVMDatabaseDemoApp extends StatelessWidget {
  const MVVMDatabaseDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provide database service to entire app
      create: (context) => DatabaseServiceNotifier(),
      child: MaterialApp(
        title: 'MVVM Database Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const DatabaseSetupScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
