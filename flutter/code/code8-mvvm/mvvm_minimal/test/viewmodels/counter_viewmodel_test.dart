// test/viewmodels/counter_viewmodel_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_minimal/viewmodels/counter_viewmodel.dart';

void main() {
  group('CounterViewModel Tests', () {
    late CounterViewModel viewModel;

    setUp(() {
      // Create fresh ViewModel for each test - ensures isolation
      viewModel = CounterViewModel();
    });

    tearDown(() {
      // Clean up after each test (good practice)
      // No specific cleanup needed for this simple ViewModel
    });

    test('should initialize with zero count', () {
      // Assert
      expect(viewModel.count, 0);
    });

    test('should increment count when increment is called', () {
      // Act
      viewModel.increment();
      
      // Assert
      expect(viewModel.count, 1);
    });

    test('should increment multiple times correctly', () {
      // Act
      viewModel.increment();
      viewModel.increment();
      viewModel.increment();
      
      // Assert
      expect(viewModel.count, 3);
    });

    test('should maintain state between calls', () {
      // Act & Assert - Test state persistence
      expect(viewModel.count, 0);
      
      viewModel.increment();
      expect(viewModel.count, 1);
      
      viewModel.increment();
      expect(viewModel.count, 2);
      
      // Calling count multiple times should return same value
      expect(viewModel.count, 2);
      expect(viewModel.count, 2);
    });

    test('should handle large numbers', () {
      // Arrange - Increment many times (reduced for faster tests)
      for (int i = 0; i < 100; i++) {  // Reduced from 1000 to 100
        viewModel.increment();
      }
      
      // Assert
      expect(viewModel.count, 100);
    });

    test('count getter should always return current value', () {
      // Arrange - Get initial count
      final initialCount = viewModel.count;
      
      // Act - Increment and check
      viewModel.increment();
      final afterIncrement = viewModel.count;
      
      // Assert - Values should be different
      expect(initialCount, 0);
      expect(afterIncrement, 1);
    });

    test('should create independent instances', () {
      // Arrange
      final viewModel1 = CounterViewModel();
      final viewModel2 = CounterViewModel();
      
      // Act
      viewModel1.increment();
      viewModel1.increment();
      viewModel2.increment();
      
      // Assert - Each instance maintains its own state
      expect(viewModel1.count, 2);
      expect(viewModel2.count, 1);
    });
  });
}