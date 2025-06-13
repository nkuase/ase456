class Arith {
  late int x, y;
  Arith(int x, int y) {
    this.x = x; this.y = y;
  }
  add () => x + y;
}

main() {
  Arith? arith = null;
  print(arith); // null
  print(arith ?? 0); // 0
  print(arith?.add());  // null
}