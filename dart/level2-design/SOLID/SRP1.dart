class Shapes {
  // Calculations
  double squareArea(double l) => 10; // sample value
  double circleArea(double r) => 20; // sample value

  // Paint to the screen
  void paintSquare() { /* ... */ } 
  void paintCircle() { /* ... */ } 
}

main() {
  var a = Shapes();
  // for calculate square area
  var res = a.squareArea(1); 
  // for paint circle on the screen
  a.paintCircle();
}