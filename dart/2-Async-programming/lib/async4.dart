Future<int> getNumber() {
  return Future.delayed(Duration(seconds: 1), () {
    return 42;
  });
}

void main() {
  var res = getNumber();
  print(res);
}