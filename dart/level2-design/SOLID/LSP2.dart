abstract class Shape {
  num size();
}

class Rectangle implements Shape {
  final double width;
  final double height;
  Rectangle(this.width, this.height);
  @override
  num size() => width * height;
}

class Square implements Shape {
  final double r;
  Square(this.r);
  
  @override
  num size() => r * r;
}

main() {
  Shape s1 = Rectangle(10, 20); // var s2 is OK
  print(s1.size()); 
  // No violation of LSP
  Shape s2 = Square(10); // var s1 is OK. 
  print(s2.size()); 
}  
 