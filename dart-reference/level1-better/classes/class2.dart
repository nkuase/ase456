class Arith {
  int x, y;
  Arith(this.x, this.y);
  add () => x + y;
}

main() {
  var arith = Arith(1, 2);
  print(arith.add());
}