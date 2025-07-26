// The FooBar class (your model)
// For IndexedDB, we need to include an ID field
class FooBar {
  String? id;  // Optional ID field for IndexedDB
  String foo;
  int bar;

  FooBar({
    this.id,
    required this.foo,
    required this.bar,
  });

  // Constructor for creating from database record
  factory FooBar.fromJson(Map<String, dynamic> json) {
    return FooBar(
      id: json['id'] as String?,
      foo: json['foo'] as String,
      bar: json['bar'] as int,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'foo': foo,
        'bar': bar,
      };

  // Convert to simple map without ID (for compatibility)
  Map<String, dynamic> toJsonWithoutId() => {
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
  int get hashCode => Object.hash(id, foo, bar);

  @override
  String toString() => 'FooBar(id: $id, foo: $foo, bar: $bar)';
}
