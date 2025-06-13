class Arith {
  int? x, y;
  Arith(int x, int y) {
    this.x = x; this.y = y;
  }
  // null1.dart:6:15: Error: Operator '+' cannot be called on 'int?' because it is potentially null.
  add () => x! + y!;
}

main() {
  var arith = Arith(1, 2);
  print(arith.add());
}