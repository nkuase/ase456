// Lambda Expression Basics
// Examples from "Lambda Expressions in Dart" lecture

void main() {
  print('=== LAMBDA EXPRESSIONS IN DART ===\n');

  whyLambdaExpressions();
  stepByStepExample();
  simpleLambdaExamples();
}

// ============================================
// WHY USE LAMBDA EXPRESSIONS?
// ============================================

void whyLambdaExpressions() {
  print('--- Why Use Lambda Expressions? ---');
  print(
    'Lambda expressions allow for concise function definitions, '
    'especially useful for short functions or when passing functions as arguments.',
  );
  List<String> names = ["Bob", "Alice", "Charlie"];
  names.sort((a, b) => a.length.compareTo(b.length));
  print(names);
}

// ============================================
// STEP-BY-STEP PROGRESSION
// ============================================

void stepByStepExample() {
  print('\n--- Step-by-Step Progression: Regular Function to Lambda ---');

  // Step 1: Regular function
  print('Step 1: Regular function');
  int regularSquare(int x) {
    return x * x;
  }

  print('regularSquare(5): ${regularSquare(5)}');

  // Step 2: Same function as lambda (arrow notation)
  print('\nStep 2: Same function as lambda');
  var lambdaSquare = (int x) => x * x;
  print('lambdaSquare(5): ${lambdaSquare(5)}');
  print('lambdaSquare: ${lambdaSquare}');

  // Step 3: Using the lambda in different ways
  print('\nStep 3: Using lambda in different contexts');

  // Direct call
  print('Direct call: ${((int x) => x * x)(5)}');

  // Stored in variable
  var storedSquare = (int x) => x * x;
  print('Stored in variable: ${storedSquare(5)}');

  // Passed to higher-order function
  var numbers = [1, 2, 3, 4, 5];
  var squared = numbers.map((x) => x * x).toList();
  print('Applied to list: \$squared');
}

// ============================================
// 2. SIMPLE LAMBDA EXAMPLES
// ============================================

void simpleLambdaExamples() {
  print('\n--- Common Lambda Patterns ---');

  // Multiple simple lambda expressions
  print('--- Multiple Simple Lambda Expressions ---');
  var getCurrentDateTime = () => DateTime.now();
  var doubleIt = (int x) => x * 2;
  var isEven = (int x) => x % 2 == 0;
  var makeGreeting = (String name) => "Welcome, \$name!";
  var toUpperCase = (String text) => text.toUpperCase();
  var calculateArea = (double width, double height) => width * height;
  var getFullName = (Map<String, String> person) =>
      '\${person["first"]} \${person["last"]}';

  print('getCurrentDateTime(): ${getCurrentDateTime()}');
  print('double(5): ${doubleIt(5)}');
  print('isEven(4): ${isEven(4)}');
  print('isEven(5): ${isEven(5)}');
  print('makeGreeting("Bob"): ${makeGreeting("Bob")}');
  print('toUpperCase("hello"): ${toUpperCase("hello")}');
  print('calculateArea(5.5, 3.2): ${calculateArea(5.5, 3.2)}');
  var person = {"first": "John", "last": "Doe"};
  print('getFullName(person): ${getFullName(person)}');

  // Functions as variables
  print('\n--- Functions as Variables ---');

  // Store different functions in variables
  var add = (int a, int b) => a + b;
  var subtract = (int a, int b) => a - b;
  var multiply = (int a, int b) => a * b;

  // Store functions in a list!
  var operations = [add, subtract, multiply];
  print('operations[0](8, 3): ${operations[0](8, 3)}'); // add
  print('operations[1](8, 3): ${operations[1](8, 3)}'); // subtract
  print('operations[2](8, 3): ${operations[2](8, 3)}'); // multiply

  // Store functions in a map
  var calculator = {
    'add': (int a, int b) => a + b,
    'subtract': (int a, int b) => a - b,
    'multiply': (int a, int b) => a * b,
  };

  print('calculator["add"](7, 2): ${calculator["add"]!(7, 2)}');
  print('calculator["multiply"](7, 2): ${calculator["multiply"]!(7, 2)}');

  // Conditional logic
  var getGrade = (int score) => score >= 90
      ? 'A'
      : score >= 80
      ? 'B'
      : score >= 70
      ? 'C'
      : score >= 60
      ? 'D'
      : 'F';

  print('getGrade(95): ${getGrade(95)}');
  print('getGrade(75): ${getGrade(75)}');
  print('getGrade(55): ${getGrade(55)}');
}
