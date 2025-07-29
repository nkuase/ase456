// ============================================
// 6. LAZY INITIALIZATION
// ============================================

String computeExpensive() {
  print('Computing expensive operation...');
  return 'Expensive Result';
}

String loadConfig() {
  print('Loading configuration...');
  return 'Config Data';
}

class LazyExample {
  late String expensiveValue = computeExpensive();
  late final String config = loadConfig();

  void accessValues() {
    print('Accessing expensiveValue: $expensiveValue');
    print('Accessing config: $config');
  }
}

void lazyInitializationExample() {
  print('\n=== Lazy Initialization Examples ===');

  var lazy = LazyExample(); // No computation yet
  print('LazyExample created');

  lazy.accessValues(); // Now the computations happen
}

void main() {
  print('=== LAZY INITIALIZATION EXAMPLES ===\n');
  lazyInitializationExample();
}
