add (int x, int y) { return(x + y); }
sub (int x, int y) => (x - y);
final mul = (x, y) => (x * y);

main() {
  print(add(10, 20));
  print(sub(10, 20));
  print(mul(10, 20));
}