class TestException implements Exception {
  final String  message;
  const TestException(this.message);
  @override
  String toString() => message; 
}

a() {
  throw TestException("Test Error!");
}

void main() {
  try {
    a(); 
  } catch (e) {
    print('what? $e');
  }
  
  try {
    a(); 
  } on TestException catch (e) {
    print('what? $e');
  } finally {
    print('Good bye');
  }
}


