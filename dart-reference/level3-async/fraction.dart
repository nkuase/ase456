import 'dart:io';

abstract class IFraction {
  num toValue();
}

class Fraction implements IFraction, Comparable<Fraction> {
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
}

Stream<Fraction> fractionStream(int nom, int denom, [int delay = 1]) async* {
  for (int i = 1; i <= nom; i++) {
    for (int j = 1; j <= denom; j++) {
      await Future.delayed(Duration(seconds:delay));
      print('gen fraction of ($i)/($j) with delay ($delay)');
      yield Fraction(i, j);
    }
  }
}

fractionAdder(Stream<Fraction> stream) async {
  Fraction sum = Fraction.zero();
  await for (var value in stream) {
    sum = sum + value;
  }
  return sum;   
}

fractadd() async {
  var res = await fractionAdder(fractionStream(2,2)); // 1 + 1/2 + 2 + 2/2 = 4.5
  print(res.value); // 4.5
}

Future<List<Fraction>> readFile(String filePath) async {
  var res = await File(filePath).readAsString();
  var list = List<Fraction>.empty(growable:true);
  res.split('\n').forEach((val) { // PC may use \n\r instead
    if (val.trim().length > 0) {
      final splitted = val.split(' ');
      list.add(Fraction(int.parse(splitted[0]), int.parse(splitted[1])));
    }
  });    
  return list;
}
Future writeFile(String filePath, List<Fraction> fractions) async {
  
  var buffer = StringBuffer();
  fractions.forEach((val) {
    buffer.write('${val.numerator} ${val.denominator}\n');
  });
  
  return await File(filePath).writeAsString(buffer.toString());
}

main() async {
  fractadd(); // the rest of the code will be executed right away
  
  try {
    final list = await readFile('values.txt');
    list.forEach((e) => print(e.value));
  }
  catch (e) {
    print("Error reading file"); 
    exit(0);
  }
  
  try {
    //var a = Fraction(1, 0); // error
    var a = Fraction(1,10);
  } 
  on IntegerDivisionByZeroException catch (e) { // catch error 
    print('Denominator should not be zero $e');
  }
  
  var a = Fraction.zero();
  var a2 = Fraction.whole(10);
  var a3 = Fraction.oneHalf();
  
  print('before sorting');
  List<Fraction> l = <Fraction>[a, a2, a3];
  l.forEach(print);
  print('after sorting');
  var result = l.sort(); 
  l.forEach((i) => print(i.value));
  
  try {
    final list = await writeFile('values2.txt', l);
  }
  catch (e) {
    print("Error reading file"); 
    exit(0);
  }
}