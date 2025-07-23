// Wrong Interfaces
abstract class Worker {
  void work();
  void sleep();
}
class Human implements Worker {
  void work() => print("I do a lot of work");
  void sleep() => print("I need 10 hours per night...");
}
class Robot implements Worker {
  void work() => print("I always work"); 
  void sleep() {} // ??
}
main() {
  var h = Human();
  var r = Robot();
  h.sleep(); // OK
  r.sleep(); // ??
}