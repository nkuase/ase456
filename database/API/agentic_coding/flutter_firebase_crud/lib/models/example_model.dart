import 'package:cloud_firestore/cloud_firestore.dart';

class ExampleModel {
  final String? id;
  final String foo;
  final int bar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExampleModel({
    this.id,
    required this.foo,
    required this.bar,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from Firestore document to ExampleModel
  factory ExampleModel.fromMap(Map<String, dynamic> map) {
    return ExampleModel(
      id: map['id'] as String?,
      foo: map['foo'] as String,
      bar: map['bar'] as int,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert ExampleModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'foo': foo,
      'bar': bar,
      // Don't include createdAt and updatedAt as they are handled by the service
    };
  }

  // Create a copy with modified fields
  ExampleModel copyWith({
    String? id,
    String? foo,
    int? bar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExampleModel(
      id: id ?? this.id,
      foo: foo ?? this.foo,
      bar: bar ?? this.bar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ExampleModel(id: $id, foo: $foo, bar: $bar, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExampleModel &&
        other.id == id &&
        other.foo == foo &&
        other.bar == bar &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, foo, bar, createdAt, updatedAt);
  }
}