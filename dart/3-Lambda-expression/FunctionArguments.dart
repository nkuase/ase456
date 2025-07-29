// Passing Functions as Arguments
// Examples from "Lambda Expressions in Dart" lecture

void main() {
  print('=== PASSING FUNCTIONS AS ARGUMENTS ===\n');
  
  demonstrateBasicFunctionPassing();
  demonstrateListSorting();
  demonstrateCustomHigherOrderFunctions();
  demonstrateRealWorldExamples();
}

// ============================================
// 1. BASIC FUNCTION PASSING
// ============================================

void demonstrateBasicFunctionPassing() {
  print('--- Basic Function Passing ---');
  
  // Simple function that takes another function as parameter
  void executeFunction(Function func) {
    print('About to execute function...');
    func();
    print('Function executed!');
  }
  
  // Different functions to pass
  var greetUser = () => print('Hello, User!');
  var showTime = () => print('Current time: ${DateTime.now()}');
  var doMath = () => print('2 + 2 = ${2 + 2}');
  
  executeFunction(greetUser);
  executeFunction(showTime);
  executeFunction(doMath);
  
  // Function that takes function with parameters
  void executeWithNumbers(int Function(int, int) operation, int a, int b) {
    var result = operation(a, b);
    print('Operation result: \$result');
  }
  
  var add = (int x, int y) => x + y;
  var multiply = (int x, int y) => x * y;
  var power = (int x, int y) {
    var result = 1;
    for (int i = 0; i < y; i++) {
      result *= x;
    }
    return result;
  };
  
  executeWithNumbers(add, 5, 3);
  executeWithNumbers(multiply, 5, 3);
  executeWithNumbers(power, 5, 3);
}

// ============================================
// 2. LIST SORTING EXAMPLES
// ============================================

void demonstrateListSorting() {
  print('\n--- List Sorting with Lambda Functions ---');
  
  // Example from lecture: Without Lambda (Verbose)
  print('Traditional approach (separate function):');
  
  int compareByLength(String a, String b) {
    return a.length.compareTo(b.length);
  }
  
  List<String> names1 = ["Bob", "Alice", "Charlie", "David"];
  names1.sort(compareByLength);
  print('Sorted by length (traditional): \$names1');
  
  // Example from lecture: With Lambda (Concise)
  print('\nLambda approach (inline):');
  
  List<String> names2 = ["Bob", "Alice", "Charlie", "David"];
  names2.sort((a, b) => a.length.compareTo(b.length));
  print('Sorted by length (lambda): \$names2');
  
  // More sorting examples
  print('\n--- More Sorting Examples ---');
  
  // Sort alphabetically
  List<String> names3 = ["Bob", "Alice", "Charlie", "David"];
  names3.sort((a, b) => a.compareTo(b));
  print('Sorted alphabetically: \$names3');
  
  // Sort reverse alphabetically
  List<String> names4 = ["Bob", "Alice", "Charlie", "David"];
  names4.sort((a, b) => b.compareTo(a));
  print('Sorted reverse alphabetically: \$names4');
  
  // Sort numbers
  List<int> numbers = [5, 2, 8, 1, 9, 3];
  numbers.sort((a, b) => a.compareTo(b));
  print('Numbers sorted ascending: \$numbers');
  
  List<int> numbers2 = [5, 2, 8, 1, 9, 3];
  numbers2.sort((a, b) => b.compareTo(a));
  print('Numbers sorted descending: \$numbers2');
  
  // Complex sorting: Sort by multiple criteria
  var people = [
    {'name': 'Alice', 'age': 30, 'salary': 50000},
    {'name': 'Bob', 'age': 25, 'salary': 60000},
    {'name': 'Charlie', 'age': 30, 'salary': 45000},
    {'name': 'Diana', 'age': 25, 'salary': 55000},
  ];
  
  // Sort by age, then by salary
  people.sort((a, b) {
    var ageComparison = a['age']!.compareTo(b['age']!);
    if (ageComparison != 0) return ageComparison;
    return a['salary']!.compareTo(b['salary']!);
  });
  
  print('People sorted by age, then salary:');
  for (var person in people) {
    print('  \${person['name']}: age \${person['age']}, salary \${person['salary']}');
  }
}

// ============================================
// 3. CUSTOM HIGHER-ORDER FUNCTIONS
// ============================================

