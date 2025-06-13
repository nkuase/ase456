Future<int> sumStream(Stream<int> stream) async {
  var sum = 0; 
  await for (var value in stream) {
    print('From Stream: $value');
    sum += value;
  }
  return sum; 
}

Stream<int> getStreamError() async* {
  for (var i = 1; i <= 5; i++) {
    if (i == 2) {
      yield* Stream.value(100); // gen 100, not 2
    }
    else if (i == 3) { // no stream generated
      yield* Stream.empty();
    }
    else if (i == 5) {
      yield* Stream.error('Custom error at index $i');
    }
    else {
      print("Generate: $i");
      yield i;
    }
  }
}

main() async {
  var s1 = Stream.fromIterable([1,2,3]);
  var res = await sumStream(s1); 
  print(res);
  print('****************');
  
  var s2 = Stream.value(1);
  res = await sumStream(s2); 
  print(res);  
  print('****************');
    
  try {
    res = await sumStream(getStreamError()); 
  }
  catch (e) {
    print(e);
  }
  print('****************');
  
  final stream = Stream<int>.periodic(Duration(seconds: 1), (count) => count * count).take(5);
  stream.forEach(print);
}