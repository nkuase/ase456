class Rectangle {
  final double width;
  final double height;
  Rectangle(this.width, this.height);
}
class Circle {
  final double radius;
  Circle(this.radius);
  
  double get PI => 3.1415;
}

class AreaCalculator {
  double calculate(Object shape) {
    // BAD CODE!
    if (shape is Rectangle) { // Smart cast
      final r = shape as Rectangle;
      return r.width * r.height;
    } else {
      final c = shape as Circle;
      return c.radius * c.radius * c.PI;
    }
  }
}

main() {
  var calculator = AreaCalculator();
  print(calculator.calculate(Rectangle(10,20)));
  print(calculator.calculate(Circle(5)));
}  
 