abstract class IFraction {
  num toValue();
}

class Fraction implements IFraction{
  int numerator, denominator;
  Fraction({required this.numerator, required this.denominator});
  @override
  num toValue() => numerator/denominator;
}

main() {
  var a = Fraction(numerator:5, denominator:10); 
  print(a.toValue()); 
}