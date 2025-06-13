class Arith {
  static int staticValue = 0;
  late int x, y;
  Arith(int x, int y) {
     this.x = x; this.y = y; 
  }
}
void main() {
  Arith.staticValue = 20;
  print(Arith.staticValue);
}