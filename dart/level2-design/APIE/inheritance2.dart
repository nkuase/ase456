class CInterface {
  String _value;
  CInterface(this._value);
  @override 
  void zero() {print("Zero");}
}
class Concrete extends CInterface 
{
  Concrete(value) : super(value);
  get value => _value;
}
main() {
  var c = Concrete('Value');
  c.zero();
  print(c.value);
}