list1() {
  var l1 = [1,2,3,4];
  // add 1 to all the list elements
  var l2 = l1.map((i) => (i + 1)).toList();
  l2.forEach(print); print('');
}

list2() {
  var l1 = [1,2,3,4];
  // filter only the even numbers
  var l2 = l1.where((x) => x % 2 == 0).toList();
  l2.forEach(print); print('');
  var l3 = l1.where((x) => x % 2 == 1).map((x) => x + 10).toList();
  l3.forEach(print); print('');  
}

list3() {
  var l1 = [1,2,3,4];
  print(l1.reduce((acc, value) => acc + value)); // sum
  int res = l1.fold(0,(acc, value) => acc + value);
  print(res);
}

main() {
  list1();
  list2();
  list3();
}