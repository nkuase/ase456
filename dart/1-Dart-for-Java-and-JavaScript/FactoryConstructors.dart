// Factory Constructors - Smart Object Creation
// Example from "Dart for Java and JavaScript programmers" lecture

class User {
  final String name;
  final int age;
  final String? email;
  final bool isActive;

  // Regular constructor
  User({required this.name, this.age = 0, this.email, this.isActive = false});

  // Factory constructor for guest users
  factory User.guest() => User(name: "Guest");

  // Factory constructor for creating user from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      age: json['age'] as int? ?? 0,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  // Factory constructor for admin users
  factory User.admin(String name) =>
      User(name: name, age: 30, email: '$name@admin.com', isActive: true);

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'age': age, 'email': email, 'isActive': isActive};
  }

  @override
  String toString() {
    return 'User(name: $name, age: $age, email: $email, isActive: $isActive)';
  }
}

void demonstrateFactoryConstructors() {
  print('=== FACTORY CONSTRUCTOR EXAMPLES ===\n');

  // Regular constructor
  var regularUser = User(name: "John", age: 25, email: "john@email.com");
  print('Regular user: $regularUser');

  // Factory constructor for guest
  var guest = User.guest(); // Cleaner syntax
  print('Guest user: $guest');

  // Factory constructor for admin
  var admin = User.admin("Alice");
  print('Admin user: $admin');

  // Factory constructor from JSON
  var jsonData = {
    'name': 'Bob',
    'age': 28,
    'email': 'bob@example.com',
    'isActive': true,
  };
  var userFromJson = User.fromJson(jsonData);
  print('User from JSON: $userFromJson');

  // Convert back to JSON
  print('User to JSON: ${userFromJson.toJson()}');

  // Example with incomplete JSON data
  var incompleteJson = {'name': 'Charlie'};
  var userFromIncompleteJson = User.fromJson(incompleteJson);
  print('User from incomplete JSON: $userFromIncompleteJson');
}

// Another example with singleton pattern using factory
class Logger {
  static Logger? _instance;
  final String name;

  // Private constructor
  Logger._(this.name);

  // Factory constructor that returns singleton
  factory Logger(String name) {
    _instance ??= Logger._(name);
    return _instance!;
  }

  void log(String message) {
    print('[$name] $message');
  }
}

void demonstrateSingletonFactory() {
  print('\n=== SINGLETON FACTORY EXAMPLE ===\n');

  var logger1 = Logger("App");
  // Still returns the same instance
  var logger2 = Logger("Database");
  print(logger1.name == logger2.name); // true

  logger1.log("First message");
  logger2.log("Second message");

  print('Same instance: ${identical(logger1, logger2)}'); // true
}

void main() {
  demonstrateFactoryConstructors();
  demonstrateSingletonFactory();
}
