class Rectangle {
  double width;
  double height;
  Rectangle(this.width, this.height);
  size() => width * height;
}
class Square extends Rectangle {
  Square(double length): super(length, length);
}

void main() {
  // Violation of LSP
  Rectangle fail = Square(3);
  fail.width = 4;  // ??
  fail.height = 8; // ?? 
  print(fail.size()); // 32 ??
}