// The FooBar class (your model) - Firebase version
import 'package:cloud_firestore/cloud_firestore.dart';

class FooBar {
  String? id; // Firebase document ID
  String foo;
  int bar;
  DateTime? createdAt;

  FooBar({
    this.id,
    required this.foo,
    required this.bar,
    this.createdAt,
  });

  /// Create FooBar from Firebase document snapshot
  factory FooBar.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FooBar(
      id: doc.id,
      foo: data['foo'] as String,
      bar: data['bar'] as int,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Create FooBar from JSON data (Map)
  factory FooBar.fromJson(Map<String, dynamic> json) {
    return FooBar(
      id: json['id'] as String?,
      foo: json['foo'] as String,
      bar: json['bar'] as int,
      createdAt: json['createdAt'] is Timestamp 
          ? (json['createdAt'] as Timestamp).toDate()
          : json['createdAt'] is String
              ? DateTime.parse(json['createdAt'] as String)
              : null,
    );
  }

  /// Convert FooBar to JSON for Firebase storage
  Map<String, dynamic> toJson() {
    final data = {
      'foo': foo,
      'bar': bar,
    };
    
    // Add createdAt if it exists
    if (createdAt != null) {
      data['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    
    return data;
  }

  /// Convert to Map for easy debugging and testing
  Map<String, dynamic> toMap() => {
        'id': id,
        'foo': foo,
        'bar': bar,
        'createdAt': createdAt?.toIso8601String(),
      };

  /// Create a copy with updated fields
  FooBar copyWith({
    String? id,
    String? foo,
    int? bar,
    DateTime? createdAt,
  }) {
    return FooBar(
      id: id ?? this.id,
      foo: foo ?? this.foo,
      bar: bar ?? this.bar,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FooBar && 
           other.foo == foo && 
           other.bar == bar;
  }

  @override
  int get hashCode => foo.hashCode ^ bar.hashCode;

  @override
  String toString() {
    return 'FooBar(id: $id, foo: $foo, bar: $bar, createdAt: $createdAt)';
  }
}
