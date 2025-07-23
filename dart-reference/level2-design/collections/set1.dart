void set1() {
  Set<int> s = Set();
  s.add(0); s.add(1);
  s.addAll({2, 3, 4});  
  for (var entry in s) {
    print(entry); // 0, 1, 2, 3, 4
  } 
  print('');
}

void set2() {
  Set<int> s = <int>{0, 1, 2, 3};
  s.clear(); 
  s.add(0);
  for (var entry in s) {
    print(entry); // 0
  } 
  print('');
}

void set3() {
  var s = {0, 1, 2, 3};
  var s2 = Set.from(s);
  var s3 = Set.of(s);  
  var s4 = [1,2,3,3].toSet();
  print('set3()');  
  for (var entry in s4) {
    print(entry);
  } 
  print('');
	
  s.add(4);
  s.addAll([5,6,7]);
  s.remove(7);
  for (var entry in s) {
    print(entry);
  } 
  print('');
}

void set4() {
  var s1 = {0, 1, 2, 3};
  var s2 = {2, 3, 4, 5};
  for (var entry in s1.union(s2)) { // 0, 1, 2, 3, 4, 5, 
    print(entry);
  }
  print(''); 
  for (var entry in s1.intersection(s2)) { // 2, 3
    print(entry);
  } 
  print(''); 
  for (var entry in s1.difference(s2)) { // 0, 1
    print(entry);
  }   
}

void main() {
  set1();
  set2();
  set3();
  set4();
}