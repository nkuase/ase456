// Passing Functions as Arguments
// Examples from "Lambda Expressions in Dart" lecture

void main() {
  print('=== PASSING FUNCTIONS AS ARGUMENTS ===\n');
  functionAsArgument();
  functionAsReturnValue();
}

// ============================================
// FUNCTIONS AS ARGUMENTS OR RETURN VALUES
// ============================================

void functionAsArgument() {
  print('\n--- Functions as Arguments ---');

  // Function that takes another function as an argument
  int operatorSelector(Function func, int a, int b) {
    return func(a, b);
  }

  var result = operatorSelector((x, y) => x + y, 10, 20);
  print('Result of operatorSelector 1: $result');
  var result2 = operatorSelector((x, y) => x * y, 10, 20);
  print('Result of operatorSelector 2: $result2');

  int add(int x, int y) => x + y;
  Function add2 = (int x, int y) => x + y;

  var result3 = operatorSelector(add, 10, 20);
  print('Result of operatorSelector 3: $result3');
  var result4 = operatorSelector(add2, 10, 20);
  print('Result of operatorSelector 4: $result4');
}

void functionAsReturnValue() {
  print('\n--- Functions as Return Values ---');

  // Function that returns another function as an argument
  Function returnFunction(String func) {
    // Return a function based on the input string
    if (func == 'add') {
      return (a, b) => a + b;
    } else if (func == 'multiply') {
      return (a, b) => a * b;
    } else {
      throw Exception('Unknown function type');
    }
  }

  var addFunction = returnFunction('add');
  print('Result of addFunction: ${addFunction(10, 20)}');
  var multiplyFunction = returnFunction('multiply');
  print('Result of multiplyFunction: ${multiplyFunction(10, 20)}');
}
