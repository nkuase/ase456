// Student data model
class Student {
  final String id;
  final String name;
  final int age;
  final String major;

  Student({
    required this.id,
    required this.name,
    required this.age,
    required this.major,
  });

  // Convert student to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'major': major,
    };
  }

  // Create student from Map
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      major: map['major'] as String,
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, age: $age, major: $major}';
  }
}
