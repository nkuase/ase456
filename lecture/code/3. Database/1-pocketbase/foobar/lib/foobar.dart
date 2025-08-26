// The FooBar class (your model)
class FooBar {
  String foo;
  int bar;

  FooBar({
    required this.foo,
    required this.bar,
  });

  factory FooBar.fromJson(Map<String, dynamic> json) {
    return FooBar(
      foo: json['foo'] as String,
      bar: json['bar'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
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
