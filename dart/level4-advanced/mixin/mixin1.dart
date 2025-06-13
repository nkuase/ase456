// mixin is a class that can be mixed in other classes
// Notice that there is no "this" in mixins

mixin Walking {
  walk() => print("Walking");
}
mixin Coding {
  code() => print("Coding");
}
         
class Human with Walking {}
// class Developer extends Human with Coding {}
class Developer with Coding, Walking {}

void main() {
  final me = Human();
  me.walk();
  final prg = Developer();
  prg.code();
  prg.walk();
}