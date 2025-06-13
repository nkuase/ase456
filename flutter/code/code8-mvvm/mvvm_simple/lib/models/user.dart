// lib/models/user.dart
class User {
  final String name;
  final String email;
  final int age;

  User({
    required this.name,
    required this.email,
    required this.age,
  });

  // Factory constructor for creating empty user
  factory User.empty() {
    return User(
      name: '',
      email: '',
      age: 0,
    );
  }

  // Factory constructor for creating dummy data
  factory User.dummy() {
    return User(
      name: 'John Doe',
      email: 'john@example.com',
      age: 25,
    );
  }

  // Create a new user with updated age
  User copyWith({String? name, String? email, int? age}) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
    );
  }

  // Check if user data is empty
  bool get isEmpty => name.isEmpty && email.isEmpty && age == 0;

  @override
  String toString() {
    return 'User(name: $name, email: $email, age: $age)';
  }
}