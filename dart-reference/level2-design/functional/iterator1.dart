iter1() {
  var l = [1,2,3];
  var it = l.iterator;
  while (it.moveNext()) {
    print(it.current);
  }
  print('');
}

iter2() {
  var l = [1,2,3];
  for (var i = 0; i < l.length; i++) {
    print(l[i]);
  }
  print('');
}

iter3() {
  var l = [1,2,3];
  // l.forEach(print); 
  l.forEach((i) => print(i));
  print('');
}

main() {
  iter1();
  iter2();
  iter3();
}