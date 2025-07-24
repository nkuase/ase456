import 'package:pocketbase/pocketbase.dart';

/// Student model for PocketBase
/// Demonstrates how to create a data model that works with PocketBase
class Student {
  final String id;        // Document ID
  final String name;      // Student name  
  final int age;          // Student age
  final String major;     // Student's major
  final DateTime createdAt; // Timestamp

  const Student({
    required this.id,
    required this.name,
    required this.age,
    required this.major,
    required this.createdAt,
  });

  /// Convert Student to Map for PocketBase
  /// This is used when saving data to PocketBase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'major': major,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create Student from PocketBase RecordModel
  /// This is used when reading data from PocketBase
  factory Student.fromRecord(RecordModel record) {
    return Student(
      id: record.id,
      name: record.data['name'] ?? '',
      age: record.data['age'] ?? 0,
      major: record.data['major'] ?? '',
      createdAt: DateTime.parse(record.data['createdAt'] ?? 
                 DateTime.now().toIso8601String()),
    );
  }

  /// Create Student from Map (useful for testing)
  factory Student.fromMap(Map<String, dynamic> map, String id) {
    return Student(
      id: id,
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      major: map['major'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? 
                 DateTime.now().toIso8601String()),
    );
  }

  /// Create a copy of Student with updated fields
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
    return id.hashCode ^
        name.hashCode ^
        age.hashCode ^
        major.hashCode ^
        createdAt.hashCode;
  }
}
