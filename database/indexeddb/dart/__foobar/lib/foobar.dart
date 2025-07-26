// The FooBar class (your model)
// Identical to PocketBase version - data models don't change between database types
class FooBar {
  String? id;  // Added ID field for IndexedDB key
  String foo;
  int bar;

  FooBar({
    this.id,    // ID is optional for new records
    required this.foo,
    required this.bar,
  });

  factory FooBar.fromJson(Map<String, dynamic> json) {
    return FooBar(
      id: json['id']?.toString(),
      foo: json['foo']?.toString() ?? '',
      bar: _parseIntSafely(json['bar']),
    );
  }

  /// Safely parse an integer from dynamic value
  static int _parseIntSafely(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'foo': foo,
        'bar': bar,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FooBar && 
           other.id == id &&
           other.foo == foo && 
           other.bar == bar;
  }

  @override
  int get hashCode => (id?.hashCode ?? 0) ^ foo.hashCode ^ bar.hashCode;

  @override
  String toString() => 'FooBar(id: $id, foo: $foo, bar: $bar)';
}
