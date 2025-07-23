void map1() {
  Map<String, int> m = new Map<String, int>();
  m['x'] = 1; m['y'] = (m['x'] ?? 0) + 10;

  // keys, values, and entries to access map contents
  // Iterable<MapEntry<K,V>>
  var entries = m.entries;
  for (MapEntry<String, int> entry in entries) {
    print('${entry.key}:${entry.value}');
  }
  print('');
  for (var key in m.keys) {
    print(key);
  }
  print('');
  for (var value in m.values) {
    print(value);
  }
  print('');
}

void map2() {
  // Better way to instantiate a map object
  Map<String, int> m = <String, int>{
  	"x":1, "y":2
  };
  
  for (MapEntry<String, int> entry in m.entries) {
    print('${entry.key}:${entry.value}');
  }  
  print('');
}

void map3() {
  // Instantiate just like JavaScript/Python
  var m = {"x":1, "y":2};
  
  for (var entry in m.entries) {
    print('${entry.key}:${entry.value}');
  } 
  print('');
}

void map4() {
  var m = {"x":1, "y":2};
  var m2 = Map.from(m); // Map.of(m); 
  print(m == m2); // false
  print(m['x'] == m2['x'] && m['y'] == m2['y']); // true
  
  for (var entry in m2.entries) {
    print('${entry.key}:${entry.value}');
  }
  print('');
}

void main() {
  map1(); 
  map2();
  map3();
  map4();
}