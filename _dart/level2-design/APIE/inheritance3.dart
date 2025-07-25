abstract class Interface1 { // interface means only empty body
  void one();
}
abstract class Interface2 extends Interface1 {
  void two();
}
abstract class Interface3 extends Interface1 {
  void three();
}
abstract class Interface {
  void zero();
}
class Concrete implements Interface 
{
  String value;
  Concrete(this.value);
  @override 
  void zero() {print("Zero");}
}
// You must override all the methods in Interface2 and Interface3
class Concrete2 extends Concrete implements Interface2, Interface3 {
  Concrete2(value) : super(value);
  @override
  void one() {print("One $value");}
  @override
  void two() {print("Two $value");}
  @override
  void three() {print("Three $value");}  
}

main() {
  Concrete2 c = Concrete2('value');
  c.zero(); // reuse Concrete's one
  c.one(); 
  c.two();
  c.three(); 
}