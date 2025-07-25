class Example{
  var a;
  void set(a) {this.a = a;}
  void printValue(){print(this.a);}
}

f1() {
  var e = Example();
  e.a = 88;
  e.set(10);
  e.printValue(); 
}

f2() {
  var e = Example();
  e..a = 88..set(10)..printValue();
}

f3() {
  var l1 = ['x','ax','ac','aa'];
  l1.sort(); l1.forEach(print); print('');  
  // error with .sort() because it returns void
  // l1 = ...; l1.sort(); <- equivalent code.
  l1.where((x) => x.startsWith('a')).toList()..sort()..forEach(print); 
}

main() {
  f1();
  f2();
  f3();
}