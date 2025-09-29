import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/todo_list_view.dart';
import 'viewmodels/todo_viewmodel.dart';
import 'services/todo_service.dart';
import 'models/todo.dart';

/// Main application entry point
///
/// This file demonstrates MVVM setup with dependency injection:
/// 1. Creates service instances
/// 2. Creates ViewModel instances with injected services
/// 3. Provides ViewModels to the widget tree using Provider
/// 4. Keeps the UI and business logic separated
void main() {
  runApp(const MVVMTodoApp());
}

class MVVMTodoApp extends StatelessWidget {
  const MVVMTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TodoService>(create: (_) => TodoService()),
        ChangeNotifierProvider<TodoViewModel>(
          create: (context) => TodoViewModel(context.read<TodoService>()),
        ),
      ],
      child: MaterialApp(
        title: 'MVVM Todo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TodoListView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Example of how to add sample data for testing
class _SampleDataInitializer {
  static void addSampleData(TodoService service) {
    service.addTodo(
      Todo(
        id: '1',
        title: 'Learn Flutter MVVM',
        description: 'Understand the MVVM pattern and implement it in Flutter',
      ),
    );

    service.addTodo(
      Todo(
        id: '2',
        title: 'Build Todo App',
        description: 'Create a simple todo app to demonstrate MVVM principles',
        isCompleted: true,
      ),
    );

    service.addTodo(
      Todo(
        id: '3',
        title: 'Write Documentation',
        description:
            'Document the MVVM implementation for educational purposes',
      ),
    );
  }
}

/// Alternative main function with sample data for testing
void mainWithSampleData() {
  runApp(
    MultiProvider(
      providers: [
        Provider<TodoService>(
          create: (context) {
            final service = TodoService();
            _SampleDataInitializer.addSampleData(service);
            return service;
          },
        ),
        ChangeNotifierProvider<TodoViewModel>(
          create: (context) => TodoViewModel(
            context.read<TodoService>(),
          ),
        ),
      ],
      child: const MaterialApp(
        title: 'MVVM Todo App',
        home: TodoListView(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
