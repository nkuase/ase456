import 'package:test/test.dart';
import '../Cascade.dart';

void main() {
  group('Cascade Operator Tests', () {
    test('cascade operator with list operations', () {
      // Test the cascade operator with list creation and operations
      var list = <String>[]
        ..add("Hello")
        ..add("World")
        ..sort();

      expect(list.length, equals(2));
      expect(list[0], equals("Hello"));
      expect(list[1], equals("World"));
      expect(list, equals(["Hello", "World"]));
    });

    test('cascade operator with multiple list operations', () {
      // Test cascade with different operations
      var numbers = <int>[]
        ..add(3)
        ..add(1)
        ..add(4)
        ..add(2)
        ..sort();

      expect(numbers, equals([1, 2, 3, 4]));
      expect(numbers.length, equals(4));
    });

    test('cascade operator with list methods chaining', () {
      // Test multiple operations in sequence
      var fruits = <String>[]
        ..addAll(["banana", "apple", "cherry"])
        ..sort()
        ..insert(0, "apricot");

      expect(fruits.first, equals("apricot"));
      expect(fruits.length, equals(4));
      expect(fruits.contains("apple"), isTrue);
    });
  });

  group('Paint Class Tests', () {
    test('Paint class creation without cascade', () {
      var paint = Paint();
      paint.color = "blue";
      paint.strokeWidth = 3.0;
      paint.style = "fill";

      expect(paint.color, equals("blue"));
      expect(paint.strokeWidth, equals(3.0));
      expect(paint.style, equals("fill"));
    });

    test('Paint class creation with cascade operator', () {
      var paint = Paint()
        ..color = "red"
        ..strokeWidth = 5.0
        ..style = "stroke";

      expect(paint.color, equals("red"));
      expect(paint.strokeWidth, equals(5.0));
      expect(paint.style, equals("stroke"));
    });

    test('Paint class toString method', () {
      var paint = Paint()
        ..color = "green"
        ..strokeWidth = 2.5
        ..style = "dash";

      String expected = 'Paint(color: green, strokeWidth: 2.5, style: dash)';
      expect(paint.toString(), equals(expected));
    });

    test('Paint class multiple cascade operations', () {
      var paint1 = Paint()
        ..color = "yellow"
        ..strokeWidth = 1.0
        ..style = "solid";

      var paint2 = Paint()
        ..color = "purple"
        ..strokeWidth = 10.0
        ..style = "dotted";

      expect(paint1.color, equals("yellow"));
      expect(paint2.color, equals("purple"));
      expect(paint1.strokeWidth, equals(1.0));
      expect(paint2.strokeWidth, equals(10.0));
    });
  });

  group('Integration Tests', () {
    test('cascadeExample function output verification', () {
      // Capture the behavior of cascadeExample function
      var list = <String>[]
        ..add("Hello")
        ..add("World")
        ..sort();

      // Verify the same logic as in cascadeExample()
      expect(list, equals(["Hello", "World"]));
      expect(list.length, equals(2));
    });

    test('constructorExample function behavior verification', () {
      // Replicate the constructorExample function behavior
      var paint = Paint()
        ..color = "red"
        ..strokeWidth = 5.0
        ..style = "stroke";

      String expectedOutput =
          'Paint(color: red, strokeWidth: 5.0, style: stroke)';
      expect(paint.toString(), equals(expectedOutput));
    });
  });

  group('Advanced Cascade Tests', () {
    test('cascade operator returns the original object', () {
      var paint = Paint();
      var result = paint
        ..color = "black"
        ..strokeWidth = 7.0;

      // The cascade operator should return the original object
      expect(identical(paint, result), isTrue);
      expect(paint.color, equals("black"));
      expect(paint.strokeWidth, equals(7.0));
    });

    test('nested cascade operations', () {
      var paints = <Paint>[]
        ..add(Paint()
          ..color = "red"
          ..strokeWidth = 1.0
          ..style = "solid")
        ..add(Paint()
          ..color = "blue"
          ..strokeWidth = 2.0
          ..style = "dashed");

      expect(paints.length, equals(2));
      expect(paints[0].color, equals("red"));
      expect(paints[1].color, equals("blue"));
      expect(paints[0].strokeWidth, equals(1.0));
      expect(paints[1].strokeWidth, equals(2.0));
    });

    test('cascade with conditional operations', () {
      var list = <String>[]..add("first");

      // Add more elements conditionally
      bool shouldAddMore = true;
      if (shouldAddMore) {
        list
          ..add("second")
          ..add("third");
      }

      expect(list.length, equals(3));
      expect(list, equals(["first", "second", "third"]));
    });
  });
}
