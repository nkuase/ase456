import 'dart:io';

abstract class IFraction {
  num toValue();
}

mixin Printer {
  String decoration(String input) {
    return "*** $input ***";
  }
}

class Fraction with Printer implements IFraction, Comparable<Fraction> {
  late int _numerator;
  late int _denominator;
  Fraction(this._numerator, this._denominator) {
    if (_denominator == 0) {
      throw IntegerDivisionByZeroException();
    }
  }
  // denominator cannot be 0 because 0/0 is not defined!
  Fraction.zero() : _numerator = 0, _denominator = 1;
  Fraction.oneHalf() : this(1, 2);
  // Represents integers, like '3' which is '3/1' 
  Fraction.whole(int val) : this(val, 1);
  
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
  
  Fraction copyWith({
    int? numerator,
    int? denominator,
  }) => Fraction(
    numerator ?? this.numerator,
    denominator ?? this.denominator
  );
  
  String call(String prefix) {
    var v = prefix + value.toString(); 
    return '''
Fraction information:
${v}
''';
  }    
}

extension Ext on Fraction {
  String toValueString() => this.toValue().toString(); 
}

main() {
  var a = Fraction(1, 10);
  print(a.toValueString()); // extension 
  var b = a.copyWith(numerator:3); // cloning with copyWith
  print(b.toValueString()); // extension 
  print(b("My Value is: ")); // callable
  print(b.decoration(b.toValueString())); // Mixin
}