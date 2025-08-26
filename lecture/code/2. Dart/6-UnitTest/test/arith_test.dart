import 'package:test/test.dart';
import '../lib/arith.dart';

void main() {
  group('Arith Class Tests', () {
    late Arith arith;

    setUp(() {
      // Create a fresh instance before each test
      arith = Arith();
    });

    group('Addition Tests', () {
      test('should add two positive numbers correctly', () {
        // Arrange
        int a = 5;
        int b = 3;

        // Act
        int result = arith.add(a, b);

        // Assert
        expect(result, equals(8));
      });

      test('should add positive and negative numbers correctly', () {
        // Arrange
        int a = 10;
        int b = -3;

        // Act
        int result = arith.add(a, b);

        // Assert
        expect(result, equals(7));
      });

      test('should add two negative numbers correctly', () {
        // Arrange
        int a = -5;
        int b = -3;

        // Act
        int result = arith.add(a, b);

        // Assert
        expect(result, equals(-8));
      });

      test('should add zero correctly', () {
        // Arrange
        int a = 5;
        int b = 0;

        // Act
        int result = arith.add(a, b);

        // Assert
        expect(result, equals(5));
      });
    });

    group('Subtraction Tests', () {
      test('should subtract two positive numbers correctly', () {
        // Arrange
        int a = 10;
        int b = 3;

        // Act
        int result = arith.subtract(a, b);

        // Assert
        expect(result, equals(7));
      });

      test('should subtract negative number correctly', () {
        // Arrange
        int a = 5;
        int b = -3;

        // Act
        int result = arith.subtract(a, b);

        // Assert
        expect(result, equals(8));
      });

      test('should handle result being negative', () {
        // Arrange
        int a = 3;
        int b = 10;

        // Act
        int result = arith.subtract(a, b);

        // Assert
        expect(result, equals(-7));
      });

      test('should subtract zero correctly', () {
        // Arrange
        int a = 5;
        int b = 0;

        // Act
        int result = arith.subtract(a, b);

        // Assert
        expect(result, equals(5));
      });
    });

    group('Multiplication Tests', () {
      test('should multiply two positive numbers correctly', () {
        // Arrange
        int a = 4;
        int b = 3;

        // Act
        int result = arith.multiply(a, b);

        // Assert
        expect(result, equals(12));
      });

      test('should multiply positive and negative numbers correctly', () {
        // Arrange
        int a = 4;
        int b = -3;

        // Act
        int result = arith.multiply(a, b);

        // Assert
        expect(result, equals(-12));
      });

      test('should multiply two negative numbers correctly', () {
        // Arrange
        int a = -4;
        int b = -3;

        // Act
        int result = arith.multiply(a, b);

        // Assert
        expect(result, equals(12));
      });

      test('should multiply by zero correctly', () {
        // Arrange
        int a = 5;
        int b = 0;

        // Act
        int result = arith.multiply(a, b);

        // Assert
        expect(result, equals(0));
      });

      test('should multiply by one correctly', () {
        // Arrange
        int a = 7;
        int b = 1;

        // Act
        int result = arith.multiply(a, b);

        // Assert
        expect(result, equals(7));
      });
    });

    group('Division Tests', () {
      test('should divide two positive numbers correctly', () {
        // Arrange
        int a = 10;
        int b = 2;

        // Act
        double result = arith.divide(a, b);

        // Assert
        expect(result, equals(5.0));
      });

      test('should divide positive and negative numbers correctly', () {
        // Arrange
        int a = 10;
        int b = -2;

        // Act
        double result = arith.divide(a, b);

        // Assert
        expect(result, equals(-5.0));
      });

      test('should divide two negative numbers correctly', () {
        // Arrange
        int a = -10;
        int b = -2;

        // Act
        double result = arith.divide(a, b);

        // Assert
        expect(result, equals(5.0));
      });

      test('should handle decimal results correctly', () {
        // Arrange
        int a = 10;
        int b = 3;

        // Act
        double result = arith.divide(a, b);

        // Assert
        expect(result, closeTo(3.333, 0.001));
      });

      test('should divide zero by number correctly', () {
        // Arrange
        int a = 0;
        int b = 5;

        // Act
        double result = arith.divide(a, b);

        // Assert
        expect(result, equals(0.0));
      });

      test('should throw ArgumentError when dividing by zero', () {
        // Arrange
        int a = 10;
        int b = 0;

        // Act & Assert
        expect(
          () => arith.divide(a, b),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError with correct message when dividing by zero', () {
        // Arrange
        int a = 10;
        int b = 0;

        // Act & Assert
        expect(
          () => arith.divide(a, b),
          throwsA(
            predicate((e) => e is ArgumentError && e.message == 'Cannot divide by zero'),
          ),
        );
      });
    });

    group('Integration Tests', () {
      test('should perform multiple operations correctly', () {
        // Test: (5 + 3) * 2 - 4 = 12
        int step1 = arith.add(5, 3);        // 8
        int step2 = arith.multiply(step1, 2); // 16
        int step3 = arith.subtract(step2, 4); // 12

        expect(step3, equals(12));
      });

      test('should handle complex calculation with division', () {
        // Test: (10 + 5) / 3 = 5.0
        int step1 = arith.add(10, 5);        // 15
        double step2 = arith.divide(step1, 3); // 5.0

        expect(step2, equals(5.0));
      });
    });
  });
}
