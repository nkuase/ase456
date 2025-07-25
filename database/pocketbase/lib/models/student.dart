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
      name: record.data['name'] as String? ?? '',
      age: record.data['age'] as int? ?? 0,
      major: record.data['major'] as String? ?? '',
      createdAt: _parseDateTime(record.data['createdAt']),
    );
  }

  /// Create Student from Map (useful for testing)
  factory Student.fromMap(Map<String, dynamic> map, String id) {
    return Student(
      id: id,
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
