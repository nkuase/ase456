// Higher-Order Functions: map() and where()
// Examples from "Higher-Order Functions with Lambda Expressions" lecture

void main() {
  print('=== MAP() AND WHERE() FUNCTIONS ===\n');
  
  demonstrateMapFunction();
  demonstrateWhereFunction();
  demonstrateCombiningMapAndWhere();
  demonstrateFlutterExamples();
  demonstrateRealWorldScenarios();
}

// ============================================
// 1. MAP() FUNCTION - TRANSFORM EVERYTHING
// ============================================

void demonstrateMapFunction() {
  print('--- map() Function: Transform Everything ---');
  
  // Basic transformation examples
  print('Basic transformations:');
  
  List<int> numbers = [1, 2, 3, 4, 5];
  List<int> doubled = numbers.map((x) => x * 2).toList();
  print('Original: \$numbers');
  print('Doubled: \$doubled');
  
  List<int> squared = numbers.map((x) => x * x).toList();
  print('Squared: \$squared');
  
  // String transformations
  print('\nString transformations:');
  
  List<String> names = ['alice', 'bob', 'charlie'];
  List<String> capitalized = names.map((name) => 
    name[0].toUpperCase() + name.substring(1)).toList();
  print('Original: \$names');
  print('Capitalized: \$capitalized');
  
  List<String> greetings = names.map((name) => 'Hello, \$name!').toList();
  print('Greetings: \$greetings');
  
  // Type conversion examples
  print('\nType conversions:');
  
  List<String> priceStrings = ['10.99', '25.50', '5.00', '100.25'];
  List<double> prices = priceStrings.map((price) => double.parse(price)).toList();
  print('Price strings: \$priceStrings');
  print('Price numbers: \$prices');
  
  List<String> formattedPrices = prices.map((price) => '\\\$\${price.toStringAsFixed(2)}').toList();
  print('Formatted prices: \$formattedPrices');
  
  // Working with objects
  print('\nWorking with objects:');
  
  var people = [
    {'name': 'Alice', 'age': 30},
    {'name': 'Bob', 'age': 25},
    {'name': 'Charlie', 'age': 35},
  ];
  
  List<String> personDescriptions = people.map((person) => 
    '\${person['name']} is \${person['age']} years old').toList();
  print('Person descriptions: \$personDescriptions');
  
  List<String> justNames = people.map((person) => person['name'] as String).toList();
  print('Just names: \$justNames');
}

// ============================================
// 2. WHERE() FUNCTION - FILTER YOUR DATA
// ============================================

void demonstrateWhereFunction() {
  print('\n--- where() Function: Filter Your Data ---');
  
  // Basic filtering examples
  print('Basic filtering:');
  
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> evenNumbers = numbers.where((x) => x % 2 == 0).toList();
  print('All numbers: \$numbers');
  print('Even numbers: \$evenNumbers');
  
  List<int> largeNumbers = numbers.where((x) => x > 5).toList();
  print('Numbers > 5: \$largeNumbers');
  
  List<int> specificRange = numbers.where((x) => x >= 3 && x <= 7).toList();
  print('Numbers 3-7: \$specificRange');
  
  // String filtering
  print('\nString filtering:');
  
  List<String> words = ['apple', 'banana', 'cat', 'dog', 'elephant', 'fish'];
  List<String> longWords = words.where((word) => word.length > 3).toList();
  print('All words: \$words');
  print('Long words (>3 chars): \$longWords');
  
  List<String> wordsWithA = words.where((word) => word.contains('a')).toList();
  print('Words containing "a": \$wordsWithA');
  
  List<String> startsWithVowel = words.where((word) => 
    'aeiou'.contains(word[0].toLowerCase())).toList();
  print('Words starting with vowels: \$startsWithVowel');
  
  // Complex filtering with objects
  print('\nComplex filtering:');
  
  var products = [
    {'name': 'Laptop', 'price': 999.99, 'category': 'Electronics'},
    {'name': 'Book', 'price': 12.99, 'category': 'Education'},
    {'name': 'Phone', 'price': 599.99, 'category': 'Electronics'},
    {'name': 'Pen', 'price': 2.99, 'category': 'Office'},
    {'name': 'Tablet', 'price': 299.99, 'category': 'Electronics'},
  ];
  
  var expensiveProducts = products.where((product) => 
    (product['price'] as double) > 100).toList();
  print('Expensive products (>100):');
  expensiveProducts.forEach((product) => print('  \${product['name']}: \\\$\${product['price']}'));
  
  var electronics = products.where((product) => 
    product['category'] == 'Electronics').toList();
  print('Electronics:');
  electronics.forEach((product) => print('  \${product['name']}'));
  
  var affordableElectronics = products.where((product) => 
    product['category'] == 'Electronics' && (product['price'] as double) < 700).toList();
  print('Affordable electronics (<700):');
  affordableElectronics.forEach((product) => print('  \${product['name']}: \\\$\${product['price']}'));
}

