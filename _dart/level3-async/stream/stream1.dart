int normalSum(Iterable<int> list) {
  var sum = 0;
  for (var value in list) {
    sum += value;
  }
  return sum;
}

Future<int> sumStream(Stream<int> stream) async {
  var sum = 0; 
  await for (var value in stream) {
    sum += value;
  }
  return sum; 
}

Stream<int> genValues(int n) async* {
  for (int i = 1; i <= n; i++) {
    await Future.delayed(Duration(seconds:1));
    print('count: $i');
    yield i;
  }
}

Iterable<int> genValues2(int n) sync* {
  for (int i = 1; i <= n; i++) {
    print('count: $i');
    yield i;
  }
}

void main() async {
  Iterable<int> l = <int>[1,2,3,4,5];
  var res = normalSum(l);
  print(res);
  
  final stream = Stream<int>.fromIterable([1,2,3,4,5]); 
  res = await sumStream(stream);
  print(res);
  
  res = await sumStream(genValues(5));
  print(res);
  
  res = normalSum(genValues2(5));
  print(res);
}