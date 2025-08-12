import 'dart:convert';

class MarpConfig {
  final String theme;
  final String size;
  final bool math;
  final String author;

  // Constructor with optional named parameters and default values
  MarpConfig({
    this.theme = 'default',
    this.size = '16:9',
    this.math = false,
    this.author = 'Anonymous',
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {'theme': theme, 'size': size, 'math': math, 'author': author};
  }

  // Create object from JSON map
  factory MarpConfig.fromJson(Map<String, dynamic> json) {
    return MarpConfig(
      theme: json['theme'] ?? 'default',
      size: json['size'] ?? '16:9',
      math: json['math'] ?? false,
      author: json['author'] ?? 'Anonymous',
    );
  }
}

void main() {
  var m = MarpConfig();
  var jsonString = jsonEncode(m.toJson());
  print(jsonString);

  var marp = jsonDecode(jsonString);
  var m2 = MarpConfig.fromJson(marp);
  print(m2);
  print(m2.theme);
}
