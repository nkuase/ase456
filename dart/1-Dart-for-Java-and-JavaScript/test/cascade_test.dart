import 'package:test/test.dart';
import '../lib/Cascade.dart';

void main() {
  group('Cascade Operator Examples', () {
    test('cascadeExample should create and populate list correctly', () {
      // Capture printed output to verify the cascade operator worked
      expect(() => cascadeExample(), prints(contains('Cascade List Example: [Hello, World]')));
    });

    test('constructorExample should create Paint object with cascade', () {
      // Test that constructor example runs and creates Paint object correctly
      expect(() => constructorExample(), prints(contains('Paint(color: red, strokeWidth: 5.0, style: stroke)')));
    });

    test('Paint class should have correct toString implementation', () {
      // Test Paint class directly
      var paint = Paint()
        ..color = "blue"
        ..strokeWidth = 3.0
        ..style = "fill";
      
      expect(paint.toString(), equals('Paint(color: blue, strokeWidth: 3.0, style: fill)'));
    });

    test('cascade operator should work with list operations', () {
      // Test cascade operator functionality directly
      var testList = <String>[]
        ..add("First")
        ..add("Second")
        ..sort();
      
      expect(testList, equals(['First', 'Second']));
      expect(testList.length, equals(2));
    });

    test('cascade operator should work with object properties', () {
      // Test cascade with object property setting
      var paint = Paint();
      var result = paint
        ..color = "green"
        ..strokeWidth = 10.0
        ..style = "outline";
      
      // Should return the same object
      expect(identical(paint, result), isTrue);
      expect(paint.color, equals("green"));
      expect(paint.strokeWidth, equals(10.0));
      expect(paint.style, equals("outline"));
    });
  });
}
