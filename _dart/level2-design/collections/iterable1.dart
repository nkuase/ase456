f1() {
  Iterable<int> iterable = [1, 2, 3, 4, 5];
  for (var n in iterable) {
    print(n);
  }
  print('');
    
  var i2 = List.from(iterable);
  var i3 = List.of(iterable);
  for (var n in i2.toSet()) {
    print(n);
  }; 
  print('');

}

f2() {
  Iterable<int> iterable = {1, 2, 3, 4, 5};
  var i2 = Set.from(iterable);
  var i3 = Set.of(iterable);
  i2.add(6); i2.add(7);
  i2.addAll({8, 9, 10});
  i2.remove(8);
  i2.clear();  
  print('f2');
  for (var n in i2) {
    print(n);
  }  
  print('');
  for (var n in i2.toList()) {
    print(n);
  }
  print('');
}

f3() {
  Iterable<int> iterable = {1, 2, 3, 4, 5};
  
  // properties
  print(iterable.first); // 100
  print(iterable.last); // 2
  print(iterable.isEmpty); // false
  print(iterable.length); // 5 
  
  // Methods
  print(iterable.contains(1)); // true
}

f4() {
  Iterable<int> l = [1,2,3];
  print(l.elementAt(0));
  var it = l.iterator;
  while (it.moveNext()) {
    print(it.current);
  }
  print('');
  for (var n in l) {
    print(n);
  }  
  print('');
}

void main() {
  f1();
  f2();
  f3();
  f4();
}