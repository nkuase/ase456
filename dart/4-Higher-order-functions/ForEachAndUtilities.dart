// forEach vs map and Utility Functions
// Examples from "Higher-Order Functions with Lambda Expressions" lecture

void main() {
  print('=== FOREACH VS MAP AND UTILITY FUNCTIONS ===\n');
  
  demonstrateForEachFunction();
  demonstrateForEachVsMap();
  demonstrateTestingFunctions();
  demonstrateSubsetFunctions();
  demonstratePerformanceConsiderations();
  demonstrateUtilityPatterns();
}

// ============================================
// 1. FOREACH() FUNCTION - DO SOMETHING WITH EACH ITEM
// ============================================

void demonstrateForEachFunction() {
  print('--- forEach() Function: Execute Actions ---');
  
  // Basic forEach examples
  print('Basic forEach operations:');
  
  List<String> names = ['Alice', 'Bob', 'Charlie'];
  
  // Simple printing
  print('Greeting each person:');
  names.forEach((name) => print('  Hello, \$name!'));
  
  // More complex operations
  print('\nMore complex forEach operations:');
  
  List<int> numbers = [1, 2, 3, 4, 5];
  var results = <String>[];
  
  numbers.forEach((num) {
    var squared = num * num;
    var description = '\$num squared is \$squared';
    results.add(description);
    print('  \$description');
  });
  
  // forEach with objects
  print('\nforEach with objects:');
  
  var products = [
    {'name': 'Laptop', 'price': 999.99, 'stock': 5},
    {'name': 'Mouse', 'price': 29.99, 'stock': 0},
    {'name': 'Keyboard', 'price': 79.99, 'stock': 10},
  ];
  
  products.forEach((product) {
    var name = product['name'];
    var price = product['price'];
    var stock = product['stock'];
    var status = stock > 0 ? 'In Stock' : 'Out of Stock';
    print('  \$name: \\\$\$price - \$status');
  });
  
  // Side effects with forEach
  print('\nSide effects example:');
  
  var log = <String>[];
  var counter = 0;
  
  ['task1', 'task2', 'task3'].forEach((task) {
    counter++;
    log.add('Processed \$task at step \$counter');
    print('  Executing \$task...');
  });
  
  print('Final counter: \$counter');
  print('Log entries: \${log.length}');
}

// ============================================
// 2. FOREACH VS MAP COMPARISON
// ============================================

void demonstrateForEachVsMap() {
  print('\n--- forEach vs map Comparison ---');
  
  // Key differences explanation
  print('Key differences:');
  print('• forEach: Execute side effects, returns void');
  print('• map: Transform data, returns new Iterable');
  print('• Use forEach when you want to DO something');
  print('• Use map when you want to GET something');
  
  List<int> numbers = [1, 2, 3, 4];
  
  // WRONG usage - trying to collect values with forEach
  print('\n❌ WRONG: Using forEach to collect values');
  List<int> doubledWrong = [];
  numbers.forEach((num) {
    doubledWrong.add(num * 2);  // Side effect - awkward
  });
  print('Doubled (forEach): \$doubledWrong');
  
  // RIGHT usage - using map to transform
  print('\n✅ RIGHT: Using map to transform');
  List<int> doubledRight = numbers.map((num) => num * 2).toList();
  print('Doubled (map): \$doubledRight');
  
  // RIGHT usage - forEach for side effects
  print('\n✅ RIGHT: Using forEach for side effects');
  numbers.forEach((num) {
    print('  Processing number: \$num');     // Logging
    // Could also: send to API, update database, etc.
  });
  
  // Performance comparison
  print('\nPerformance & Memory considerations:');
  
  var largeList = List.generate(1000, (i) => i);
  
  // forEach - no new collection creation
  print('forEach: Lower memory usage, faster for side effects only');
  var start = DateTime.now();
  largeList.forEach((num) {
    // Just iterate, no collection creation
  });
  var forEachTime = DateTime.now().difference(start);
  
  // map - creates new iterable (lazy evaluation)
  print('map: Creates new iterable, optimized for transformations');
  start = DateTime.now();
  var mapped = largeList.map((num) => num * 2);
  var mapTime = DateTime.now().difference(start);
  // Note: map is lazy, so actual computation happens on toList()
  
  print('forEach time: \${forEachTime.inMicroseconds}μs');
  print('map creation time: \${mapTime.inMicroseconds}μs');
  print('(map is lazy - computation happens when consumed)');
  
  // Method chaining comparison
  print('\nMethod chaining:');
  
  // forEach requires multiple steps
  print('forEach approach (multiple steps):');
  List<int> temp1 = [];
  largeList.take(10).forEach((item) => temp1.add(item));
  List<int> temp2 = temp1.where((value) => value > 5).toList();
  List<int> result1 = temp2.map((value) => value * 2).toList();
  print('Result: \${result1.take(5).toList()}...');
  
  // map supports elegant chaining
  print('\nmap approach (elegant chaining):');
  List<int> result2 = largeList
      .take(10)
      .where((value) => value > 5)
      .map((value) => value * 2)
      .toList();
  print('Result: \${result2.take(5).toList()}...');
  
  // Lazy evaluation demonstration
  print('\nLazy evaluation with map:');
  
  print('Creating map (no execution yet):');
  Iterable<int> lazyMapped = numbers.map((n) {
    print('    Processing \$n'); // This won't print yet
    return n * 2;
  });
  
  print('Map created, now converting to list:');
  List<int> actualResult = lazyMapped.toList(); // Now it executes
  print('Final result: \$actualResult');
}

