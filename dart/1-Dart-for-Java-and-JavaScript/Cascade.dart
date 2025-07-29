// Dart Examples from "Dart for Java and JavaScript programmers" lecture

// ============================================
// 1. CASCADE OPERATOR EXAMPLES
// ============================================

void cascadeExample() {
  // Create a list and add elements using cascade notation
  var list = <String>[]
    ..add("Hello")
    ..add("World")
    ..sort();
  print('Cascade List Example: $list'); // Output: [Hello, World]
}

class Paint {
  late String color;
  late double strokeWidth;
  late String style;

  @override
  String toString() {
    return 'Paint(color: $color, strokeWidth: $strokeWidth, style: $style)';
  }
}

void constructorExample() {
  var paint = Paint()
    ..color = "red"
    ..strokeWidth = 5.0
    ..style = "stroke";
  print('Cascade Constructor Example: $paint');
}

void main() {
  print('=== CASCADE OPERATOR EXAMPLES ===\n');
  cascadeExample();
  constructorExample();
}
