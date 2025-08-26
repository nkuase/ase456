// Higher-Order Functions: map() and where()
// Examples from "Higher-Order Functions with Lambda Expressions" lecture

void main() {
  print('=== MAP() AND WHERE() FUNCTIONS ===\n');

  mapFunctionExample();
  whereFunctionExample();
  mapAndWhereExample();
}

// ============================================
// 1. MAP() FUNCTION - TRANSFORM EVERYTHING
// ============================================
class Text {
  final String content;
  Text(this.content);

  String toString() => 'Text("$content")';
}

void mapFunctionExample() {
  List<int> numbers = [1, 2, 3, 4, 5];
  List<int> doubled = numbers.map((x) => x * 2).toList();
  print(doubled); // [2, 4, 6, 8, 10]

  List<String> items = ['Apple', 'Banana', 'Orange'];
  var texts = items.map((item) => Text('Hello $item')).toList();
  print(texts);

  List<String> prices = ['10', '20', '30'];
  List<double> values = prices.map((price) => double.parse(price)).toList();
  print(prices); // ['10', '20', '30']
  print(values); // [10.0, 20.0, 30.0]
}

// ============================================
// 2. WHERE() FUNCTION - FILTER YOUR DATA
// ============================================

void whereFunctionExample() {
  print('\n--- where() Function: Filter Your Data ---');

  List<int> numbers = [1, 2, 3, 4, 5, 6];
  List<int> evenNumbers = numbers.where((x) => x % 2 == 0).toList();
  print(evenNumbers); // [2, 4, 6]

  List<String> words = ['apple', 'banana', 'cat', 'dog'];
  List<String> longWords = words.where((word) => word.length > 3).toList();
  print(longWords); // ['apple', 'banana']
}

// ============================================
// 3. COMBINING MAP() AND WHERE()
// ============================================

void mapAndWhereExample() {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8];

  // Get even numbers, then double them
  List<int> result = numbers
      .where((x) => x % 2 == 0) // Filter: [2, 4, 6, 8]
      .map((x) => x * 2) // Transform: [4, 8, 12, 16]
      .toList();
  print(result); // [4, 8, 12, 16]
}
