void main() {
  const x1 = 10;
  var y1 = x1; // compiler changes the code var y = 10;
  x1 = 20; // compiler doesn't allow this
  final x2 = 10;
  x2 = 20; // compiler doesn't allow this
  var y2 = x2; // compiler doesn't do any change
  print(x1); print(y1);
  print(x2); print(y2);
}