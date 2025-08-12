//No Test
Future<int> getNumber() {
  return Future.delayed(Duration(seconds: 1), () {
    return 42;
  });
}

void main() {
  getNumber().then((res) => print(res));
}