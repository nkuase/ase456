class CInterface1 { // interface means only empty body
  void one() {}
}
class CInterface2 extends CInterface1 {
  void two() {}
}
class CInterface3 extends CInterface1 {
  void three() {}
}

class CInterface {
  void zero() {}
}
class Concrete extends CInterface 
{
  String value;
  Concrete(this.value);
  @override 
  void zero() {print("Zero");}
}
class Concrete2 extends Concrete implements CInterface2, CInterface3 {
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
  c.zero(); 
  c.one(); 
  c.two();
  c.three(); 
}