void demonstrateCustomHigherOrderFunctions() {
  print('\n--- Custom Higher-Order Functions ---');
  
  // Function that applies an operation to two numbers
  double calculate(double a, double b, double Function(double, double) operation) {
    return operation(a, b);
  }
  
  var addition = (double x, double y) => x + y;
  var subtraction = (double x, double y) => x - y;
  var multiplication = (double x, double y) => x * y;
  var division = (double x, double y) => x / y;
  
  print('calculate(10, 5, addition): ${calculate(10, 5, addition)}');
  print('calculate(10, 5, subtraction): ${calculate(10, 5, subtraction)}');
  print('calculate(10, 5, multiplication): ${calculate(10, 5, multiplication)}');
  print('calculate(10, 5, division): ${calculate(10, 5, division)}');
  
  // Function that processes a list with custom logic
  List<T> processItems<T>(List<T> items, T Function(T) processor) {
    return items.map(processor).toList();
  }
  
  var numbers = [1, 2, 3, 4, 5];
  var doubler = (int x) => x * 2;
  var squarer = (int x) => x * x;
  
  print('Original numbers: \$numbers');
  print('Doubled: \${processItems(numbers, doubler)}');
  print('Squared: \${processItems(numbers, squarer)}');
  
  // Function that validates data with custom rules
  List<T> filterValid<T>(List<T> items, bool Function(T) validator) {
    return items.where(validator).toList();
  }
  
  var ages = [15, 18, 22, 16, 30, 12, 25];
  var isAdult = (int age) => age >= 18;
  var isTeenager = (int age) => age >= 13 && age <= 19;
  
  print('All ages: \$ages');
  print('Adults: \${filterValid(ages, isAdult)}');
  print('Teenagers: \${filterValid(ages, isTeenager)}');
}

// ============================================
// 4. REAL-WORLD EXAMPLES
// ============================================

class User {
  String name;
  int age;
  String email;
  
  User(this.name, this.age, this.email);
  
  @override
  String toString() => 'User(name: \$name, age: \$age, email: \$email)';
}

void demonstrateRealWorldExamples() {
  print('\n--- Real-World Examples ---');
  
  var users = [
    User('Alice', 30, 'alice@email.com'),
    User('Bob', 25, 'bob@email.com'),
    User('Charlie', 35, 'charlie@email.com'),
    User('Diana', 28, 'diana@email.com'),
  ];
  
  // Sort users by different criteria
  print('Original users:');
  users.forEach((user) => print('  \$user'));
  
  // Sort by name
  var usersByName = List<User>.from(users);
  usersByName.sort((a, b) => a.name.compareTo(b.name));
  print('\nSorted by name:');
  usersByName.forEach((user) => print('  \$user'));
  
  // Sort by age
  var usersByAge = List<User>.from(users);
  usersByAge.sort((a, b) => a.age.compareTo(b.age));
  print('\nSorted by age:');
  usersByAge.forEach((user) => print('  \$user'));
  
  // Custom validation examples
  void processUsers(List<User> users, bool Function(User) filter, String description) {
    var filtered = users.where(filter).toList();
    print('\n\$description:');
    if (filtered.isEmpty) {
      print('  No users found');
    } else {
      filtered.forEach((user) => print('  \$user'));
    }
  }
  
  processUsers(users, (user) => user.age >= 30, 'Users 30 or older');
  processUsers(users, (user) => user.name.startsWith('A'), 'Users whose name starts with A');
  processUsers(users, (user) => user.email.contains('gmail'), 'Gmail users');
  
  // Event simulation (like button clicks)
  void simulateEvents() {
    print('\n--- Event Simulation ---');
    
    void handleEvent(String eventName, void Function() handler) {
      print('Handling event: \$eventName');
      handler();
    }
    
    // Different event handlers
    var onButtonClick = () => print('  Button was clicked!');
    var onPageLoad = () => print('  Page loaded successfully!');
    var onUserLogin = () => print('  User logged in!');
    
    handleEvent('button_click', onButtonClick);
    handleEvent('page_load', onPageLoad);
    handleEvent('user_login', onUserLogin);
    
    // Event with parameters
    void handleEventWithData(String eventName, void Function(Map<String, dynamic>) handler) {
      var eventData = {
        'timestamp': DateTime.now().toString(),
        'eventId': eventName.hashCode,
      };
      handler(eventData);
    }
    
    var onDataReceived = (Map<String, dynamic> data) {
      print('  Data received: \$data');
    };
    
    handleEventWithData('data_received', onDataReceived);
  }
  
  simulateEvents();
}
