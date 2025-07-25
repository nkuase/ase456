class Fraction {
  // member fields (states)
  int numerator, denominator;
  // constructors
  Fraction({required this.numerator, required this.denominator});
  // methods (behaviors)
  num toValue() => numerator/denominator;
}

main() {
  var a = Fraction(numerator:5, denominator:10); 
  print(a.toValue()); 
}