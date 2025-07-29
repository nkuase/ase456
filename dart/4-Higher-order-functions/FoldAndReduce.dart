// Higher-Order Functions: fold(), reduce(), and Aggregation
// Examples from "Higher-Order Functions with Lambda Expressions" lecture

void main() {
  print('=== FOLD(), REDUCE(), AND AGGREGATION FUNCTIONS ===\n');
  
  demonstrateFoldFunction();
  demonstrateReduceFunction();
  demonstrateFoldVsReduce();
  demonstrateComplexAggregations();
  demonstrateRealWorldExamples();
}

// ============================================
// 1. FOLD() FUNCTION - COMBINE EVERYTHING
// ============================================

void demonstrateFoldFunction() {
  print('--- fold() Function: Combine Everything ---');
  
  // Basic fold examples
  print('Basic fold operations:');
  
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // Sum using fold
  int sum = numbers.fold(0, (total, current) => total + current);
  print('Numbers: \$numbers');
  print('Sum: \$sum');
  
  // Product using fold
  int product = numbers.fold(1, (total, current) => total * current);
  print('Product: \$product');
  
  // String concatenation
  print('\nString operations:');
  
  List<String> words = ['Hello', 'World', 'from', 'Dart'];
  String sentence = words.fold('', (result, word) => result + word + ' ');
  print('Words: \$words');
  print('Sentence: "\${sentence.trim()}"');
  
  // Join with custom separator
  String csvFormat = words.fold('', (result, word) {
    return result.isEmpty ? word : '\$result,\$word';
  });
  print('CSV format: \$csvFormat');
  
  // Complex folding with transformations
  print('\nComplex folding:');
  
  List<String> items = ['apple', 'banana', 'cherry'];
  String htmlList = items.fold('<ul>', (html, item) => 
    html + '<li>\$item</li>') + '</ul>';
  print('HTML list: \$htmlList');
  
  // Finding maximum using fold
  List<int> scores = [85, 92, 78, 96, 88];
  int maxScore = scores.fold(scores.first, (max, current) => 
    current > max ? current : max);
  print('Scores: \$scores');
  print('Maximum score: \$maxScore');
  
  // Finding minimum using fold
  int minScore = scores.fold(scores.first, (min, current) => 
    current < min ? current : min);
  print('Minimum score: \$minScore');
}

// ============================================
// 2. REDUCE() FUNCTION - SIMPLIFIED COMBINING
// ============================================

void demonstrateReduceFunction() {
  print('\n--- reduce() Function: Simplified Combining ---');
  
  // Basic reduce examples
  print('Basic reduce operations:');
  
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // Sum using reduce
  int sum = numbers.reduce((a, b) => a + b);
  print('Numbers: \$numbers');
  print('Sum (reduce): \$sum');
  
  // Product using reduce
  int product = numbers.reduce((a, b) => a * b);
  print('Product (reduce): \$product');
  
  // Find maximum
  int max = numbers.reduce((a, b) => a > b ? a : b);
  print('Maximum: \$max');
  
  // Find minimum  
  int min = numbers.reduce((a, b) => a < b ? a : b);
  print('Minimum: \$min');
  
  // String operations with reduce
  print('\nString reduce operations:');
  
  List<String> words = ['Dart', 'is', 'awesome'];
  String combined = words.reduce((a, b) => '\$a \$b');
  print('Words: \$words');
  print('Combined: "\$combined"');
  
  // Find longest string
  List<String> cities = ['Tokyo', 'San Francisco', 'Berlin', 'Mumbai'];
  String longestCity = cities.reduce((a, b) => a.length > b.length ? a : b);
  print('Cities: \$cities');
  print('Longest city name: \$longestCity');
  
  // Find shortest string
  String shortestCity = cities.reduce((a, b) => a.length < b.length ? a : b);
  print('Shortest city name: \$shortestCity');
}

// ============================================
// 3. FOLD VS REDUCE COMPARISON
// ============================================

