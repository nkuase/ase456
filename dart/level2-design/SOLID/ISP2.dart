// Interfaces
abstract class Worker {
    void work();
}
abstract class Sleeper {
    void sleep();
}
class Human implements Worker, Sleeper {
  void work() => print("I do a lot of work");
  void sleep() => print("I need 10 hours per night...");
}
class Robot implements Worker {
  void work() => print("I always work");
}

main() {
  var h = Human();
  var r = Robot();
  h.sleep(); // OK
  r.work(); // OK
}