// ============================================
// 3. COMBINING MAP() AND WHERE()
// ============================================

void demonstrateCombiningMapAndWhere() {
  print('\n--- Combining map() and where() ---');
  
  // Example from lecture: Filter then Transform
  print('Filter then Transform:');
  
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8];
  
  // Get even numbers, then double them
  List<int> result = numbers
      .where((x) => x % 2 == 0)    // Filter: [2, 4, 6, 8]
      .map((x) => x * 2)           // Transform: [4, 8, 12, 16]
      .toList();
  
  print('Original: \$numbers');
  print('Even numbers doubled: \$result');
  
  // Transform then Filter
  print('\nTransform then Filter:');
  
  List<int> doubled = numbers
      .map((x) => x * 2)           // Transform: [2, 4, 6, 8, 10, 12, 14, 16]
      .where((x) => x > 10)        // Filter: [12, 14, 16]
      .toList();
  
  print('Doubled then > 10: \$doubled');
  
  // Complex chaining with real data
  print('\nComplex chaining example:');
  
  var employees = [
    {'name': 'Alice', 'department': 'Engineering', 'salary': 75000, 'experience': 5},
    {'name': 'Bob', 'department': 'Marketing', 'salary': 55000, 'experience': 3},
    {'name': 'Charlie', 'department': 'Engineering', 'salary': 95000, 'experience': 8},
    {'name': 'Diana', 'department': 'Sales', 'salary': 65000, 'experience': 4},
    {'name': 'Eve', 'department': 'Engineering', 'salary': 85000, 'experience': 6},
  ];
  
  // Get senior engineers (experience > 5) with formatted salary info
  var seniorEngineers = employees
      .where((emp) => emp['department'] == 'Engineering')
      .where((emp) => (emp['experience'] as int) > 5)
      .map((emp) => '\${emp['name']}: \\\$\${emp['salary']} (\${emp['experience']} years)')
      .toList();
      
  print('Senior Engineers (>5 years experience):');
  seniorEngineers.forEach((info) => print('  \$info'));
  
  // Calculate total salary of marketing and sales employees
  var marketingSalesTotal = employees
      .where((emp) => emp['department'] == 'Marketing' || emp['department'] == 'Sales')
      .map((emp) => emp['salary'] as int)
      .fold(0, (total, salary) => total + salary);
      
  print('Total salary for Marketing & Sales: \\\$\$marketingSalesTotal');
}

// ============================================
// 4. FLUTTER EXAMPLES (SIMULATED)
// ============================================

// Simulated Flutter widgets
class Widget {
  final String description;
  Widget(this.description);
  @override
  String toString() => description;
}

class Text extends Widget {
  Text(String text) : super('Text("\$text")');
}

class ListTile extends Widget {
  ListTile({required String title, String? subtitle}) 
    : super('ListTile(title: "\$title"\${subtitle != null ? ', subtitle: "\$subtitle"' : ''})');
}

class Card extends Widget {
  final Widget child;
  Card({required this.child}) : super('Card(child: \$child)');
}

class Column extends Widget {
  final List<Widget> children;
  Column({required this.children}) : super('Column(children: [\$children])');
}