// ============================================
// 3. TESTING FUNCTIONS: ANY() AND EVERY()
// ============================================

void demonstrateTestingFunctions() {
  print('\n--- Testing Functions: any() and every() ---');
  
  // any() - Check if at least one item matches
  print('any() - Check if at least one item matches:');
  
  List<int> numbers = [1, 3, 5, 7, 8];
  bool hasEven = numbers.any((x) => x % 2 == 0);
  print('Numbers: \$numbers');
  print('Has even number: \$hasEven'); // true (because of 8)
  
  bool hasNegative = numbers.any((x) => x < 0);
  print('Has negative number: \$hasNegative'); // false
  
  bool hasLarge = numbers.any((x) => x > 10);
  print('Has number > 10: \$hasLarge'); // false
  
  // every() - Check if all items match
  print('\nevery() - Check if all items match:');
  
  List<int> ages = [18, 25, 30, 35];
  bool allAdults = ages.every((age) => age >= 18);
  print('Ages: \$ages');
  print('All adults (≥18): \$allAdults'); // true
  
  bool allSeniors = ages.every((age) => age >= 65);
  print('All seniors (≥65): \$allSeniors'); // false
  
  // String testing examples
  print('\nString testing examples:');
  
  List<String> emails = ['alice@example.com', 'bob@test.org', 'charlie@email.net'];
  bool allValidEmails = emails.every((email) => email.contains('@'));
  print('Emails: \$emails');
  print('All valid emails: \$allValidEmails'); // true
  
  List<String> mixedEmails = ['alice@example.com', 'invalid-email', 'charlie@email.net'];
  bool allValidMixed = mixedEmails.every((email) => email.contains('@'));
  print('Mixed emails: \$mixedEmails');
  print('All valid (mixed): \$allValidMixed'); // false
  
  bool anyValidMixed = mixedEmails.any((email) => email.contains('@'));
  print('Any valid (mixed): \$anyValidMixed'); // true
  
  // Complex object testing
  print('\nComplex object testing:');
  
  var students = [
    {'name': 'Alice', 'grade': 85, 'attendance': 95},
    {'name': 'Bob', 'grade': 92, 'attendance': 88},
    {'name': 'Charlie', 'grade': 78, 'attendance': 92},
  ];
  
  bool anyHighGrade = students.any((student) => (student['grade'] as int) >= 90);
  print('Any student with grade ≥90: \$anyHighGrade'); // true
  
  bool allPassing = students.every((student) => (student['grade'] as int) >= 70);
  print('All students passing (≥70): \$allPassing'); // true
  
  bool allPerfectAttendance = students.every((student) => (student['attendance'] as int) >= 95);
  print('All perfect attendance (≥95): \$allPerfectAttendance'); // false
  
  // Practical validation scenarios
  print('\nPractical validation:');
  
  var formData = {
    'username': 'john_doe',
    'email': 'john@example.com',
    'password': 'securepass123',
    'age': '25',
  };
  
  var requiredFields = ['username', 'email', 'password'];
  bool allFieldsPresent = requiredFields.every((field) => 
    formData.containsKey(field) && (formData[field]?.isNotEmpty ?? false));
  print('All required fields present: \$allFieldsPresent');
  
  var emailFields = ['email'];
  bool hasValidEmail = emailFields.every((field) => 
    formData[field]?.contains('@') ?? false);
  print('Valid email format: \$hasValidEmail');
}

// ============================================
// 4. SUBSET FUNCTIONS: TAKE(), SKIP(), TAKEWHILE()
// ============================================

