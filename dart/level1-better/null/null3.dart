// Warning: Operand of null-aware operation '??' has type 'int' which excludes null for Dart 3.0
main() {
  //String? name = null; 
  String? name = "Hello";
  if (name != null) {
    print(name.length);
  } else {
    print(0);
  }  
  print(name?.length ?? 0); 
}