void demonstrateFlutterExamples() {
  print('\n--- Flutter Examples (Simulated) ---');
  
  // Example from lecture: Creating List of Cards
  print('Creating list of cards:');
  
  List<String> fruits = ['Apple', 'Banana', 'Orange', 'Grape'];
  
  var fruitCards = fruits.map((fruit) => Card(
    child: ListTile(
      title: fruit,
      subtitle: 'Fresh \$fruit available',
    ),
  )).toList();
  
  print('Fruit cards:');
  fruitCards.forEach((card) => print('  \$card'));
  
  // Search/Filter example
  print('\nSearch functionality:');
  
  List<String> allFruits = ['Apple', 'Banana', 'Orange', 'Apricot', 'Avocado', 'Blueberry'];
  String searchQuery = 'a';
  
  List<String> filteredFruits = allFruits
      .where((fruit) => fruit.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();
      
  var searchResults = filteredFruits.map((fruit) => ListTile(title: fruit)).toList();
  
  print('Search results for "\$searchQuery":');
  searchResults.forEach((tile) => print('  \$tile'));
  
  // Dynamic content generation
  print('\nDynamic content generation:');
  
  var menuItems = [
    {'title': 'Home', 'icon': 'home', 'enabled': true},
    {'title': 'Profile', 'icon': 'person', 'enabled': true},
    {'title': 'Settings', 'icon': 'settings', 'enabled': false},
    {'title': 'Admin', 'icon': 'admin', 'enabled': false},
  ];
  
  var enabledMenuItems = menuItems
      .where((item) => item['enabled'] as bool)
      .map((item) => ListTile(
        title: item['title'] as String,
        subtitle: 'Icon: \${item['icon']}',
      ))
      .toList();
      
  print('Enabled menu items:');
  enabledMenuItems.forEach((item) => print('  \$item'));
}

// ============================================
// 5. REAL-WORLD SCENARIOS
// ============================================

class Product {
  String name;
  double price;
  String category;
  int stock;
  double rating;
  
  Product(this.name, this.price, this.category, this.stock, this.rating);
  
  @override
  String toString() => 'Product(name: \$name, price: \\\$\$price, category: \$category, stock: \$stock, rating: \$rating)';
}

void demonstrateRealWorldScenarios() {
  print('\n--- Real-World Scenarios ---');
  
  var products = [
    Product('MacBook Pro', 1999.99, 'Laptops', 5, 4.8),
    Product('Dell XPS', 1299.99, 'Laptops', 8, 4.5),
    Product('iPhone 13', 799.99, 'Phones', 12, 4.7),
    Product('Samsung Galaxy', 699.99, 'Phones', 15, 4.4),
    Product('iPad Air', 599.99, 'Tablets', 10, 4.6),
    Product('Surface Pro', 899.99, 'Tablets', 3, 4.3),
    Product('AirPods', 179.99, 'Accessories', 25, 4.9),
    Product('Kindle', 89.99, 'eReaders', 20, 4.2),
  ];
  
  // E-commerce scenarios
  print('E-commerce filtering examples:');
  
  // High-rated products under \$1000
  var affordableQualityProducts = products
      .where((p) => p.price < 1000 && p.rating >= 4.5)
      .map((p) => '\${p.name} - \\\$\${p.price} (⭐ \${p.rating})')
      .toList();
  
  print('Affordable quality products (<\$1000, rating ≥4.5):');
  affordableQualityProducts.forEach((product) => print('  \$product'));
  
  // Low stock alerts
  var lowStockProducts = products
      .where((p) => p.stock < 10)
      .map((p) => '\${p.name}: \${p.stock} units remaining')
      .toList();
  
  print('\nLow stock alerts (<10 units):');
  lowStockProducts.forEach((alert) => print('  🚨 \$alert'));
  
  // Category analysis
  print('\nCategory analysis:');
  
  var categories = products.map((p) => p.category).toSet().toList();
  
  for (var category in categories) {
    var categoryProducts = products.where((p) => p.category == category).toList();
    var avgPrice = categoryProducts
        .map((p) => p.price)
        .fold(0.0, (sum, price) => sum + price) / categoryProducts.length;
    var avgRating = categoryProducts
        .map((p) => p.rating)
        .fold(0.0, (sum, rating) => sum + rating) / categoryProducts.length;
        
    print('\$category: \${categoryProducts.length} products, avg price: \\\$\${avgPrice.toStringAsFixed(2)}, avg rating: \${avgRating.toStringAsFixed(1)}');
  }
  
  // Premium product recommendations
  var premiumProducts = products
      .where((p) => p.price > 500 && p.rating >= 4.5 && p.stock > 0)
      .map((p) => {
        'name': p.name,
        'category': p.category,
        'value_score': p.rating / (p.price / 1000), // rating per \$1000
      })
      .toList()
      ..sort((a, b) => (b['value_score'] as double).compareTo(a['value_score'] as double));
  
  print('\nPremium product recommendations (best value):');
  premiumProducts.take(3).forEach((product) {
    print('  \${product['name']} (\${product['category']}) - Value score: \${(product['value_score'] as double).toStringAsFixed(2)}');
  });
}
