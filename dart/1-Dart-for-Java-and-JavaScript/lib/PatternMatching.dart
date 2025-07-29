// Pattern Matching with Switch Expressions
// Example from "Dart for Java and JavaScript programmers" lecture

// Base class for shapes
abstract class Shape {}

class Circle extends Shape {
  final double radius;
  Circle({required this.radius});

  @override
  String toString() => 'Circle(radius: $radius)';
}

class Rectangle extends Shape {
  final double width;
  final double height;
  Rectangle({required this.width, required this.height});

  @override
  String toString() => 'Rectangle(width: $width, height: $height)';
}

class Square extends Shape {
  final double side;
  Square({required this.side});

  @override
  String toString() => 'Square(side: $side)';
}

class Triangle extends Shape {
  final double base;
  final double height;
  Triangle({required this.base, required this.height});

  @override
  String toString() => 'Triangle(base: $base, height: $height)';
}

// Pattern matching with switch expressions
double getArea(Shape shape) => switch (shape) {
  Circle(radius: var r) => r * r * 3.14159,
  Rectangle(width: var w, height: var h) => w * h,
  Square(side: var s) => s * s,
  Triangle(base: var b, height: var h) => 0.5 * b * h,
  Shape() => throw UnimplementedError(),
};

// Another example with more complex pattern matching
String getShapeDescription(Shape shape) => switch (shape) {
  Circle(radius: var r) when r > 10 => 'Large circle with radius $r',
  Circle(radius: var r) when r > 5 => 'Medium circle with radius $r',
  Circle(radius: var r) => 'Small circle with radius $r',
  Rectangle(width: var w, height: var h) when w == h =>
    'Square-like rectangle ${w}x$h',
  Rectangle(width: var w, height: var h) => 'Rectangle ${w}x$h',
  Square(side: var s) when s > 10 => 'Large square with side $s',
  Square(side: var s) => 'Square with side $s',
  Triangle() => 'Triangle shape',

  Shape() => throw UnimplementedError(),
};

// Pattern matching with numbers
String categorizeNumber(num value) => switch (value) {
  0 => 'Zero',
  1 => 'One',
  > 0 && < 10 => 'Small positive number',
  >= 10 && < 100 => 'Medium positive number',
  >= 100 => 'Large positive number',
  < 0 => 'Negative number',
  double() => 'Decimal number',
  _ => 'Unknown number type',
};

// Pattern matching with lists
String analyzeList(List<int> numbers) => switch (numbers) {
  [] => 'Empty list',
  [var single] => 'Single element: $single',
  [var first, var second] => 'Two elements: $first, $second',
  [var first, ...var rest] when rest.length > 5 =>
    'Long list starting with $first',
  [var first, ...var rest] =>
    'List of ${numbers.length} elements starting with $first and ending with ${rest.last}',
};

// Pattern matching with maps
String analyzeUser(Map<String, dynamic> user) => switch (user) {
  {'name': String name, 'age': int age} when age >= 18 => 'Adult: $name',
  {'name': String name, 'age': int age} => 'Minor: $name and age $age',
  {'name': String name} => 'User: $name (age unknown)',
  Map() => 'Empty user data',
};

void demonstratePatternMatching() {
  print('=== PATTERN MATCHING EXAMPLES ===\n');

  // Shape pattern matching
  print('--- Shape Area Calculations ---');
  var shapes = [
    Circle(radius: 5.0),
    Rectangle(width: 4.0, height: 6.0),
    Square(side: 3.0),
    Triangle(base: 8.0, height: 4.0),
  ];

  for (var shape in shapes) {
    var area = getArea(shape);
    var description = getShapeDescription(shape);
    print('$shape: Area = ${area.toStringAsFixed(2)}, $description');
  }

  // Number pattern matching
  print('\n--- Number Categorization ---');
  var numbers = [0, 1, 5, 25, 150, -10, 3.14];
  for (var num in numbers) {
    print('$num: ${categorizeNumber(num)}');
  }

  // List pattern matching
  print('\n--- List Analysis ---');
  var lists = [
    <int>[],
    [42],
    [1, 2],
    [1, 2, 3, 4, 5],
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  ];

  for (var list in lists) {
    print('$list: ${analyzeList(list)}');
  }

  // Map pattern matching
  print('\n--- User Data Analysis ---');
  var users = [
    {'name': 'Alice', 'age': 25},
    {'name': 'Bob', 'age': 16},
    {'name': 'Charlie'},
    <String, dynamic>{},
    {'age': 30}, // Missing name
  ];

  for (var user in users) {
    print('$user: ${analyzeUser(user)}');
  }
}

// ============================================
// 9. PATTERN MATCHING (IF CASE)
// ============================================
// User class for pattern matching examples
class User {
  final String name;
  final int age;
  final String email;

  User({required this.name, required this.age, this.email = ""});

  @override
  String toString() => 'User(name: $name, age: $age, email: $email)';
}

void patternMatchingExample() {
  print('\n=== Pattern Matching Examples ===');

  var user = User(name: "John", age: 25, email: "john@email.com");

  // Pattern matching in if statements
  if (user case User(name: var n, age: > 18)) {
    print('Adult user found: $n');
  }

  var youngUser = User(name: "Tommy", age: 16);
  if (youngUser case User(name: var n, age: > 18)) {
    print('Adult user found: $n');
  } else {
    print('User ${youngUser.name} is under 18');
  }
}

// ============================================
// MAIN FUNCTION
// ============================================

void main() async {
  print('=== DART EXAMPLES FROM LECTURE ===\n');
  demonstratePatternMatching();
  patternMatchingExample();
}
