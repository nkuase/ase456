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
class Circle implements Shape {
  final double radius;
  Circle(this.radius);
  
  double get PI => 3.1415;

  @override
  num size() => radius * radius * PI;
}

main() {
  print(Rectangle(10,20).size());
  print(Circle(5).size());
}  
 