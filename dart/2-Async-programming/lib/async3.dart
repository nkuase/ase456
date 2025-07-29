Future<int> getNumber() {
  return Future.delayed(Duration(seconds: 1), () {
    return 42;
  });
}

void main() async {
  int res = await getNumber();
  print(res);
}