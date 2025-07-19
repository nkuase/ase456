/// A simple Student model to demonstrate database operations
/// This model represents a university student with basic information
class Student {
  final String id;
  final String name;
  final String email;
  final int age;
  final String major;
  final DateTime createdAt;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.major,
    required this.createdAt,
  });

  /// Convert Student object to Map for database storage
  /// This is essential for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'major': major,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create Student object from Map (from database)
  /// This is the inverse operation of toMap()
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      age: map['age'] as int,
      major: map['major'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Convert to JSON string (useful for API calls)
  String toJson() {
    return '''
{
  "id": "$id",
  "name": "$name",
  "email": "$email",
  "age": $age,
  "major": "$major",
  "created_at": "${createdAt.toIso8601String()}"
}''';
  }

  /// Create a copy of Student with modified fields
  /// This is useful for updates without mutating the original object
  Student copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    String? major,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      major: major ?? this.major,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name, email: $email, age: $age, major: $major)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
