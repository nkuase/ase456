// test/models/counter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_minimal/models/counter.dart';

void main() {
  group('Counter Model Tests', () {
    test('should create counter with initial value', () {
      // Arrange & Act
      final counter = Counter(5);
      
      // Assert
      expect(counter.value, 5);
    });

    test('should create counter with zero value', () {
      // Arrange & Act
      final counter = Counter(0);
      
      // Assert
      expect(counter.value, 0);
    });

    test('should increment counter value', () {
      // Arrange
      final counter = Counter(3);
      
      // Act
      final newCounter = counter.increment();
      
      // Assert
      expect(newCounter.value, 4);
    });

    test('should not modify original counter (immutability)', () {
      // Arrange
      final originalCounter = Counter(10);
      
      // Act
      final newCounter = originalCounter.increment();
      
      // Assert
      expect(originalCounter.value, 10); // Original unchanged
      expect(newCounter.value, 11);      // New instance created
    });

    test('should handle multiple increments', () {
      // Arrange
      final counter = Counter(0);
      
      // Act
      final counter1 = counter.increment();
      final counter2 = counter1.increment();
      final counter3 = counter2.increment();
      
      // Assert
      expect(counter.value, 0);   // Original unchanged
      expect(counter1.value, 1);  // First increment
      expect(counter2.value, 2);  // Second increment
      expect(counter3.value, 3);  // Third increment
    });

    test('should increment from negative numbers', () {
      // Arrange
      final counter = Counter(-2);
      
      // Act
      final newCounter = counter.increment();
      
      // Assert
      expect(newCounter.value, -1);
    });
  });
}