class BigObject {
}

class Test {
  static final _objects = List<BigObject>.empty(growable:true);
  factory Test(BigObject obj) {
    if (!_objects.contains(obj)) {
      print("Added object $obj");
      _objects.add(obj);
    }
    return Test._default();
  }
  // This is a private named constructor and thus it can't be called 
  // from the outside
  Test._default() {
    //do something...
    print("Test._default invoked");
  }
}  

main() {
  var b = BigObject();
  var t = Test(b); 
  var t2 = Test(b); // not added the same object, but invoke the constructor
}