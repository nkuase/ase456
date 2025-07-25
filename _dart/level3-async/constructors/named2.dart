 class Fraction {
   int _numerator;
   int _denominator;
   Fraction(this._numerator, this._denominator);
   // denominator cannot be 0 because 0/0 is not defined!
   Fraction.zero() : _numerator = 0, _denominator = 1;
   Fraction.oneHalf() : this(1, 2);
   // Represents integers, like '3' which is '3/1' 
   Fraction.whole(int val) : this(val, 1);
}