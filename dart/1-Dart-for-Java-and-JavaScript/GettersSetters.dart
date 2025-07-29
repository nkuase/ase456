// Getters and Setters - Temperature Example
// Example from "Dart for Java and JavaScript programmers" lecture
import 'dart:math' as math;

class Temperature {
  double _celsius = 0;

  // Getter: access like a property
  double get celsius => _celsius;

  // Setter: assign like a property
  set celsius(double value) {
    if (value < -273.15) {
      throw ArgumentError(
        'Temperature cannot be below absolute zero (-273.15°C)',
      );
    }
    _celsius = value;
  }

  // Computed property: calculated on demand
  double get fahrenheit => _celsius * 9 / 5 + 32;

  // Setter for fahrenheit (converts to celsius internally)
  set fahrenheit(double value) {
    if (value < -459.67) {
      throw ArgumentError(
        'Temperature cannot be below absolute zero (-459.67°F)',
      );
    }
    _celsius = (value - 32) * 5 / 9;
  }

  // Computed property: Kelvin
  double get kelvin => _celsius + 273.15;

  set kelvin(double value) {
    if (value < 0) {
      throw ArgumentError('Temperature cannot be below absolute zero (0K)');
    }
    _celsius = value - 273.15;
  }

  // Read-only computed properties
  String get description {
    if (_celsius < 0) return 'Below freezing';
    if (_celsius < 10) return 'Cold';
    if (_celsius < 20) return 'Cool';
    if (_celsius < 30) return 'Warm';
    return 'Hot';
  }

  bool get isFreezing => _celsius <= 0;
  bool get isBoiling => _celsius >= 100;

  @override
  String toString() {
    return 'Temperature: ${_celsius.toStringAsFixed(1)}°C (${fahrenheit.toStringAsFixed(1)}°F, ${kelvin.toStringAsFixed(1)}K) - $description';
  }
}

// Example with validation in setters
class BankAccount {
  double _balance = 0;
  String _accountHolder;

  BankAccount(this._accountHolder);

  // Getter for balance (read-only access)
  double get balance => _balance;

  // No setter for balance - can only change through deposit/withdraw

  String get accountHolder => _accountHolder;

  set accountHolder(String name) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Account holder name cannot be empty');
    }
    _accountHolder = name.trim();
  }

  // Computed property
  String get accountStatus {
    if (_balance < 0) return 'Overdrawn';
    if (_balance < 100) return 'Low balance';
    if (_balance < 1000) return 'Normal';
    return 'High balance';
  }

  // Methods to change balance (instead of direct setter)
  void deposit(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Deposit amount must be positive');
    }
    _balance += amount;
  }

  void withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Withdrawal amount must be positive');
    }
    if (amount > _balance) {
      throw ArgumentError('Insufficient funds');
    }
    _balance -= amount;
  }

  @override
  String toString() {
    return 'Account(holder: $_accountHolder, balance: \$${_balance.toStringAsFixed(2)}, status: $accountStatus)';
  }
}

// Example with complex getter/setter logic
class Rectangle {
  double _width;
  double _height;

  Rectangle(this._width, this._height);

  double get width => _width;
  set width(double value) {
    if (value <= 0) throw ArgumentError('Width must be positive');
    _width = value;
  }

  double get height => _height;
  set height(double value) {
    if (value <= 0) throw ArgumentError('Height must be positive');
    _height = value;
  }

  // Computed properties
  double get area => _width * _height;
  double get perimeter => 2 * (_width + _height);

  // Getter and setter for diagonal (computed both ways)
  double get diagonal => math.sqrt(_width * _width + _height * _height);

  set diagonal(double value) {
    if (value <= 0) throw ArgumentError('Diagonal must be positive');
    // Keep the aspect ratio and set new diagonal
    double ratio = _height / _width;
    _width = math.sqrt((value * value) / (1 + ratio * ratio));
    _height = _width * ratio;
  }

  // Property that maintains square shape
  double get side {
    if (_width != _height) {
      throw StateError('Rectangle is not a square');
    }
    return _width;
  }

  set side(double value) {
    if (value <= 0) throw ArgumentError('Side must be positive');
    _width = value;
    _height = value;
  }

  bool get isSquare => _width == _height;

  @override
  String toString() {
    return 'Rectangle(${_width.toStringAsFixed(1)}x${_height.toStringAsFixed(1)}, area: ${area.toStringAsFixed(1)}, perimeter: ${perimeter.toStringAsFixed(1)})';
  }
}

void demonstrateTemperature() {
  print('=== TEMPERATURE GETTERS AND SETTERS ===\n');

  var temp = Temperature();

  // Property syntax - looks like direct property access
  temp.celsius = 25; // Looks like property assignment
  print('Set to 25°C: $temp');

  temp.fahrenheit = 100; // Set using Fahrenheit
  print('Set to 100°F: $temp');

  temp.kelvin = 300; // Set using Kelvin
  print('Set to 300K: $temp');

  // Read computed properties
  print('Is freezing: ${temp.isFreezing}');
  print('Is boiling: ${temp.isBoiling}');

  // Test validation
  try {
    temp.celsius = -300; // Below absolute zero
  } catch (e) {
    print('Error: $e');
  }
}

void demonstrateBankAccount() {
  print('\n=== BANK ACCOUNT EXAMPLE ===\n');

  var account = BankAccount('John Doe');
  print('Initial: $account');

  account.deposit(1000);
  print('After deposit: $account');

  account.withdraw(200);
  print('After withdrawal: $account');

  // Try to access balance directly (read-only)
  print('Current balance: \$${account.balance}');

  // Change account holder name
  account.accountHolder = 'Jane Smith';
  print('After name change: $account');

  // Test validation
  try {
    account.withdraw(2000); // Insufficient funds
  } catch (e) {
    print('Error: $e');
  }

  try {
    account.accountHolder = '   '; // Empty name
  } catch (e) {
    print('Error: $e');
  }
}

void demonstrateRectangle() {
  print('\n=== RECTANGLE GETTERS AND SETTERS ===\n');

  var rect = Rectangle(4, 3);
  print('Initial rectangle: $rect');
  print('Diagonal: ${rect.diagonal.toStringAsFixed(2)}');

  // Change size by setting diagonal
  rect.diagonal = 10;
  print('After setting diagonal to 10: $rect');

  // Make it a square
  rect.side = 5;
  print('After making it a square with side 5: $rect');
  print('Is square: ${rect.isSquare}');

  // Change one dimension
  rect.width = 6;
  print('After changing width to 6: $rect');
  print('Is square: ${rect.isSquare}');

  try {
    print('Trying to get side of non-square: ${rect.side}');
  } catch (e) {
    print('Error: $e');
  }
}

void demonstratePropertySyntax() {
  print('\n=== PROPERTY SYNTAX DEMONSTRATION ===\n');

  var temp = Temperature();

  print('No difference in usage between:');
  print('- Real properties: temp.celsius');
  print('- Computed properties: temp.fahrenheit');
  print('- Read-only properties: temp.description');

  temp.celsius = 20;
  print('temp.celsius = ${temp.celsius}'); // Real property
  print('temp.fahrenheit = ${temp.fahrenheit}'); // Computed property
  print('temp.description = ${temp.description}'); // Read-only computed
}

void main() {
  demonstrateTemperature();
  demonstrateBankAccount();
  demonstrateRectangle();
  demonstratePropertySyntax();
}
