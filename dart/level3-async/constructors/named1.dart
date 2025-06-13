named1() {
  var l1 = List.empty(growable: true);
  l1.addAll([1,2]); l1.add(3);
  l1.forEach(print); print(''); // 1,2,3
  
  var l2 = List.of({1,2,3});
  l2.forEach(print); print(''); // 1,2,3
  
  var l3 = List.from({1,2,3});
  l3.forEach(print); print(''); // 1,2,3
}

main() {
  named1();
}