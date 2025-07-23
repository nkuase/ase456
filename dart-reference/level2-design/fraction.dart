abstract class IFraction {
  num toValue();
}

class Fraction implements IFraction, Comparable<Fraction> {
  late int _numerator;
  late int _denominator;
  // Fraction(this._numerator, this._denominator);
  Fraction(int numerator, int denominator) {
      this._numerator = numerator;
      this.denominator = denominator; 
  }
  // getters
  int get numerator => _numerator;
  int get denominator => _denominator;
  num get value => toValue();
  // setter
  set denominator(int value) {
    _denominator = (value == 0)? 1 : value;
  }
  toValue() => _numerator/_denominator;
  operator+(Fraction other) =>
    Fraction(
      _numerator * other._denominator +
      _denominator * other._numerator,
      _denominator * other._denominator
    );
  operator==(Object other) => compareTo((other as Fraction)) == 0;
  @override
  toString() => "$_numerator/$_denominator";
  @override
  int compareTo(Fraction other) {
    if (this._numerator * other._denominator == other._numerator * this._denominator) return 0;
    return (this.value - other.value) > 0 ? 1 : -1;
  }
}

class MyFraction extends Fraction {
  MyFraction({required int nominator, required int denominator}) : super(nominator, denominator);
  
  toValueString() => toValue().toString(); // added method
}

main() {
  var sum = MyFraction(nominator:1, denominator:2) + MyFraction(nominator:1, denominator:2);
  print('$sum and ${sum.value}');
  
  var f = MyFraction(nominator:10, denominator: 0); // 0 -> 1 
  print(f.denominator); // 1 not 0
  
  f.denominator = 5;
  print('$f and ${f.toValue()}'); // 10/5 and 2.0

  var a = MyFraction(nominator:5, denominator: 10); 
  var a2 = MyFraction(nominator:1, denominator: 2); 
  print(a == a2 ? 'same' : 'different'); 

  var b = MyFraction(nominator:2, denominator: 10);
  var c = MyFraction(nominator:3, denominator: 10);
  
  print('before sorting');
  List l = [a, b, c];
  l.forEach(print);
  print('after sorting');
  var result = l.sort(); 
  l.forEach((i) => print(i.toValueString()));
  
  var l2 = {a, a, a, b, c}; // set removes duplication
  print('Set counting ${l2.length}'); // only 2 as a and a2 are different objects (with same value)
  print(l2);
  
  print('select the values smaller than 0.5 and print the numerator');
  var res = l2.where((a) => a.value < 0.5).map((a) => a.numerator).toList();
  print(res);
}