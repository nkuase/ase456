import 'package:test/test.dart';
import '../lib/foobar.dart';

// Unit Tests
void main() {
  group('FooBar Constructor Tests', () {
    test('should create FooBar with required parameters', () {
      // Arrange & Act
      final fooBar = FooBar(foo: 'hello', bar: 42);

      // Assert
      expect(fooBar.foo, equals('hello'));
      expect(fooBar.bar, equals(42));
    });

    test('should create FooBar with different values', () {
      // Arrange & Act
      final fooBar = FooBar(foo: 'world', bar: -100);

      // Assert
      expect(fooBar.foo, equals('world'));
      expect(fooBar.bar, equals(-100));
    });
  });

  group('FooBar JSON Serialization Tests', () {
    test('should convert FooBar to JSON correctly', () {
      // Arrange
      final fooBar = FooBar(foo: 'test', bar: 123);
      final expectedJson = {'foo': 'test', 'bar': 123};

      // Act
      final result = fooBar.toJson();

      // Assert
      expect(result, equals(expectedJson));
      expect(result['foo'], isA<String>());
      expect(result['bar'], isA<int>());
    });

    test('should create FooBar from valid JSON', () {
      // Arrange
      final json = {'foo': 'from_json', 'bar': 999};
      final expectedFooBar = FooBar(foo: 'from_json', bar: 999);

      // Act
      final result = FooBar.fromJson(json);

      // Assert
      expect(result, equals(expectedFooBar));
      expect(result.foo, equals('from_json'));
      expect(result.bar, equals(999));
    });

    test('should handle empty string in JSON', () {
      // Arrange
      final json = {'foo': '', 'bar': 0};

      // Act
      final result = FooBar.fromJson(json);

      // Assert
      expect(result.foo, equals(''));
      expect(result.bar, equals(0));
    });
  });

  group('FooBar JSON Roundtrip Tests', () {
    test('should maintain data integrity in JSON roundtrip', () {
      // Arrange
      final original = FooBar(foo: 'roundtrip', bar: 456);

      // Act
      final json = original.toJson();
      final restored = FooBar.fromJson(json);

      // Assert
      expect(restored, equals(original));
      expect(restored.foo, equals(original.foo));
      expect(restored.bar, equals(original.bar));
    });

    test('should handle multiple roundtrips', () {
      // Arrange
      final original = FooBar(foo: 'multiple', bar: 789);

      // Act - Multiple conversions
      final json1 = original.toJson();
      final temp1 = FooBar.fromJson(json1);
      final json2 = temp1.toJson();
      final final_result = FooBar.fromJson(json2);

      // Assert
      expect(final_result, equals(original));
    });
  });

  group('FooBar Edge Cases', () {
    test('should handle negative numbers', () {
      // Arrange & Act
      final fooBar = FooBar(foo: 'negative', bar: -9999);

      // Assert
      expect(fooBar.bar, equals(-9999));
      expect(fooBar.bar, isNegative);
    });

    test('should handle special characters in string', () {
      // Arrange & Act
      final fooBar = FooBar(foo: 'hello@#%^&*()', bar: 1);

      // Assert
      expect(fooBar.foo, equals('hello@#%^&*()'));
    });

    test('should throw when JSON has wrong types', () {
      // Arrange
      final invalidJson = {'foo': 123, 'bar': 'not_a_number'};

      // Act & Assert
      expect(() => FooBar.fromJson(invalidJson), throwsA(isA<TypeError>()));
    });

    test('should throw when JSON is missing required fields', () {
      // Arrange
      final incompleteJson = {'foo': 'only_foo'};

      // Act & Assert
      expect(() => FooBar.fromJson(incompleteJson), throwsA(isA<TypeError>()));
    });
  });
}

// To run these tests, add this to your pubspec.yaml:
// dev_dependencies:
//   test: ^1.21.0
//
// Then run: dart test
