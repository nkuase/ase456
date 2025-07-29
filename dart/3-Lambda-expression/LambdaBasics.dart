// Lambda Expression Basics
// Examples from "Lambda Expressions in Dart" lecture

void main() {
  print('=== LAMBDA EXPRESSIONS IN DART ===\n');
  
  demonstrateBasicLambdas();
  demonstrateFunctionsAsVariables();
  demonstrateStepByStepProgression();
  demonstrateCommonLambdaPatterns();
}

// ============================================
// 1. BASIC LAMBDA SYNTAX DEMONSTRATION
// ============================================

void demonstrateBasicLambdas() {
  print('--- Basic Lambda Syntax ---');
  
  // Basic lambda syntax examples
  
  // Single expression with arrow notation
  var add = (int a, int b) => a + b;
  var multiply = (int a, int b) => a * b;
  var greet = (String name) => "Hello, \$name!";
  
  // Multi-line lambda with block notation
  var complexCalculation = (int x, int y) {
    var result = x * x + y * y;
    var sqrt = result * 0.5; // Simple approximation
    return sqrt;
  };
  
  // No parameters
  var getCurrentTime = () => DateTime.now().toString();
  
  // Single parameter (parentheses optional)
  var square = (int x) => x * x;
  var squareShort = (x) => x * x; // Type inferred
  
  print('add(3, 4): ${add(3, 4)}');
  print('multiply(3, 4): ${multiply(3, 4)}');
  print('greet("Alice"): ${greet("Alice")}');
  print('complexCalculation(3, 4): ${complexCalculation(3, 4)}');
  print('getCurrentTime(): ${getCurrentTime()}');
  print('square(5): ${square(5)}');
  print('squareShort(6): ${squareShort(6)}');
}

// ============================================
// 2. FUNCTIONS AS VARIABLES
// ============================================

void demonstrateFunctionsAsVariables() {
  print('\n--- Functions as Variables ---');
  
  // Store different functions in variables
  var add = (int a, int b) => a + b;
  var subtract = (int a, int b) => a - b;
  var multiply = (int a, int b) => a * b;
  var divide = (double a, double b) => a / b;
  
  // Use them like any variable
  print('add(10, 5): ${add(10, 5)}');
  print('subtract(10, 5): ${subtract(10, 5)}');
  print('multiply(10, 5): ${multiply(10, 5)}');
  print('divide(10.0, 5.0): ${divide(10.0, 5.0)}');
  
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
}

// ============================================
// 3. STEP-BY-STEP PROGRESSION
// ============================================

void demonstrateStepByStepProgression() {
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
// 4. COMMON LAMBDA PATTERNS
// ============================================

void demonstrateCommonLambdaPatterns() {
  print('\n--- Common Lambda Patterns ---');
  
  // Pattern 1: Simple transformations
  var double = (int x) => x * 2;
  var isEven = (int x) => x % 2 == 0;
  var makeGreeting = (String name) => "Welcome, \$name!";
  var toUpperCase = (String text) => text.toUpperCase();
  
  print('double(5): ${double(5)}');
  print('isEven(4): ${isEven(4)}');
  print('isEven(5): ${isEven(5)}');
  print('makeGreeting("Bob"): ${makeGreeting("Bob")}');
  print('toUpperCase("hello"): ${toUpperCase("hello")}');
  
  // Pattern 2: Conditional logic
  var getGrade = (int score) => score >= 90 ? 'A' : 
                               score >= 80 ? 'B' : 
                               score >= 70 ? 'C' : 
                               score >= 60 ? 'D' : 'F';
                               
  print('getGrade(95): ${getGrade(95)}');
  print('getGrade(75): ${getGrade(75)}');
  print('getGrade(55): ${getGrade(55)}');
  
  // Pattern 3: Working with objects
  var getFullName = (Map<String, String> person) => 
      '\${person["first"]} \${person["last"]}';
      
  var person = {"first": "John", "last": "Doe"};
  print('getFullName(person): ${getFullName(person)}');
  
  // Pattern 4: Multiple parameters
  var calculateArea = (double width, double height) => width * height;
  var formatPrice = (double price, String currency) => '\$currency\${price.toStringAsFixed(2)}';
  var combineStrings = (String a, String b, String separator) => '\$a\$separator\$b';
  
  print('calculateArea(5.5, 3.2): ${calculateArea(5.5, 3.2)}');
  print('formatPrice(29.99, "\$"): ${formatPrice(29.99, "\$")}');
  print('combineStrings("Hello", "World", " "): ${combineStrings("Hello", "World", " ")}');
  
  // Pattern 5: No parameters
  var getCurrentDateTime = () => DateTime.now();
  var generateRandomNumber = () => (DateTime.now().millisecondsSinceEpoch % 100);
  var getWelcomeMessage = () => "Welcome to our application!";
  
  print('getCurrentDateTime(): ${getCurrentDateTime()}');
  print('generateRandomNumber(): ${generateRandomNumber()}');
  print('getWelcomeMessage(): ${getWelcomeMessage()}');
}
