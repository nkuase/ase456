# Flutter Testing Examples

This project demonstrates **Flutter testing best practices** based on MVVM architecture. It's designed for educational purposes to teach students the fundamentals of testing in Flutter.

## 📋 What This Demonstrates

### 🧪 **Unit Tests** (`test/unit/`)
- **Todo Model Tests**: Testing data classes with equality, copyWith, and edge cases
- **TodoViewModel Tests**: Testing business logic, state management, and ChangeNotifier behavior

### 🎨 **View Tests** (`test/view/`)
- **TodoItem Tests**: Testing individual view rendering and interactions
- **TodoCounter Tests**: Testing view properties, colors, and computed values

### 🌐 **Integration Tests** (`integration_test/`)
- **Complete User Flows**: Testing end-to-end scenarios like adding, completing, and deleting todos

## 🏗️ Architecture Overview

Based on **MVVM (Model-View-ViewModel)** pattern:

```
lib/
├── models/           # Data classes (Todo)
├── viewmodels/       # Business logic (TodoViewModel)
├── views/           # UI components (TodoItem, TodoCounter, TodoListScreen)
└── main.dart        # App entry point
```

## 🚀 How to Run Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Types
```bash
# Unit tests only
flutter test test/unit/

# View tests only  
flutter test test/view/

# Specific test file
flutter test test/unit/todo_model_test.dart
```

### Run Integration Tests
```bash
flutter test integration_test/
```

### Generate Test Coverage
```bash
flutter test --coverage
```

## 🎯 Key Testing Concepts Demonstrated

### **Unit Testing**
- ✅ AAA Pattern (Arrange, Act, Assert)
- ✅ Testing business logic in isolation
- ✅ Testing edge cases and error scenarios
- ✅ ChangeNotifier behavior testing

### **View Testing**
- ✅ Finding widgets by type, text, and key
- ✅ Testing user interactions (tap, input)
- ✅ Verifying widget properties and styling
- ✅ Testing widget state changes
- ✅ Using keys for reliable testing

### **Integration Testing**
- ✅ Complete user workflows
- ✅ End-to-end scenarios
- ✅ Real widget interactions
- ✅ Navigation and state persistence

## 📚 Learning Path

1. **Start with Unit Tests** - Learn the basics with simple model tests
2. **Move to ViewModels** - Understand business logic testing
3. **Add View Tests** - Learn UI component testing
4. **Finish with Integration** - Test complete user flows

## 🔧 Test Structure Examples

### Unit Test Structure
```dart
group('Feature Tests', () {
  setUp(() {
    // Setup test data
  });
  
  test('should do something when condition', () {
    // Arrange
    final input = createTestData();
    
    // Act  
    final result = methodUnderTest(input);
    
    // Assert
    expect(result, expectedValue);
  });
});
```

### View Test Structure
```dart
testWidgets('should display correct information', (tester) async {
  // Arrange
  await tester.pumpWidget(createTestWidget());
  
  // Act
  await tester.tap(find.byType(Button));
  await tester.pump();
  
  // Assert
  expect(find.text('Expected Text'), findsOneWidget);
});
```

## 💡 Best Practices Shown

- **Use meaningful test names** that describe the behavior
- **Test both happy and sad paths** 
- **Use setUp() for common test preparation**
- **Group related tests** for better organization
- **Use keys for reliable widget finding**
- **Test business logic separately from UI**
- **Follow the testing pyramid** (many unit, some view, few integration)

## 🎓 For Students

This example follows the **Marp slide presentation** on Flutter Testing. Each test demonstrates specific concepts covered in the lecture:

- Testing pyramid and strategy
- AAA pattern implementation  
- ChangeNotifier testing
- View interaction testing
- Key usage for stable tests
- Integration test scenarios

Run the tests and examine the code to understand how each concept is implemented!

## 🛠️ Commands Reference

```bash
# Development
flutter run                    # Run the app
flutter test --watch          # Run tests in watch mode
flutter analyze              # Static analysis

# Testing  
flutter test                  # All tests
flutter test --coverage      # With coverage
flutter test --reporter=json # JSON output

# Integration
flutter test integration_test/ # Integration tests only
```

## 📂 Project Structure

```
6. Tests/
├── lib/
│   ├── models/todo.dart           # Simple Todo data model
│   ├── viewmodels/todo_viewmodel.dart  # Business logic with ChangeNotifier
│   ├── views/todo_views.dart      # UI components (TodoItem, TodoCounter)
│   └── main.dart                  # Main app with TodoListScreen
├── test/
│   ├── unit/                      # Unit tests for models and viewmodels
│   │   ├── todo_model_test.dart
│   │   └── todo_viewmodel_test.dart
│   ├── view/                      # View/widget tests
│   │   ├── todo_item_test.dart
│   │   └── todo_counter_test.dart
│   └── mocks/                     # Mock implementations (simple)
├── integration_test/
│   └── app_test.dart             # End-to-end user flow tests
├── pubspec.yaml                  # Dependencies for testing
└── README.md                     # This file
```

Happy Testing! 🧪✨