Stream<int> getStream() async* {
  for (var i = 0; i < 5; i++) {
    yield i;
    if (i == 2 || i == 3) {
      yield* Stream.error('Custom error at index $i');
    }
  }
}

void main(List<String> arguments) {
  var stream = getStream();
  stream.listen(
    (event) => print('Data: $event'),
    onDone: () => print('Done'), 
    onError: (err) => print('Error: $err'));
}