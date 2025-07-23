void list1() {
  // Similar to Java, but a bit complicated
  // List<int> list = List<int>() // for Dart 2.X
  List<int> list = List<int>.empty(growable:true); // for Dart 3.X
  list.add(1); list.add(2); list.add(3); 
  list.remove(1);
  list.clear();
  
  final fixedLengthList = List<int>.filled(5, 0);
  print(fixedLengthList); 
  
  print('list1');
  for (int i = 0; i < list.length; i++) {
    print(list[i]);
	print(list.elementAt(i));
  }
  print('');
}

void list2() {
  // Similar to JavaScript or Python
  List<int> list = <int>[1, 2, 3]; 
  print(list);
}

void list3() {
  var list = [1, 2, 3];
  var list2 = List.from(list); // clone
  //list2 = List.of(list); // clone
  print(list2.length == list.length); 
  
  list.insert(0, 100); // [100, 1, 2, 3]
  list.removeAt(list.length - 1); // [100, 1, 2]
  print(list);
  
  // properties
  print(list.first); // 100
  print(list.last); // 2
  print(list.isEmpty); // false
  
  // Methods
  print(list.contains(100)); // true
  print(list.indexOf(2)); // 2
}

void list4() {
  var list1 = [1,2,3];
  var list2 = [...list1, 4,5,6]; // spread overator
  print(list2);
  
  final numbers = [
     0, 1, 2,
     for(var i = 3; i < 10; ++i) if (i != 7) i
  ];
  print(numbers);
}

void main() {
  list1();
  list2();
  list3();
  list4();
}