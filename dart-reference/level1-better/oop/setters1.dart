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
    denom = (value == 0)? 1 : value;
  }
}  

main() {
  var a = Fraction(10, 0);
  print('a.denominaotr is ${a.denominator}'); 
  var b = Fraction(20, 1); 
  b.denominator = 0; 
  print('b.denominaotr is ${b.denominator}');   
}  