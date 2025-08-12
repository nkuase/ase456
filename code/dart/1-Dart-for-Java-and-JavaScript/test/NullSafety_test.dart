import 'package:test/test.dart';
import '../lib/NullSafety.dart';

void main() {
  group('Null Safety Examples', () {
    test('nullSafetyExample should handle null values correctly', () {
      // Test that null safety example runs without errors
      expect(() => nullSafetyExample(), prints(contains('Null Safety Examples')));
    });

    test('null coalescing operator should work correctly', () {
      // Test the null coalescing behavior
      String? nullableValue;
      String result = nullableValue ?? 'Default';
      expect(result, equals('Default'));
    });

    test('null aware assignment should work correctly', () {
      // Test null aware assignment
      String? value;
      value ??= 'Assigned Value';
      expect(value, equals('Assigned Value'));
      
      // Should not reassign if value is not null
      value ??= 'New Value';
      expect(value, equals('Assigned Value')); // Should still be the original
    });
  });
}
