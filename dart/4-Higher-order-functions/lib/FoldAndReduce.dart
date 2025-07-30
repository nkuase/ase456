void main() {
  print('=== MAP() AND WHERE() FUNCTIONS ===\n');

  foldExample();
  reduceExample();
}

class Product {
  String name;
  double price;
  Product(this.name, this.price);
}

void foldExample() {
  List<int> numbers = [1, 2, 3, 4, 5];
  int sum = numbers.fold(0, (total, current) => total + current);
  print(sum); // 15

  // Concatenate strings
  List<String> words = ['Hello', 'World', '!'];
  String sentence = words.fold('', (result, word) => result + word + ' ');
  print(sentence.trim()); // "Hello World !"

  List<Product> cart = [
    Product('Apple', 1.5),
    Product('Banana', 2.0),
    Product('Orange', 3.0),
  ];

  double totalPrice = cart.fold(0.0, (total, product) => total + product.price);
  print('Total: \$${totalPrice}'); // Total: $6.5

  // Find the maximum number
  int maxNumber = numbers.fold(
    numbers[0],
    (max, current) => current > max ? current : max,
  );
  print(maxNumber); // 5
}

void reduceExample() {
  List<int> numbers = [1, 2, 3, 4, 5];

  // Using reduce to find the sum
  int sum = numbers.reduce((a, b) => a + b);
  print('Sum: $sum'); // Sum: 15

  // Using reduce to find the maximum number
  int maxNumber = numbers.reduce((a, b) => a > b ? a : b);
  print('Max: $maxNumber'); // Max: 5
}
