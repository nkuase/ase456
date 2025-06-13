abstract class Interface1 { // interface means only empty body
  void one();
}
abstract class Interface2 extends Interface1 {
  void two();
}
abstract class Interface3 { // interface means only empty body
  void three();
}
class Concrete implements Interface2, Interface3 
{
  @override
  void one() {print("One");}
  @override
  void two() {print("Two");}
  @override
  void three() {print("Three");}
}

main() {
  var c = Concrete();
  c.one(); 
  c.two();
  c.three();
}