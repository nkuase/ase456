void map2() {
  var m = {"x":1, "y":2};
  var m2 = {"x":1, "y":3, "z":5};
  m.addAll(m2); // updates y and adds z
  m['w'] = (m['w'] ?? 0) + 100; 
  m.update('w', (value) => value + 100, ifAbsent:() => 0); // updates w to w + 100
    
  for (var entry in m.entries) {
    print('${entry.key}:${entry.value}');
  } 
  print(m.containsKey('z')); // true
  print(m2.containsValue(5)); // true
  
  m.remove('z');
  print(m.containsKey('z')); // false  
}

void main() {
  map1(); 
}