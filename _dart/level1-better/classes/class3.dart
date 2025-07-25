class Arith {
  int x, y;
  Arith({this.x = 0, this.y = 0});
  add () => x + y;
}

main() {
  var arith = Arith();
  print(arith.add());
  arith = Arith(x:1, y:2);
  print(arith.add());
}