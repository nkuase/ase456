abstract class IFraction {
  num toValue();
}

class Fraction implements IFraction{
  int numerator, denominator;
  Fraction({required this.numerator, required this.denominator});
  @override
  num toValue() => numerator/denominator;
}

class Fraction2 implements IFraction { 
  @override
  num toValue() => 10; 
}

class ExtendedFraction extends Fraction {
  ExtendedFraction({required int numerator, required int denominator}) : super(numerator: numerator, denominator: denominator);
  toValueString() => toValue().toString() + "!";
}

main() {
  var a = Fraction(numerator:5, denominator:10); // var a is OK
  var b = Fraction2(); // var b is OK
//  IFraction a = Fraction(numerator:5, denominator:10); // var a is OK
//  IFraction b = Fraction2(); // var b is OK
  List<IFraction> l = [a, b]; // var l is OK
  
  //l.forEach((o) {print(o.toValue());}); // 0.5 10
  for (var i = 0; i < l.length; i++) {
    print(l[i].toValue());
  }    
  var c = ExtendedFraction(numerator:10, denominator:20);
  print(c.toValueString());
}