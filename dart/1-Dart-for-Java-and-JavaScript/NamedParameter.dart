// ============================================
// 2. NAMED PARAMETER EXAMPLES
// ============================================

class User {
  String name;
  int age;
  String? email;
  bool isActive;

  User({required this.name, this.age = 0, this.email, this.isActive = false});

  @override
  String toString() {
    return 'User(name: $name, age: $age, email: $email, isActive: $isActive)';
  }
}

void namedParameterExample() {
  // Clear and flexible parameter usage
  var user = User(
    name: "John", // Required - won't compile if not provided
    isActive: true, // Optional - false by default
  );
  print('Named Parameter Example: $user');
}

void main() {
  print('=== NAMED PARAMETER EXAMPLES ===\n');
  namedParameterExample();
}
