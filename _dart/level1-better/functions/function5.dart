add(x, [y = 20]) => x + y; // optional with default
sub(x, {y = 0}) => x - y;
main() {
  print(add(10)); // 30
  print(sub(10, y:20)); // 10 - 20 = -10
  print(sub(10)); // 10 - 0 = 10
}