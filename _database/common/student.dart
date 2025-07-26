/// Student model that works across all database implementations
/// (IndexedDB, SQLite, Firebase, etc.)
class Student {
  final String id;
  final String name;
  final int age;
  final String major;
  final DateTime createdAt;

  const Student({
    required this.id,
    required this.name,
    required this.age,
    required this.major,
    required this.createdAt,
  });

  /// Convert Student to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'major': major,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create Student from Map (for all database types)
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      major: map['major'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  /// Create a copy of Student with some fields updated
  Student copyWith({
    String? id,
    String? name,
    int? age,
    String? major,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      major: major ?? this.major,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, age: $age, major: $major, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student &&
        other.id == id &&
        other.name == name &&
        other.age == age &&
        other.major == major &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, age, major, createdAt);
  }
}