void demonstrateSubsetFunctions() {
  print('\n--- Subset Functions: take(), skip(), takeWhile() ---');
  
  // take() - Get first N items
  print('take() - Get first N items:');
  
  List<String> fruits = ['Apple', 'Banana', 'Orange', 'Grape', 'Mango', 'Kiwi'];
  List<String> firstThree = fruits.take(3).toList();
  print('All fruits: \$fruits');
  print('First 3 fruits: \$firstThree');
  
  List<String> firstOne = fruits.take(1).toList();
  print('First 1 fruit: \$firstOne');
  
  // skip() - Skip first N items
  print('\nskip() - Skip first N items:');
  
  List<String> remaining = fruits.skip(2).toList();
  print('Skip first 2: \$remaining');
  
  List<String> lastTwo = fruits.skip(fruits.length - 2).toList();
  print('Last 2 fruits: \$lastTwo');
  
  // takeWhile() - Take items while condition is true
  print('\ntakeWhile() - Take items while condition is true:');
  
  List<int> numbers = [1, 2, 3, 4, 5, 1, 2];
  List<int> ascending = numbers.takeWhile((x) => x <= 3).toList();
  print('Numbers: \$numbers');
  print('Take while ≤3: \$ascending'); // [1, 2, 3] (stops at first 4)
  
  List<String> words = ['cat', 'dog', 'elephant', 'ant', 'butterfly'];
  List<String> shortWords = words.takeWhile((word) => word.length <= 3).toList();
  print('Words: \$words');
  print('Take while length ≤3: \$shortWords'); // ['cat', 'dog'] (stops at elephant)
  
  // skipWhile() - Skip items while condition is true
  print('\nskipWhile() - Skip items while condition is true:');
  
  List<int> scores = [45, 55, 65, 85, 95, 75];
  List<int> passingScores = scores.skipWhile((score) => score < 70).toList();
  print('Scores: \$scores');
  print('Skip while <70: \$passingScores'); // [85, 95, 75] (starts from 85)
  
  // Practical pagination example
  print('\nPractical pagination example:');
  
  List<String> allItems = List.generate(20, (i) => 'Item \${i + 1}');
  int pageSize = 5;
  int currentPage = 2; // 0-based: page 2 means third page
  
  List<String> pageItems = allItems
      .skip(currentPage * pageSize)
      .take(pageSize)
      .toList();
  
  print('All items count: \${allItems.length}');
  print('Page \${currentPage + 1} (items \${currentPage * pageSize + 1}-\${(currentPage + 1) * pageSize}): \$pageItems');
  
  // Combining subset functions
  print('\nCombining subset functions:');
  
  List<int> sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
  // Get middle section: skip first 3, take next 4
  List<int> middle = sequence.skip(3).take(4).toList();
  print('Original: \$sequence');
  print('Middle section (skip 3, take 4): \$middle'); // [4, 5, 6, 7]
  
  // Take first 7, then skip first 2 of those
  List<int> complex = sequence.take(7).skip(2).toList();
  print('Take 7, then skip 2: \$complex'); // [3, 4, 5, 6, 7]
  
  // Real-world: Recent items excluding the very latest
  var timestamps = List.generate(10, (i) => DateTime.now().subtract(Duration(hours: i)));
  var recentButNotLatest = timestamps.skip(1).take(5).toList();
  print('Recent timestamps (excluding latest): \${recentButNotLatest.length} items');
}

// ============================================
// 5. PERFORMANCE CONSIDERATIONS
// ============================================

void demonstratePerformanceConsiderations() {
  print('\n--- Performance Considerations ---');
  
  // Lazy evaluation benefits
  print('Lazy evaluation benefits:');
  
  var largeList = List.generate(1000000, (i) => i);
  
  // This is efficient - lazy evaluation
  print('Creating lazy transformations...');
  var lazyChain = largeList
      .where((x) => x % 2 == 0)
      .map((x) => x * 2)
      .take(5); // Only process what's needed
  
  print('Converting to list (only processes 5 items):');
  var result = lazyChain.toList();
  print('Result: \$result');
  
  // Method chaining efficiency
  print('\nMethod chaining efficiency:');
  
  var data = List.generate(100, (i) => i);
  
  // Efficient chaining
  var efficientResult = data
      .where((x) => x > 50)
      .take(10)
      .map((x) => x * 2)
      .toList();
  print('Efficient chain result: \$efficientResult');
  
  // Memory usage patterns
  print('\nMemory usage patterns:');
  
  // forEach - no intermediate collections
  print('forEach: No intermediate collections created');
  var count = 0;
  data.forEach((item) {
    if (item > 50) count++;
  });
  print('Count using forEach: \$count');
  
  // Functional approach - creates intermediate iterables (but lazy)
  print('Functional: Creates lazy iterables, minimal memory impact');
  var functionalCount = data
      .where((item) => item > 50)
      .length;
  print('Count using functional: \$functionalCount');
}

