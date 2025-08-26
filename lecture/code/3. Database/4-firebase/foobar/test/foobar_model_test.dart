import 'package:test/test.dart';
import '../lib/models/foobar.dart';

void main() {
  group('FooBar Model Tests', () {
    test('should create FooBar with required fields', () {
      // Arrange & Act
      final foobar = FooBar(foo: 'test', bar: 42);
      
      // Assert
      expect(foobar.foo, equals('test'));
      expect(foobar.bar, equals(42));
      expect(foobar.id, isNull); // ID should be null for new objects
    });

    test('should create FooBar with ID', () {
      // Arrange & Act
      final foobar = FooBar(id: 'test123', foo: 'test', bar: 42);
      
      // Assert
      expect(foobar.id, equals('test123'));
      expect(foobar.foo, equals('test'));
      expect(foobar.bar, equals(42));
    });

    test('should convert FooBar to Map correctly', () {
      // Arrange
      final foobar = FooBar(id: 'test123', foo: 'hello', bar: 100);
      
      // Act
      final map = foobar.toMap();
      
      // Assert
      expect(map, isA<Map<String, dynamic>>());
      expect(map['foo'], equals('hello'));
      expect(map['bar'], equals(100));
      expect(map.containsKey('id'), isFalse); // ID should not be in map
    });

    test('should create FooBar from Map correctly', () {
      // Arrange
      final map = {
        'foo': 'world',
        'bar': 200,
      };
      
      // Act
      final foobar = FooBar.fromMap(map, 'doc123');
      
      // Assert
      expect(foobar.id, equals('doc123'));
      expect(foobar.foo, equals('world'));
      expect(foobar.bar, equals(200));
    });

    test('should handle missing fields in Map with defaults', () {
      // Arrange
      final emptyMap = <String, dynamic>{};
      
      // Act
      final foobar = FooBar.fromMap(emptyMap);
      
      // Assert
      expect(foobar.id, isNull);
      expect(foobar.foo, equals('')); // Default empty string
      expect(foobar.bar, equals(0));  // Default zero
    });

    test('should create copy with updated fields', () {
      // Arrange
      final original = FooBar(id: 'original', foo: 'old', bar: 10);
      
      // Act
      final copy = original.copyWith(foo: 'new', bar: 20);
      
      // Assert
      expect(copy.id, equals('original')); // Unchanged
      expect(copy.foo, equals('new'));     // Changed
      expect(copy.bar, equals(20));        // Changed
    });

    test('should create copy with partial updates', () {
      // Arrange
      final original = FooBar(id: 'test', foo: 'original', bar: 50);
      
      // Act
      final copy = original.copyWith(foo: 'updated');
      
      // Assert
      expect(copy.id, equals('test'));      // Unchanged
      expect(copy.foo, equals('updated'));  // Changed
      expect(copy.bar, equals(50));         // Unchanged
    });

    test('should have proper toString representation', () {
      // Arrange
      final foobar = FooBar(id: 'abc123', foo: 'test', bar: 99);
      
      // Act
      final stringRepresentation = foobar.toString();
      
      // Assert
      expect(stringRepresentation, contains('abc123'));
      expect(stringRepresentation, contains('test'));
      expect(stringRepresentation, contains('99'));
      expect(stringRepresentation, startsWith('FooBar{'));
    });

    test('should check equality correctly', () {
      // Arrange
      final foobar1 = FooBar(id: 'same', foo: 'test', bar: 42);
      final foobar2 = FooBar(id: 'same', foo: 'test', bar: 42);
      final foobar3 = FooBar(id: 'different', foo: 'test', bar: 42);
      
      // Act & Assert
      expect(foobar1 == foobar2, isTrue);  // Same values
      expect(foobar1 == foobar3, isFalse); // Different ID
      expect(foobar1 == foobar1, isTrue);  // Same instance
    });

    test('should have consistent hashCode', () {
      // Arrange
      final foobar1 = FooBar(id: 'test', foo: 'hello', bar: 42);
      final foobar2 = FooBar(id: 'test', foo: 'hello', bar: 42);
      
      // Act & Assert
      expect(foobar1.hashCode, equals(foobar2.hashCode));
    });

    test('should handle null ID in equality and hashCode', () {
      // Arrange
      final foobar1 = FooBar(foo: 'test', bar: 42);
      final foobar2 = FooBar(foo: 'test', bar: 42);
      final foobar3 = FooBar(foo: 'different', bar: 42);
      
      // Act & Assert
      expect(foobar1 == foobar2, isTrue);
      expect(foobar1 == foobar3, isFalse);
      expect(foobar1.hashCode, equals(foobar2.hashCode));
    });
  });

  group('FooBar Edge Cases', () {
    test('should handle empty string foo', () {
      // Arrange & Act
      final foobar = FooBar(foo: '', bar: 0);
      
      // Assert
      expect(foobar.foo, equals(''));
      expect(foobar.bar, equals(0));
    });

    test('should handle negative bar values', () {
      // Arrange & Act
      final foobar = FooBar(foo: 'negative', bar: -10);
      
      // Assert
      expect(foobar.foo, equals('negative'));
      expect(foobar.bar, equals(-10));
    });

    test('should handle very large bar values', () {
      // Arrange & Act
      final foobar = FooBar(foo: 'large', bar: 999999999);
      
      // Assert
      expect(foobar.foo, equals('large'));
      expect(foobar.bar, equals(999999999));
    });

    test('should handle special characters in foo', () {
      // Arrange & Act
      final foobar = FooBar(foo: '!@#\$%^&*()', bar: 1);
      
      // Assert
      expect(foobar.foo, equals('!@#\$%^&*()'));
      expect(foobar.bar, equals(1));
    });

    test('should handle Unicode characters in foo', () {
      // Arrange & Act
      final foobar = FooBar(foo: '안녕하세요 🌍', bar: 42);
      
      // Assert
      expect(foobar.foo, equals('안녕하세요 🌍'));
      expect(foobar.bar, equals(42));
    });
  });
}
