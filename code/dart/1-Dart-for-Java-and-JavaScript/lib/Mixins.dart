// Mixins - Multiple Inheritance Alternative
// Example from "Dart for Java and JavaScript programmers" lecture

mixin Flyable {
  void fly() => print("Flying through the air!");

  // Mixins can have properties too
  double get flyingSpeed => 50.0; // km/h

  void takeOff() => print("Taking off...");
  void land() => print("Landing...");
}

mixin Swimmable {
  void swim() => print("Swimming in the water!");

  double get swimmingSpeed => 20.0; // km/h

  void dive() => print("Diving underwater...");
  void surface() => print("Coming to surface...");
}

mixin Walkable {
  void walk() => print("Walking on land!");

  double get walkingSpeed => 5.0; // km/h

  void run() => print("Running fast!");
}

// Duck can fly and swim
class Duck with Flyable, Swimmable {
  void quack() => print("Quack! Quack!");

  // Override mixin methods if needed
  @override
  void swim() {
    print("Duck swimming gracefully!");
  }
}

// Penguin can swim and walk but not fly
class Penguin with Swimmable, Walkable {
  void slide() => print("Sliding on ice!");

  @override
  void walk() {
    print("Penguin waddling adorably!");
  }
}

// Eagle can fly and walk
class Eagle with Flyable, Walkable {
  void hunt() => print("Hunting for prey!");

  @override
  double get flyingSpeed => 150.0; // Eagles are faster flyers
}

// Fish can only swim
class Fish with Swimmable {
  void breatheUnderwater() => print("Breathing through gills!");
}

// Superhero with all abilities!
class Superman with Flyable, Swimmable, Walkable {
  void saveTheWorld() => print("Saving the world!");

  @override
  double get flyingSpeed => 1000.0; // Superman is super fast!

  @override
  double get swimmingSpeed => 500.0;

  @override
  double get walkingSpeed => 100.0;
}

void demonstrateMixins() {
  print('=== MIXIN EXAMPLES ===\n');

  print('--- Duck (Flyable + Swimmable) ---');
  var duck = Duck();
  duck.quack();
  duck.fly();
  duck.swim();
  duck.takeOff();
  duck.dive();
  print('Duck flying speed: ${duck.flyingSpeed} km/h');
  print('Duck swimming speed: ${duck.swimmingSpeed} km/h');

  print('\n--- Penguin (Swimmable + Walkable) ---');
  var penguin = Penguin();
  penguin.slide();
  penguin.swim();
  penguin.walk();
  penguin.run();
  // penguin.fly(); // This would cause a compile error!
  print('Penguin swimming speed: ${penguin.swimmingSpeed} km/h');
  print('Penguin walking speed: ${penguin.walkingSpeed} km/h');

  print('\n--- Eagle (Flyable + Walkable) ---');
  var eagle = Eagle();
  eagle.hunt();
  eagle.fly();
  eagle.walk();
  eagle.takeOff();
  eagle.land();
  print('Eagle flying speed: ${eagle.flyingSpeed} km/h');
  print('Eagle walking speed: ${eagle.walkingSpeed} km/h');

  print('\n--- Fish (Swimmable only) ---');
  var fish = Fish();
  fish.swim();
  fish.dive();
  fish.breatheUnderwater();
  print('Fish swimming speed: ${fish.swimmingSpeed} km/h');

  print('\n--- Superman (All abilities!) ---');
  var superman = Superman();
  superman.saveTheWorld();
  superman.fly();
  superman.swim();
  superman.walk();
  superman.run();
  print('Superman flying speed: ${superman.flyingSpeed} km/h');
  print('Superman swimming speed: ${superman.swimmingSpeed} km/h');
  print('Superman walking speed: ${superman.walkingSpeed} km/h');
}

// Example with cascade operator and mixins
void demonstrateCascadeWithMixins() {
  print('\n=== MIXINS WITH CASCADE OPERATOR ===\n');

  var duck = Duck()
    ..quack()
    ..fly()
    ..swim()
    ..quack();

  print('Duck created and performed multiple actions using cascade! ${duck}');
}

void main() {
  demonstrateMixins();
  demonstrateCascadeWithMixins();
}