void demonstrateFoldVsReduce() {
  print('\n--- fold() vs reduce() Comparison ---');
  
  print('Key differences:');
  print('• fold(): Takes initial value, can return different type');
  print('• reduce(): Uses first element as initial, same type only');
  
  List<int> numbers = [1, 2, 3, 4, 5];
  
  // Same operation, different approaches
  print('\nSame operations:');
  int sumFold = numbers.fold(0, (a, b) => a + b);
  int sumReduce = numbers.reduce((a, b) => a + b);
  print('Sum with fold: \$sumFold');
  print('Sum with reduce: \$sumReduce');
  
  // Different initial values with fold
  print('\nDifferent initial values:');
  int sumPlus100 = numbers.fold(100, (a, b) => a + b);
  print('Sum starting from 100: \$sumPlus100');
  
  // Type conversion with fold (not possible with reduce)
  print('\nType conversion (fold only):');
  String numberString = numbers.fold('Numbers:', (str, num) => '\$str \$num');
  print('Number string: \$numberString');
  
  // reduce would fail with empty list, fold handles it
  print('\nEmpty list handling:');
  List<int> emptyList = [];
  
  int foldEmpty = emptyList.fold(0, (a, b) => a + b);
  print('fold() with empty list: \$foldEmpty');
  
  // This would throw an error:
  // int reduceEmpty = emptyList.reduce((a, b) => a + b);
  print('reduce() with empty list: Would throw StateError!');
  
  // Single element handling
  List<int> singleElement = [42];
  int foldSingle = singleElement.fold(0, (a, b) => a + b);
  int reduceSingle = singleElement.reduce((a, b) => a + b);
  print('Single element - fold: \$foldSingle, reduce: \$reduceSingle');
}

// ============================================
// 4. COMPLEX AGGREGATIONS
// ============================================

class Transaction {
  String type;
  double amount;
  DateTime date;
  String category;
  
  Transaction(this.type, this.amount, this.date, this.category);
  
  @override
  String toString() => '\$type: \\\$\$amount (\$category)';
}

void demonstrateComplexAggregations() {
  print('\n--- Complex Aggregations ---');
  
  // Sample transaction data
  var transactions = [
    Transaction('income', 3000.0, DateTime(2024, 1, 1), 'salary'),
    Transaction('expense', 500.0, DateTime(2024, 1, 2), 'rent'),
    Transaction('expense', 100.0, DateTime(2024, 1, 3), 'groceries'),
    Transaction('income', 200.0, DateTime(2024, 1, 4), 'freelance'),
    Transaction('expense', 50.0, DateTime(2024, 1, 5), 'utilities'),
    Transaction('expense', 75.0, DateTime(2024, 1, 6), 'groceries'),
    Transaction('income', 150.0, DateTime(2024, 1, 7), 'refund'),
  ];
  
  print('Sample transactions:');
  transactions.forEach((t) => print('  \$t'));
  
  // Calculate net balance
  print('\nFinancial calculations:');
  double netBalance = transactions.fold(0.0, (balance, transaction) {
    return transaction.type == 'income' 
        ? balance + transaction.amount 
        : balance - transaction.amount;
  });
  print('Net balance: \\\$\${netBalance.toStringAsFixed(2)}');
  
  // Total income
  double totalIncome = transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (total, t) => total + t.amount);
  print('Total income: \\\$\${totalIncome.toStringAsFixed(2)}');
  
  // Total expenses
  double totalExpenses = transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (total, t) => total + t.amount);
  print('Total expenses: \\\$\${totalExpenses.toStringAsFixed(2)}');
  
  // Category breakdown
  print('\nCategory breakdown:');
  var categoryTotals = transactions
      .where((t) => t.type == 'expense')
      .fold<Map<String, double>>({}, (totals, transaction) {
        totals[transaction.category] = (totals[transaction.category] ?? 0) + transaction.amount;
        return totals;
      });
  
  categoryTotals.forEach((category, total) {
    print('  \$category: \\\$\${total.toStringAsFixed(2)}');
  });
  
  // Statistical analysis
  print('\nStatistical analysis:');
  
  var expenseAmounts = transactions
      .where((t) => t.type == 'expense')
      .map((t) => t.amount)
      .toList();
  
  if (expenseAmounts.isNotEmpty) {
    double avgExpense = expenseAmounts.fold(0.0, (sum, amount) => sum + amount) / expenseAmounts.length;
    double maxExpense = expenseAmounts.reduce((a, b) => a > b ? a : b);
    double minExpense = expenseAmounts.reduce((a, b) => a < b ? a : b);
    
    print('Average expense: \\\$\${avgExpense.toStringAsFixed(2)}');
    print('Largest expense: \\\$\${maxExpense.toStringAsFixed(2)}');
    print('Smallest expense: \\\$\${minExpense.toStringAsFixed(2)}');
  }
}

// ============================================
// 5. REAL-WORLD EXAMPLES
// ============================================

class Student {
  String name;
  Map<String, int> grades;
  
