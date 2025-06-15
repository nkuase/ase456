# Mini MVVM Test Suite

Comprehensive tests for all layers of the MVVM pattern.

## 📂 Test Structure

```
test/
├── viewmodel_test.dart              # Main test runner
├── models/
│   └── counter_test.dart           # Model layer tests
├── viewmodels/
│   └── counter_viewmodel_test.dart # ViewModel layer tests
├── widgets/
│   └── counter_view_test.dart      # View layer tests
└── integration/
    └── mvvm_integration_test.dart  # Full MVVM flow tests
```

## 🚀 How to Run Tests

### **Run All Tests:**
```bash
flutter test
```

### **Run Specific Test Files:**
```bash
# Model tests only
flutter test test/models/counter_test.dart

# ViewModel tests only  
flutter test test/viewmodels/counter_viewmodel_test.dart

# Widget tests only
flutter test test/widgets/counter_view_test.dart

# Integration tests only
flutter test test/integration/mvvm_integration_test.dart
```

### **Run with Verbose Output:**
```bash
flutter test --reporter expanded
```

## 🧪 Test Categories

### **📦 Model Layer Tests** (`models/counter_test.dart`)
Tests the **pure data** layer:
- ✅ Counter creation with initial values
- ✅ Increment functionality
- ✅ **Immutability** (original objects unchanged)
- ✅ Multiple increments
- ✅ Edge cases (negative numbers)

**Key Learning:** Models should be pure data with no side effects.

### **🧠 ViewModel Layer Tests** (`viewmodels/counter_viewmodel_test.dart`)
Tests the **business logic** layer:
- ✅ Initial state (starts at 0)
- ✅ State updates via increment()
- ✅ **State persistence** between calls
- ✅ Multiple increments
- ✅ **Independent instances**

**Key Learning:** ViewModels manage state and business logic.

### **🎨 View Layer Tests** (`widgets/counter_view_test.dart`)
Tests the **UI** layer:
- ✅ Initial display shows "Count: 0"
- ✅ Button exists and is tappable
- ✅ **UI updates** when button pressed
- ✅ Multiple button presses
- ✅ App bar and explanation text
- ✅ Print State button behavior

**Key Learning:** Views display data and handle user interactions.

### **🔄 Integration Tests** (`integration/mvvm_integration_test.dart`)
Tests the **complete MVVM flow**:
- ✅ Full user interaction flow
- ✅ **Separation of concerns**
- ✅ Model immutability in MVVM context
- ✅ **Independent ViewModels**
- ✅ **Testability advantages**

**Key Learning:** MVVM components work together while staying independent.

## 📊 Expected Test Results

When you run `flutter test`, you should see:

```
🧪 Running Mini MVVM Test Suite
=====================================

✓ Counter Model Tests (6 tests)
✓ CounterViewModel Tests (7 tests)  
✓ CounterView Widget Tests (9 tests)
✓ MVVM Integration Tests (6 tests)

✅ All tests passed! (28 tests)
```

## 🎓 What Students Learn

### **Testing Each MVVM Layer:**
1. **Models:** Test pure data and business rules
2. **ViewModels:** Test state management and logic
3. **Views:** Test UI behavior and user interactions
4. **Integration:** Test the complete system

### **Key Testing Principles:**
- ✅ **Unit Tests:** Test individual components in isolation
- ✅ **Widget Tests:** Test UI behavior
- ✅ **Integration Tests:** Test components working together
- ✅ **Separation:** Each layer can be tested independently

### **MVVM Testing Advantages:**
- **Business logic** tested without UI
- **UI behavior** tested without complex logic
- **Models** tested for data integrity
- **Integration** verified without external dependencies

## 🔧 Test-Driven Development

You can use these tests to practice TDD:

1. **Red:** Write a failing test
2. **Green:** Write minimal code to make it pass
3. **Refactor:** Improve the code while keeping tests green

## 💡 Adding More Tests

Want to extend the tests? Try adding:
- **Decrement functionality** tests
- **Reset functionality** tests  
- **Input validation** tests
- **Performance** tests
- **Error handling** tests

Perfect for learning comprehensive testing in Flutter MVVM! 🎯