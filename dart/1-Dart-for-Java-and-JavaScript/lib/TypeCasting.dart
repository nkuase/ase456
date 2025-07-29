// ============================================
// 8. TYPE CASTING EXAMPLES
// ============================================

void dynamicTypeExample() {
  void typeCheck(value) {
    if (value is String) {
      print('Value is a String: $value');
    } else if (value is int) {
      print('Value is an int: $value');
    } else {
      print('Value is of unknown type: $value');
    }
  }

  print('\n=== Dynamic Type Example ===');

  dynamic value = "Hello, Dart!";
  typeCheck(value);
  value = 42;
  typeCheck(value); 
  value = 3.14;
  typeCheck(value);
  value = null;
  typeCheck(value);
  value = true;
  typeCheck(value);
  value = [1, 2, 3];
  typeCheck(value);
  value = {'key': 'value'};
  typeCheck(value);
  value = () => print('Hello from a function!');
  typeCheck(value);
  value(); // Call the function
  value = null; // Reset to null
}

void typeCastingExample() {
  print('\n=== Type Casting Examples ===');

  dynamic value = "hello";
  String text = value as String;
  print('Casted text: $text');

  // Nullable casting
  dynamic nullValue = null;
  String? nullableText = nullValue as String?;
  print('Nullable cast result: $nullableText');

  // With null coalescing
  String safeName = nullableText ?? 'default';
  print('Safe name: $safeName');
}

void typeCastingExampleWithError() {
  try {
    dynamic value = 42;
    String text = value as String; // This will throw an error
    print('Casted text: $text');
  } catch (e) {
    print('Error during type casting: $e');
  }
}

void betterTypeCastingExample() {
  dynamic value = 42;
  if (value is String) {
    String text = value as String; // This will throw an error
    print('Casted text: $text');
  } else { 
    print('Value is not a String, cannot cast: $value');
  }
}

void main() {
  print('=== TYPE CASTING EXAMPLES ===\n');
  dynamicTypeExample();  
  typeCastingExample();
  typeCastingExampleWithError();
  betterTypeCastingExample();
}
