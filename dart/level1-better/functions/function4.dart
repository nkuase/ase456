nested(x, y) {
  add(x, y) => x + y;
  sub(x, y) { return (x - y); }
  return add(x,y) * sub(x,y);
}

main() {
    print(nested(10, 20));
}