import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';

/// Universal Student model that works with all database backends
@JsonSerializable()
class Student {
  /// Unique identifier - can be String (Firebase, PocketBase) or int (SQLite)
  final String? id;
  
  /// Student's full name
  final String name;
  
  /// Student's age
  final int age;
  
  /// Student's major/field of study
  final String major;
  
  /// When the record was created (ISO 8601 string for JSON compatibility)
  final String? createdAt;
  
  /// When the record was last updated (ISO 8601 string for JSON compatibility)
  final String? updatedAt;

  const Student({
    this.id,
    required this.name,
    required this.age,
    required this.major,
    this.createdAt,
    this.updatedAt,
  });

  /// Create Student from JSON (works with all database formats)
  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

  /// Convert Student to JSON (works with all database formats)
  Map<String, dynamic> toJson() => _$StudentToJson(this);

  /// Create a copy with modified fields
  Student copyWith({
    String? id,
    String? name,
    int? age,
    String? major,
    String? createdAt,
    String? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      major: major ?? this.major,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to Map for database storage (without id for creation)
  Map<String, dynamic> toCreateMap() {
    final map = toJson();
    map.remove('id'); // Remove ID for creation
    return map;
  }

  /// Convert to Map for database updates (without id and createdAt)
  Map<String, dynamic> toUpdateMap() {
    final map = toJson();
    map.remove('id');
    map.remove('createdAt');
    map['updatedAt'] = DateTime.now().toIso8601String();
    return map;
  }

  /// Validate student data
  bool isValid() {
    return name.trim().isNotEmpty &&
           age >= 16 && age <= 120 &&
           major.trim().isNotEmpty;
  }

  /// Get validation errors
  List<String> getValidationErrors() {
    final errors = <String>[];
    
    if (name.trim().isEmpty) {
      errors.add('Name cannot be empty');
    }
    
    if (age < 16 || age > 120) {
      errors.add('Age must be between 16 and 120');
    }
    
    if (major.trim().isEmpty) {
      errors.add('Major cannot be empty');
    }
    
    return errors;
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, age: $age, major: $major}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student &&
        other.id == id &&
        other.name == name &&
        other.age == age &&
        other.major == major;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, age, major);
  }
}

/// Query parameters for filtering and sorting
@JsonSerializable()
class StudentQuery {
  final String? nameContains;
  final String? major;
  final int? minAge;
  final int? maxAge;
  final String? sortBy;
  final bool sortDescending;
  final int? limit;
  final int? offset;

  const StudentQuery({
    this.nameContains,
    this.major,
    this.minAge,
    this.maxAge,
    this.sortBy,
    this.sortDescending = false,
    this.limit,
    this.offset,
  });

  factory StudentQuery.fromJson(Map<String, dynamic> json) => _$StudentQueryFromJson(json);
  Map<String, dynamic> toJson() => _$StudentQueryToJson(this);

  /// Convert query parameters to URL query string
  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    
    if (nameContains != null) params['nameContains'] = nameContains!;
    if (major != null) params['major'] = major!;
    if (minAge != null) params['minAge'] = minAge.toString();
    if (maxAge != null) params['maxAge'] = maxAge.toString();
    if (sortBy != null) params['sortBy'] = sortBy!;
    if (sortDescending) params['sortDescending'] = 'true';
    if (limit != null) params['limit'] = limit.toString();
    if (offset != null) params['offset'] = offset.toString();
    
    return params;
  }

  /// Create query from URL parameters
  factory StudentQuery.fromQueryParams(Map<String, String> params) {
    return StudentQuery(
      nameContains: params['nameContains'],
      major: params['major'],
      minAge: params['minAge'] != null ? int.tryParse(params['minAge']!) : null,
      maxAge: params['maxAge'] != null ? int.tryParse(params['maxAge']!) : null,
      sortBy: params['sortBy'],
      sortDescending: params['sortDescending'] == 'true',
      limit: params['limit'] != null ? int.tryParse(params['limit']!) : null,
      offset: params['offset'] != null ? int.tryParse(params['offset']!) : null,
    );
  }
}
