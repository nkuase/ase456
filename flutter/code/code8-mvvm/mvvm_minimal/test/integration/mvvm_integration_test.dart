// test/integration/mvvm_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_minimal/models/counter.dart';
import 'package:mvvm_minimal/viewmodels/counter_viewmodel.dart';

void main() {
  group('MVVM Integration Tests', () {
    test('should demonstrate complete MVVM flow', () {
      // Arrange - Create all MVVM components
      final counter = Counter(0);
      final viewModel = CounterViewModel();
      
      // Assert initial state
      expect(counter.value, 0);
      expect(viewModel.count, 0);
      
      // Act - Simulate user interaction
      viewModel.increment(); // User clicks button
      
      // Assert - ViewModel state updated
      expect(viewModel.count, 1);
      
      // Act - Multiple interactions
      viewModel.increment();
      viewModel.increment();
      
      // Assert - State maintained correctly
      expect(viewModel.count, 3);
    });

    test('should show Model immutability in MVVM context', () {
      // Arrange
      final originalCounter = Counter(5);
      final viewModel = CounterViewModel();
      
      // Act - Demonstrate immutability
      final newCounter = originalCounter.increment();
      
      // Assert - Original unchanged (immutability principle)
      expect(originalCounter.value, 5);
      expect(newCounter.value, 6);
      
      // ViewModel manages its own counter instance
      expect(viewModel.count, 0); // Independent of our test counters
    });

    test('should demonstrate separation of concerns', () {
      // Arrange - Test that Model, ViewModel are independent
      final model = Counter(10);
      final viewModel = CounterViewModel();
      
      // Act - Model operations don't affect ViewModel
      final incrementedModel = model.increment();
      
      // Assert - ViewModel state is independent
      expect(model.value, 10);
      expect(incrementedModel.value, 11);
      expect(viewModel.count, 0); // ViewModel unaffected
      
      // Act - ViewModel operations don't affect our model instances
      viewModel.increment();
      
      // Assert - Model instances unaffected
      expect(model.value, 10);
      expect(incrementedModel.value, 11);
      expect(viewModel.count, 1); // Only ViewModel changed
    });

    test('should demonstrate ViewModel as state manager', () {
      // Arrange
      final viewModel = CounterViewModel();
      
      // Act & Assert - ViewModel manages state over time
      expect(viewModel.count, 0);
      
      viewModel.increment();
      expect(viewModel.count, 1);
      
      viewModel.increment();
      expect(viewModel.count, 2);
      
      // Multiple reads return same value
      expect(viewModel.count, 2);
      expect(viewModel.count, 2);
    });

    test('should demonstrate multiple ViewModels independence', () {
      // Arrange - Multiple ViewModels for different UI components
      final userCounterVM = CounterViewModel();
      final systemCounterVM = CounterViewModel();
      
      // Act - Different user interactions
      userCounterVM.increment();
      userCounterVM.increment();
      
      systemCounterVM.increment();
      
      // Assert - Each ViewModel maintains independent state
      expect(userCounterVM.count, 2);
      expect(systemCounterVM.count, 1);
    });

    test('should show MVVM testability advantage', () {
      // This test demonstrates why MVVM is great for testing:
      // We can test business logic (ViewModel) without any UI!
      
      // Arrange
      final viewModel = CounterViewModel();
      
      // Act - Test business logic
      for (int i = 0; i < 5; i++) {
        viewModel.increment();
      }
      
      // Assert - Business logic works correctly
      expect(viewModel.count, 5);
      
      // No UI needed! This is the power of MVVM separation.
    });
  });
}