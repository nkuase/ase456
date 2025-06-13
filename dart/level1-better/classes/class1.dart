class Arith {
  int x = 0, y = 0;
  // late int x, y;
  Arith(int x, int y) {
  	this.x = x; this.y = y;
  }

  add () => x + y;
}

main() {
  var arith = new Arith(1, 2);
  print(arith.add());
}