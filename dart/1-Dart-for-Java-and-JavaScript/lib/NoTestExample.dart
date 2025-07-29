// Example Dart file demonstrating the //No test exclusion feature
// This file shows how to use //No test comments to exclude certain functions from testing requirements

// Simple utility functions that don't need testing
String formatName(String first, String last) { //No test
  return '$first $last';
}

// Previous line comment style
//No test
String toUpperCase(String input) {
  return input.toUpperCase();
}

// Case insensitive variants work too
void simpleLogger(String message) { //no test
  print('[LOG] $message');
}

//NO TEST
int addOne(int value) {
  return value + 1;
}

class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  // Simple getter - no need to test
  String get displayName => name; //No test
  
  // Complex business logic - should be tested
  bool canVote() {
    return age >= 18;
  }
  
  // Another simple utility
  //No test
  String toString() {
    return '$name ($age years old)';
  }
  
  // Important validation logic - needs testing
  bool isValidAge() {
    return age > 0 && age < 150;
  }
  
  // Setter with validation - should be tested
  void updateAge(int newAge) {
    if (newAge > 0 && newAge < 150) {
      age = newAge;
    } else {
      throw ArgumentError('Age must be between 1 and 149');
    }
  }
}

// Complex function that definitely needs testing
List<Person> filterAdults(List<Person> people) {
  return people.where((person) => person.canVote()).toList();
}

// Business logic function that needs comprehensive testing
double calculateAverageAge(List<Person> people) {
  if (people.isEmpty) {
    return 0.0;
  }
  
  int totalAge = people.fold(0, (sum, person) => sum + person.age);
  return totalAge / people.length;
}

// Demo function to show the features
void demonstrateNoTestFeature() {
  print('=== //No test Exclusion Demo ===');
  
  var person1 = Person('Alice', 25);
  var person2 = Person('Bob', 16);
  var people = [person1, person2];
  
  print('People: ${people.map((p) => p.displayName).join(', ')}');
  print('Adults: ${filterAdults(people).map((p) => p.displayName).join(', ')}');
  print('Average age: ${calculateAverageAge(people)}');
  
  print('\nSimple utility functions (excluded from testing):');
  print('Formatted name: ${formatName('John', 'Doe')}');
  print('Uppercase: ${toUpperCase('hello world')}');
  simpleLogger('This is a log message');
  print('Add one: ${addOne(5)}');
}

void main() {
  demonstrateNoTestFeature();
}
