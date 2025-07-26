import 'package:test/test.dart';
import 'package:foobar_indexeddb/foobar.dart';
import 'package:foobar_indexeddb/foobar_crud.dart';
import 'package:foobar_indexeddb/foobar_utility.dart';

void main() {
  group('FooBar Model Tests', () {
    test('should create FooBar instance', () {
      // Arrange & Act
      final foobar = FooBar(foo: 'test', bar: 123);
      
      // Assert
      expect(foobar.foo, equals('test'));
      expect(foobar.bar, equals(123));
      expect(foobar.id, isNull);
    });
    
    test('should create FooBar with ID', () {
      // Arrange & Act
      final foobar = FooBar(id: '1', foo: 'test', bar: 123);
      
      // Assert
      expect(foobar.id, equals('1'));
      expect(foobar.foo, equals('test'));
      expect(foobar.bar, equals(123));
    });
    
    test('should convert to JSON', () {
      // Arrange
      final foobar = FooBar(id: '1', foo: 'test', bar: 123);
      
      // Act
      final json = foobar.toJson();
      
      // Assert
      expect(json['id'], equals('1'));
      expect(json['foo'], equals('test'));
      expect(json['bar'], equals(123));
    });
    
    test('should convert to JSON without ID', () {
      // Arrange
      final foobar = FooBar(id: '1', foo: 'test', bar: 123);
      
      // Act
      final json = foobar.toJsonWithoutId();
      
      // Assert
      expect(json.containsKey('id'), isFalse);
      expect(json['foo'], equals('test'));
      expect(json['bar'], equals(123));
    });
    
    test('should create from JSON', () {
      // Arrange
      final json = {'id': '1', 'foo': 'test', 'bar': 123};
      
      // Act
      final foobar = FooBar.fromJson(json);
      
      // Assert
      expect(foobar.id, equals('1'));
      expect(foobar.foo, equals('test'));
      expect(foobar.bar, equals(123));
    });
    
    test('should handle equality', () {
      // Arrange
      final foobar1 = FooBar(id: '1', foo: 'test', bar: 123);
      final foobar2 = FooBar(id: '1', foo: 'test', bar: 123);
      final foobar3 = FooBar(id: '2', foo: 'test', bar: 123);
      
      // Assert
      expect(foobar1, equals(foobar2));
      expect(foobar1, isNot(equals(foobar3)));
    });
  });

  // Note: CRUD and Utility tests would require a browser environment
  // and IndexedDB access, so they should be tested in integration tests
  // or with proper mocking of the IndexedDB API
  
  group('FooBarCrudService Structure Tests', () {
    test('should create service instance', () {
      // Arrange & Act
      final service = FooBarCrudService();
      
      // Assert
      expect(service, isNotNull);
    });
  });
  
  group('FooBarUtility Structure Tests', () {
    test('should create utility instance', () {
      // Arrange
      final crudService = FooBarCrudService();
      
      // Act
      final utility = FooBarUtility(crudService);
      
      // Assert
      expect(utility, isNotNull);
    });
  });
}
