// The FooBar class (your model)
class FooBar {
  String foo;
  int bar;

  FooBar({
    required this.foo,
    required this.bar,
  });

  factory FooBar.fromRow(Row row) {
    return FooBar(
      foo: row['foo'] as String,
      bar: row['bar'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'foo': foo,
    'bar': bar,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FooBar && other.foo == foo && other.bar == bar;
  }

  @override
  int get hashCode => foo.hashCode ^ bar.hashCode;
}
