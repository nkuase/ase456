import 'package:cloud_firestore/cloud_firestore.dart';

/// Student model demonstrating Firebase document mapping
class Student {
  final String? id;           // Document ID (auto-generated)
  final String name;          // Student name
  final int age;              // Student age
  final String major;         // Student's major
  final DateTime? createdAt;  // Auto-added timestamp
  final DateTime? updatedAt;  // Auto-updated timestamp

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.major,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert from Firestore document to Student object
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String?,
      name: map['name'] as String,
      age: map['age'] as int,
      major: map['major'] as String,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert Student object to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'major': major,
      // createdAt and updatedAt handled automatically by service
    };
  }

  /// Create a copy of this Student with optional new values
  Student copyWith({
    String? id,
    String? name,
    int? age,
    String? major,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      major: major ?? this.major,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, age: $age, major: $major, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student &&
        other.id == id &&
        other.name == name &&
        other.age == age &&
        other.major == major;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        age.hashCode ^
        major.hashCode;
  }
}
