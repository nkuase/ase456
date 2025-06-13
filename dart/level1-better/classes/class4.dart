class Arith {
  int x, y;
  Arith({required this.x, required this.y});
  add () => x + y;
}

main() {
  var arith = Arith(x:1, y:2);
  print(arith.add());
}