class Fraction {
  late final int numerator; // to prevent update
  late int denom; // it can be assigned to other value later
  Fraction(int numerator, int d) {
      this.numerator = numerator;
      denominator = d; // invoke setter
  }
    
  toValue() => numerator / denom;
  
  // getter
  num get value => toValue(); 
  int get denominator => denom;
  // setter
  set denominator(int value) {
    if (value == 0) {
      denom = 1;
    } else {
      denom = value;
    }
  }
  
  operator+(Fraction other) =>
    Fraction(
      numerator * other.denominator +
      denominator * other.numerator,
      denominator * other.denominator
    );
  @override
  bool operator ==(Object other) {
    return (this.numerator == (other as Fraction).numerator && this.denominator == (other as Fraction).denominator);
  }
  @override
  int compareTo(Fraction other) {
    if (this.numerator * other.denominator == other.numerator * this.denominator) return 0;
    return (this.value - other.value) > 0 ? 1 : -1;
  }
  @override
  toString() => "$numerator/$denominator";
}

class FractionWithoutEqual {
  final int numerator;
  final int denominator;
  FractionWithoutEqual(this.numerator, this.denominator);
}

main() {
  var sum = Fraction(1,2) + Fraction(1, 2);
  print(sum);
  print(sum.toValue());
  
  var a = Fraction(10, 30); 
  var b = Fraction(10, 30); 
  print (a == b); // check if they have the same value
  
  var a2 = FractionWithoutEqual(10, 20);
  var b2 = FractionWithoutEqual(10, 20);
  print(a2 == b2); // they don't reference the same object, so false
  
  a = Fraction(10, 0);
  print('a.denominaotr is ${a.denominator}'); 
  
  a = Fraction(5, 10); 
  b = Fraction(2, 10);
  var c = Fraction(3, 10);
  List l = [a, b, c];
  var result = l.sort((a, b) => a.compareTo(b));
  for (var i = 0; i < 3; i++) {
    print(l[i].toValue()); // b, c, a
  }
}