/// Simple FooBar model for educational purposes
/// 
/// This model demonstrates:
/// - Basic data modeling in Dart
/// - Serialization to/from Map for Firebase
/// - Simple validation
class FooBar {
  final String? id;      // Document ID from Firebase (nullable for new documents)
  final String foo;      // String field
  final int bar;         // Integer field

  /// Constructor with required fields
  FooBar({
    this.id,
    required this.foo,
    required this.bar,
  });

  /// Convert FooBar object to Map for Firebase storage
  /// This is used when saving data to Firestore
  Map<String, dynamic> toMap() {
    return {
      'foo': foo,
      'bar': bar,
    };
  }

  /// Create FooBar object from Map (from Firebase)
  /// This is used when reading data from Firestore
  static FooBar fromMap(Map<String, dynamic> map, [String? documentId]) {
    return FooBar(
      id: documentId,
      foo: map['foo'] ?? '',
      bar: map['bar'] ?? 0,
    );
  }

  /// Create a copy of this FooBar with some fields updated
  /// Useful for update operations
  FooBar copyWith({
    String? id,
    String? foo,
    int? bar,
  }) {
    return FooBar(
      id: id ?? this.id,
      foo: foo ?? this.foo,
      bar: bar ?? this.bar,
    );
  }

  /// String representation for debugging and display
  @override
  String toString() {
    return 'FooBar{id: $id, foo: $foo, bar: $bar}';
  }

  /// Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FooBar &&
        other.id == id &&
        other.foo == foo &&
        other.bar == bar;
  }

  @override
  int get hashCode => id.hashCode ^ foo.hashCode ^ bar.hashCode;
}
