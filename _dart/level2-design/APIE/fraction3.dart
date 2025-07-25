class Fraction {
  // member fields (states)
  int numerator, denominator;
  // constructors
  Fraction({required this.numerator, required this.denominator});
  // methods (behaviors)
  num toValue() => numerator/denominator;
  @override
  toString() => "$numerator/$denominator";
}
class Fraction2 {
  @override
  toString() => "Fraction2";
}

main() {
  var a = Fraction(numerator:5, denominator:10); 
  print(a.toString()); // or just print(a)
  var b = Fraction2();
  print(b.toString()); // or just print(b)
}