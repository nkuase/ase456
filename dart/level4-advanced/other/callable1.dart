class Example {
  double call(double a, double b) => a + b;
}
void main() {
  final ex = Example(); // 1. instantiation
  final value = ex(1.3, -2.2); // 2. invoke the call method with () opeartor
  print(value);
}