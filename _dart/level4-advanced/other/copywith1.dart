class Person {
  final String name;
  final int age;
  const Person({
      required this.name,
      required this.age,
  });
}

class PersonClonable {
  final String name;
  final int age;
  const PersonClonable({
      required this.name,
      required this.age,
  });
  PersonClonable copyWith({
      String? name,
      int? age,
  }) => PersonClonable(
    name: name ?? this.name,
    age: age ?? this.age
  );
}

void main() {
  const me = Person(name: "Alberto", age: 25 );
  
  // shallow copy
  const anotherMe = me;
  print(me == anotherMe); // they are refencing the same object. 
  
  // deep copy
  const me2 = PersonClonable(name: "Alberto", age: 25 );
  final anotherMe2 = me2.copyWith();
  final futureMe = me2.copyWith(age: 35);
  print(me2 == anotherMe2);
  print(me2 == futureMe);
  print(me2.name == futureMe.name); // same  
  print(me2.age == futureMe.age); // different
  print(anotherMe2.age);
  print(futureMe.age);
}