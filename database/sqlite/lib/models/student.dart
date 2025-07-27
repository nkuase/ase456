import 'package:pocketbase/pocketbase.dart';

/// Student model for PocketBase
/// Demonstrates how to create a data model that works with PocketBase
class Student {
  final String id; // Document ID
  final String name; // Student name
  final int age; // Student age
  final String major; // Student's major
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
  /// We don't include ID here because PocketBase generates it
  /// and we don't need to send it back when creating a new record.
  /// Note: createdAt is converted to ISO8601 string format for consistency
  /// and to ensure it can be parsed correctly by PocketBase.
  /// This method is useful for creating new records.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'major': major,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// record.model is used to convert a Map to a Student object
  factory Student.fromJson(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      age: map['age'] as int? ?? 0,
      major: map['major'] as String? ?? '',
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  /// Helper method to safely parse DateTime from dynamic value
  /// This demonstrates proper error handling and type safety
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }

    // Handle different possible types
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        // If parsing fails, return current time
        return DateTime.now();
      }
    }

    // If value is already DateTime, return it
    if (value is DateTime) {
      return value;
    }

    // Fallback: return current time
    return DateTime.now();
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