  Student(this.name, this.grades);
  
  double get gpa => grades.values.fold(0, (sum, grade) => sum + grade) / grades.length;
  
  @override
  String toString() => 'Student(name: \$name, GPA: \${gpa.toStringAsFixed(2)})';
}

class Product {
  String name;
  double price;
  int quantity;
  String category;
  
  Product(this.name, this.price, this.quantity, this.category);
  
  double get totalValue => price * quantity;
  
  @override
  String toString() => 'Product(name: \$name, price: \\\$\$price, qty: \$quantity)';
}

void demonstrateRealWorldExamples() {
  print('\n--- Real-World Examples ---');
  
  // Student grade analysis
  print('Student grade analysis:');
  
  var students = [
    Student('Alice', {'Math': 95, 'Science': 88, 'English': 92}),
    Student('Bob', {'Math': 78, 'Science': 85, 'English': 80}),
    Student('Charlie', {'Math': 92, 'Science': 94, 'English': 88}),
    Student('Diana', {'Math': 88, 'Science': 90, 'English': 95}),
  ];
  
  students.forEach((student) => print('  \$student'));
  
  // Class statistics
  double classAverage = students.fold(0.0, (sum, student) => sum + student.gpa) / students.length;
  print('Class average GPA: \${classAverage.toStringAsFixed(2)}');
  
  Student topStudent = students.reduce((a, b) => a.gpa > b.gpa ? a : b);
  print('Top student: \${topStudent.name} (GPA: \${topStudent.gpa.toStringAsFixed(2)})');
  
  // Subject analysis
  var subjects = ['Math', 'Science', 'English'];
  for (var subject in subjects) {
    var subjectGrades = students.map((s) => s.grades[subject]!).toList();
    double subjectAverage = subjectGrades.fold(0, (sum, grade) => sum + grade) / subjectGrades.length;
    int highestGrade = subjectGrades.reduce((a, b) => a > b ? a : b);
    print('\$subject - Average: \${subjectAverage.toStringAsFixed(1)}, Highest: \$highestGrade');
  }
  
  // Inventory management
  print('\nInventory management:');
  
  var inventory = [
    Product('Laptop', 999.99, 10, 'Electronics'),
    Product('Mouse', 29.99, 50, 'Electronics'),
    Product('Book', 19.99, 100, 'Education'),
    Product('Pen', 2.99, 200, 'Office'),
    Product('Monitor', 299.99, 15, 'Electronics'),
  ];
  
  inventory.forEach((product) => print('  \$product'));
  
  // Total inventory value
  double totalValue = inventory.fold(0.0, (total, product) => total + product.totalValue);
  print('Total inventory value: \\\$\${totalValue.toStringAsFixed(2)}');
  
  // Most valuable single product line
  Product mostValuable = inventory.reduce((a, b) => a.totalValue > b.totalValue ? a : b);
  print('Most valuable product line: \${mostValuable.name} (\\\$\${mostValuable.totalValue.toStringAsFixed(2)})');
  
  // Category analysis
  var electronics = inventory.where((p) => p.category == 'Electronics').toList();
  double electronicsValue = electronics.fold(0.0, (total, product) => total + product.totalValue);
  print('Electronics total value: \\\$\${electronicsValue.toStringAsFixed(2)}');
  
  // Average product price
  double avgPrice = inventory.fold(0.0, (sum, product) => sum + product.price) / inventory.length;
  print('Average product price: \\\$\${avgPrice.toStringAsFixed(2)}');
  
  // Text analysis example
  print('\nText analysis:');
  
  var sentences = [
    'Dart is a great programming language.',
    'It is used for Flutter development.',
    'Higher-order functions make code elegant.',
    'Functional programming is powerful.',
  ];
  
  // Word count
  int totalWords = sentences.fold(0, (count, sentence) => 
    count + sentence.split(' ').length);
  print('Total words in all sentences: \$totalWords');
  
  // Character count (excluding spaces)
  int totalChars = sentences.fold(0, (count, sentence) => 
    count + sentence.replaceAll(' ', '').length);
  print('Total characters (no spaces): \$totalChars');
  
  // Longest sentence
  String longestSentence = sentences.reduce((a, b) => a.length > b.length ? a : b);
  print('Longest sentence: "\$longestSentence"');
  
  // Combine all sentences
  String combined = sentences.fold('', (result, sentence) => 
    result.isEmpty ? sentence : '\$result \$sentence');
  print('All sentences combined: "\$combined"');
}
