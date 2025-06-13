class Arith {
  static add(x, y) => x + y;
}

add(x, y) => x + y;

main() {
  print(Arith.add(10, 20));
  print(add(10, 20));
}