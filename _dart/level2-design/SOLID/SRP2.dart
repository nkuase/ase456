// Calculations and logic
abstract class Shape {
  double area();
}
class Square extends Shape {
  double area() => 10;
}
class Circle extends Shape {
  double area() => 20;
}

// UI painting
abstract class ShapePainter {
  void draw();
}
class SquarePainter extends ShapePainter {
  void draw() {}
}
class CirclePainter extends ShapePainter {
  void draw() {}
}

main()
{
  var s = Square();
  s.area(); // get Square area
  var p = CirclePainter();
  p.draw(); // paint circle 
}
