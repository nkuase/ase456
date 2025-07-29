// Immutable Data Updates with copyWith() Pattern
// Example from "Dart for Java and JavaScript programmers" lecture

class User {
  final String name;
  final int age;
  final String email;
  
  const User({required this.name, required this.age, required this.email});
  
  // copyWith creates a new instance with some fields changed
  User copyWith({String? name, int? age, String? email}) {
    return User(
      name: name ?? this.name,       // Use new value OR keep existing
      age: age ?? this.age,
      email: email ?? this.email,
    );
  }
  
  @override
  String toString() {
    return 'User(name: $name, age: $age, email: $email)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
           other.name == name &&
           other.age == age &&
           other.email == email;
  }
  
  @override
  int get hashCode => Object.hash(name, age, email);
}

void demonstrateCopyWith() {
  // Original user
  var user = User(name: "John", age: 25, email: "john@email.com");
  print('Original user: $user');
  
  // Change only the age
  var olderUser = user.copyWith(age: 26);
  print('Older user: $olderUser');
  print('Name unchanged: ${olderUser.name}');       // "John" (unchanged)
  print('Age changed: ${olderUser.age}');           // 26 (changed)
  print('Email unchanged: ${olderUser.email}');     // "john@email.com" (unchanged)
  
  // Change multiple fields
  var updatedUser = user.copyWith(
    name: "John Smith", 
    email: "johnsmith@email.com"
  );
  print('Updated user: $updatedUser');
  
  // Change nothing (creates identical copy)
  var copy = user.copyWith();
  print('Copy: $copy');
  
  print('Original == olderUser: ${user == olderUser}');        // false (different objects)
  print('Original name == copy name: ${user.name == copy.name}');   // true (same values)
}

void main() {
  print('=== IMMUTABLE DATA UPDATES WITH COPYWITH ===\n');
  demonstrateCopyWith();
}
