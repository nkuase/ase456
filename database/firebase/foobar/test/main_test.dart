import 'package:test/test.dart';
import '../lib/main.dart' as app;
import '../lib/models/foobar.dart';

void main() {
  group('Main Application Tests', () {
    test('should generate random FooBar with valid data', () {
      // Act
      final randomFooBar = app.generateRandomFooBar();
      
      // Assert
      expect(randomFooBar, isA<FooBar>());
      expect(randomFooBar.foo, isNotEmpty);
      expect(randomFooBar.foo, isA<String>());
      expect(randomFooBar.bar, isA<int>());
      expect(randomFooBar.bar, greaterThan(0));
      expect(randomFooBar.bar, lessThanOrEqualTo(100));
      expect(randomFooBar.id, isNull); // New objects shouldn't have ID
    });

    test('should generate different random FooBars', () {
      // Act
      final foobar1 = app.generateRandomFooBar();
      final foobar2 = app.generateRandomFooBar();
      final foobar3 = app.generateRandomFooBar();
      
      // Assert - At least one should be different
      // (Very high probability with random generation)
      final allSame = foobar1.foo == foobar2.foo && 
                     foobar2.foo == foobar3.foo &&
                     foobar1.bar == foobar2.bar && 
                     foobar2.bar == foobar3.bar;
      
      expect(allSame, isFalse);
    });

    test('should generate FooBar with expected foo options', () {
      // Arrange
      final expectedFooOptions = ['abc', 'xyz', 'hello', 'world', 'dart', 'firebase'];
      final generatedFoos = <String>{};
      
      // Act - Generate many to test variety
      for (int i = 0; i < 50; i++) {
        final foobar = app.generateRandomFooBar();
        generatedFoos.add(foobar.foo);
      }
      
      // Assert - All generated foos should be from expected options
      for (final foo in generatedFoos) {
        expect(expectedFooOptions, contains(foo));
      }
      
      // Should have some variety (at least 2 different values)
      expect(generatedFoos.length, greaterThan(1));
    });

    test('should generate FooBar with bar in expected range', () {
      // Act - Generate many to test range
      final generatedBars = <int>[];
      for (int i = 0; i < 20; i++) {
        final foobar = app.generateRandomFooBar();
        generatedBars.add(foobar.bar);
      }
      
      // Assert - All bars should be in range 1-100
      for (final bar in generatedBars) {
        expect(bar, greaterThanOrEqualTo(1));
        expect(bar, lessThanOrEqualTo(100));
      }
      
      // Should have some variety
      expect(generatedBars.toSet().length, greaterThan(1));
    });
  });

  group('Application Integration Tests', () {
    test('main function should exist and be callable', () {
      // This test ensures the main function exists
      // In a full integration test, you would run the actual main
      expect(app.main, isA<Function>());
    });

    // Note: To test the actual main function, you would need:
    // 1. Mock Firebase connection
    // 2. Capture print output
    // 3. Test the full workflow
    // 
    // Example (commented out - would need proper mocking):
    /*
    test('main function should complete without errors (with mocked Firebase)', () async {
      // This would require mocking the Firebase service
      // await app.main();
      // expect(no exceptions thrown);
    });
    */
  });

  group('Random Data Generation Edge Cases', () {
    test('should handle multiple rapid generations', () {
      // Act - Generate many quickly
      final foobars = <FooBar>[];
      for (int i = 0; i < 100; i++) {
        foobars.add(app.generateRandomFooBar());
      }
      
      // Assert - All should be valid
      for (final foobar in foobars) {
        expect(foobar.foo, isNotEmpty);
        expect(foobar.bar, greaterThan(0));
        expect(foobar.bar, lessThanOrEqualTo(100));
      }
      
      // Should have variety in the results
      final uniqueFoos = foobars.map((f) => f.foo).toSet();
      final uniqueBars = foobars.map((f) => f.bar).toSet();
      
      expect(uniqueFoos.length, greaterThan(1));
      expect(uniqueBars.length, greaterThan(5)); // Should have variety in numbers
    });
  });
}