// ============================================
// 6. UTILITY PATTERNS
// ============================================

void demonstrateUtilityPatterns() {
  print('\n--- Common Utility Patterns ---');
  
  // Pattern 1: Validation pipeline
  print('Pattern 1: Validation pipeline');
  
  var userData = [
    {'email': 'alice@example.com', 'age': 25, 'name': 'Alice'},
    {'email': 'invalid-email', 'age': 17, 'name': ''},
    {'email': 'bob@test.com', 'age': 30, 'name': 'Bob'},
    {'email': 'charlie@email.org', 'age': 22, 'name': 'Charlie'},
  ];
  
  var validUsers = userData.where((user) {
    // All validations must pass
    return (user['email'] as String).contains('@') &&
           (user['age'] as int) >= 18 &&
           (user['name'] as String).isNotEmpty;
  }).toList();
  
  print('Valid users: \${validUsers.length}/\${userData.length}');
  validUsers.forEach((user) => print('  \${user['name']} (\${user['email']})'));
  
  // Pattern 2: Data processing pipeline
  print('\nPattern 2: Data processing pipeline');
  
  var salesData = [
    {'product': 'Laptop', 'quantity': 2, 'price': 999.99, 'discount': 0.1},
    {'product': 'Mouse', 'quantity': 5, 'price': 29.99, 'discount': 0.0},
    {'product': 'Monitor', 'quantity': 1, 'price': 299.99, 'discount': 0.15},
    {'product': 'Keyboard', 'quantity': 3, 'price': 79.99, 'discount': 0.05},
  ];
  
  var processedSales = salesData.map((sale) {
    var baseTotal = (sale['quantity'] as int) * (sale['price'] as double);
    var discountAmount = baseTotal * (sale['discount'] as double);
    var finalTotal = baseTotal - discountAmount;
    
    return {
      'product': sale['product'],
      'total': finalTotal,
      'savings': discountAmount,
    };
  }).toList();
  
  print('Processed sales:');
  processedSales.forEach((sale) {
    print('  \${sale['product']}: \\\$\${(sale['total'] as double).toStringAsFixed(2)} (saved: \\\$\${(sale['savings'] as double).toStringAsFixed(2)})');
  });
  
  var totalRevenue = processedSales.fold(0.0, (total, sale) => total + (sale['total'] as double));
  print('Total revenue: \\\$\${totalRevenue.toStringAsFixed(2)}');
  
  // Pattern 3: Conditional processing
  print('\nPattern 3: Conditional processing');
  
  var inventory = [
    {'item': 'Widget A', 'stock': 0, 'price': 10.0, 'category': 'tools'},
    {'item': 'Widget B', 'stock': 5, 'price': 15.0, 'category': 'tools'},
    {'item': 'Gadget X', 'stock': 2, 'price': 25.0, 'category': 'electronics'},
    {'item': 'Gadget Y', 'stock': 0, 'price': 30.0, 'category': 'electronics'},
  ];
  
  // Generate different reports based on conditions
  var inStockItems = inventory.where((item) => (item['stock'] as int) > 0);
  var outOfStockItems = inventory.where((item) => (item['stock'] as int) == 0);
  var expensiveItems = inventory.where((item) => (item['price'] as double) > 20.0);
  
  print('In stock: \${inStockItems.map((i) => i['item']).join(', ')}');
  print('Out of stock: \${outOfStockItems.map((i) => i['item']).join(', ')}');
  print('Expensive (>20): \${expensiveItems.map((i) => i['item']).join(', ')}');
  
  // Pattern 4: Grouping and summarizing
  print('\nPattern 4: Category analysis');
  
  var categories = inventory.map((item) => item['category'] as String).toSet();
  
  for (var category in categories) {
    var categoryItems = inventory.where((item) => item['category'] == category);
    var itemCount = categoryItems.length;
    var inStockCount = categoryItems.where((item) => (item['stock'] as int) > 0).length;
    var avgPrice = categoryItems.fold(0.0, (sum, item) => sum + (item['price'] as double)) / itemCount;
    
    print('\$category: \$inStockCount/\$itemCount in stock, avg price: \\\$\${avgPrice.toStringAsFixed(2)}');
  }
}
