// Higher-Order Functions: map() and where()
// Examples from "Higher-Order Functions with Lambda Expressions" lecture

void main() {
  print('=== OTHER HIGHER-ORDER FUNCTIONS ===\n');

  anyAndEveryExample();
  takeSkipTakewhileExample();
}

void anyAndEveryExample() {
  List<int> numbers = [1, 3, 5, 7, 8];
  bool hasEven = numbers.any((x) => x % 2 == 0);
  print(hasEven); // true (because of 8)

  List<int> ages = [18, 25, 30, 35];
  bool allAdults = ages.every((age) => age >= 18);
  print(allAdults); // true

  List<String> emails = ['a@b.com', 'invalid-email', 'c@d.com'];
  bool allValidEmails = emails.every((email) => email.contains('@'));
  print(allValidEmails); // false
}

void takeSkipTakewhileExample() {
  List<String> fruits = ['Apple', 'Banana', 'Orange', 'Grape', 'Mango'];

  // Take first 3 items
  List<String> firstThree = fruits.take(3).toList();
  print(firstThree); // ['Apple', 'Banana', 'Orange']

  // Skip first 2 items
  List<String> remaining = fruits.skip(2).toList();
  print(remaining); // ['Orange', 'Grape', 'Mango']

  // Take while condition is true
  List<int> numbers = [1, 2, 3, 4, 5, 1, 2];
  List<int> ascending = numbers.takeWhile((x) => x <= 3).toList();
  print(ascending); // [1, 2, 3]
}
